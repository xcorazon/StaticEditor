package pr1
{
  import flash.display.*;
  import flash.events.*;
  import flash.text.*; //TextField;
  import flash.ui.Keyboard;
  import flash.geom.Point;
  import pr1.forces.*;
  import pr1.razmers.*;
  import pr1.Shapes.MomentCreator;
  import pr1.Shapes.Creator;
  import pr1.Shapes.SegmentCreator;
  import pr1.Shapes.ConcentratedForceCreator;
  import pr1.Shapes.DistributedForceRCreator;
  import pr1.Shapes.DistributedForceTCreator;
  import pr1.Shapes.LinearDimensionCreator;
  import pr1.Shapes.LinearDimensionCreatorX;
  import pr1.Shapes.LinearDimensionCreatorY;
  import pr1.Shapes.AngleDimensionCreator;
  import pr1.Shapes.AngleDimensionCreatorX;
  import pr1.Shapes.AngleDimensionCreatorY;
  import pr1.Shapes.SealingCreator;
  import pr1.Shapes.FixedJointCreator;
  import pr1.Shapes.MovableJointCreator;
  import pr1.Snap;
  import pr1.opora.*;
  import pr1.tests.Workspace;
  import com.adobe.images.PNGEncoder;
  import flash.system.Security;
  import pr1.panels.MainPanel;
  import pr1.Shapes.Segment;
  import flash.net.*;
  import flash.utils.ByteArray;
  import flash.utils.Timer;
  import pr1.events.PanelEvent;


  public final class Frame extends Sprite
  {
    [Embed(source='..\\symbol.ttf', fontName='Symbol1', embedAsCFF='false')]
    const myNewFont:Class;

    private var creator:Creator;

    public var qForcesR:Array;
    public var qForcesT:Array;
    public var pForces:Array;
    public var mForces:Array;

    public var dimensionsX:Array;
    public var dimensionsY:Array;
    public var freeDimensions:Array;

    public var angles:Array;
    public var segments:Array;

    public var opora1:Array;
    public var opora2:FixedJointContainer;
    public var opora3:SealingContainer;
    public var lastNonUsedJoint:int;


    private var mainPanel:MainPanel;
    public var parent1:Workspace;
    private var outData:OutDataCreator;
    private var snap1:Snap;
    // таймер для задержки после отправки всех данных на сайт
    private var timer:Timer;
    // имя файла для решения
    private var _resolveFileName:String;
    
    private static var _instance:Frame;

    public function Frame()
    {
      if(_instance)
        throw new Error("Singleton Frame... use getInstance()");
        
      _instance = this;
      Security.allowDomain("http://teormeh.com");
      Security.loadPolicyFile("http://teormeh.com/crossdomain.xml");

      //для тестирования использую эту политику
      //Security.allowDomain("http://teormeh");
      //Security.loadPolicyFile("http://teormeh/crossdomain.xml");

      dimensionsX = new Array();
      dimensionsY = new Array();
      freeDimensions = new Array();

      angles = new Array();
      pForces = new Array();
      mForces = new Array();

      qForcesR = new Array();
      qForcesT = new Array();

      opora1 = new Array();
      //freeOpora1 = null;
      opora2 = null;
      opora3 = null;
      segments = new Array();
      lastNonUsedJoint = 5000;

      parent1 = new Workspace();
      parent1.graphics.beginFill(0xffffff, 0);
      parent1.graphics.drawRect(0,0,800,600);
      parent1.graphics.endFill();
      addChild(parent1);
      parent1.x = 0;
      parent1.y = 0;
      snap1 = new Snap(segments, qForcesR, qForcesT, pForces, joints);
      parent1.snap = snap1;

      mainPanel = new MainPanel();
      outData = new OutDataCreator();
      addChild(mainPanel);

      mainPanel.addEventListener(MainPanel.CREATE_OBJECT, createObject);
      mainPanel.addEventListener(MainPanel.SEND_DATA_TO_SERVER, onSendData);
      addEventListener(ComConst.CHANGE_ELEMENT, onChangeElement);
      addEventListener(ComConst.DELETE_ELEMENT, onDeleteElement);
      addEventListener(ComConst.LOCK_ALL, lockAllElements);
    }
    
    public static function get Instance():Frame
    {
      if(!_instance)
      {
        new Frame();
      } 
      return _instance;
    }

    private function createObject(e:PanelEvent)
    {
      lockAllElements();
      creator = e.object;
      trace(e.object);
      creator.addEventListener(Creator.CREATE_DONE, objectCreationDone);
      creator.addEventListener(Creator.CREATE_CANCEL, removeEvents);
      creator.create();
    }
    
    private function objectCreationDone(e:Event)
    {
      addObject(creator.result);
      removeEvents(e);
    }
    
    private function removeEvents(e:Event)
    {
      unlockAllElements();
      creator.removeEventListener(Creator.CREATE_DONE, objectCreationDone);
      creator.removeEventListener(Creator.CREATE_CANCEL, removeEvents);
      mainPanel.setButtonsActiveState();
    }
    
    private function addObject(obj:*)
    {
      parent1.addChild(obj);
      if (obj is Segment)
        segments.push(obj);
      else if (obj is ConcentratedForce)
        pForces.push(obj);
      else if (obj is Moment)
        mForces.push(obj);
      else if (obj is DistributedForceR)
        qForcesR.push(obj);
      else if (obj is DistributedForceT)
        qForcesT.push(obj);
      else if (obj is LinearDimensionContainer)
        freeDimensions.push(obj);
      else if (obj is LinearDimensionXContainer)
        dimensionsX.push(obj);
      else if (obj is LinearDimensionYContainer)
        dimensionsY.push(obj);
      else if (obj is AngleDimensionContainer)
        angles.push(obj);
      else if (obj is MovableJointContainer)
      {
        opora1.push(obj);
        lastNonUsedJoint++;
      }
      else if (obj is FixedJointContainer)
      {
        opora2 = obj;
        lastNonUsedJoint++;
      }
      else if (obj is SealingContainer)
        opora3 = obj;
    }

    private function get joints():Array {
      var jArr = new Array();
      for each ( var op in opora1){
        if(op != null){
          jArr.push(op);
        }
      }
      if(opora2 != null){
        jArr.push(opora2);
      }
      return jArr;
    }

    private function updateConcentratedForcesAndAngles(force:ConcentratedForce){
      for each (var f:ConcentratedForce in pForces){
        if(f.forceName == force.forceName){
          f.units = force.units;
          f.forceValue = force.forceValue;
        }
        if(f.angleName == force.angleName && force.angleName != ""){
          f.angleValue = force.angleValue;
        }
      }
      for each ( var joint in opora1){
        if(joint.angle == force.angleName && force.angleName != ""){
          joint.angleValue = force.angleValue;
        }
      }
      for each (var ang:AngleDimensionContainer in angles){
        if(ang.razmerName == force.angleName){
          ang.razmerValue = force.angleValue;
        }
      }
    }
    private function updateMoments(moment:Moment){
      for each ( var m:Moment in mForces){
        if(m.momentName == moment.momentName){
          m.momentValue = moment.momentValue;
          m.units = moment.units;
        }
      }
    }
    private function updateDistributedForces(q:*){
      for each (var distributedForce in qForcesR){
        if(distributedForce.forceName == q.forceName){
          distributedForce.forceValue = q.forceValue;
          distributedForce.units = q.units;
        }
      }
      for each (distributedForce in qForcesT){
        if(distributedForce.forceName == q.forceName){
          distributedForce.forceValue = q.forceValue;
          distributedForce.units = q.units;
        }
      }
    }
    private function updateLinearDimensions(dimension:*){
      for each (var d in freeDimensions){
        if(d.razmerName == dimension.razmerName){
          d.razmerValue = dimension.razmerValue;
          d.units = dimension.units;
        }
      }
      for each (d in dimensionsX){
        if(d.razmerName == dimension.razmerName){
          d.razmerValue = dimension.razmerValue;
          d.units = dimension.units;
        }
      }
      for each (d in dimensionsY){
        if(d.razmerName == dimension.razmerName){
          d.razmerValue = dimension.razmerValue;
          d.units = dimension.units;
        }
      }
    }
    private function updateAngleDimensions(angle:*){
      if(angle is MovableJointContainer){
        for each (var ang:AngleDimensionContainer in angles){
          if(ang.razmerName == angle.angle){
            ang.razmerValue = angle.angleValue;
          }
        }
        for each (var f:ConcentratedForce in pForces){
          if(f.angleName == angle.angle){
            f.angleValue = angle.angleValue;
          }
        }
        for each ( var joint in opora1){
          if(joint.angle == angle.angle){
            joint.angleValue = angle.angleValue;
          }
        }
      } else {
        for each (ang in angles){
          if(ang.razmerName == angle.razmerName){
            ang.razmerValue = angle.razmerValue;
          }
        }
        for each (f in pForces){
          if(f.angleName == angle.razmerName){
            f.angleValue = angle.razmerValue;
          }
        }
        for each ( joint in opora1){
          if(joint.angle == angle.razmerName){
            joint.angleValue = angle.razmerValue;
          }
        }
      }
    }
    private function removeExcessDimensions(screenCoord:Point){
      for each (var f:ConcentratedForce in pForces){
        if(f.x == screenCoord.x && f.y == screenCoord.y) return;
      }
      for each (var q1:DistributedForceR in qForcesR){
        if(q1.firstScreenCoord.equals(screenCoord) || q1.secondScreenCoord.equals(screenCoord))
          return;
      }
      for each (var q2:DistributedForceT in qForcesT){
        if(q2.firstScreenCoord.equals(screenCoord) || q2.secondScreenCoord.equals(screenCoord))
          return;
      }
      for each (var joint:* in opora1){
        if(joint.x == screenCoord.x && joint.y == screenCoord.y)
          return;
      }
      for each (var seg:Segment in segments){
        if(seg.firstScreenCoord.equals(screenCoord) || seg.secondScreenCoord.equals(screenCoord))
          return;
      }
      if(opora2 != null){
        if(opora2.x == screenCoord.x && opora2.y == screenCoord.y)
          return;
      }
      if(opora3 != null){
        if(opora3.x == screenCoord.x && opora3.y == screenCoord.y)
          return;
      }

      for each (var dimF:LinearDimensionContainer in freeDimensions){
        if(dimF.firstPointScreenCoord.equals(screenCoord) || dimF.secondPointScreenCoord.equals(screenCoord))
          removeDimension(dimF);
      }
      for each (var dimX:LinearDimensionXContainer in dimensionsX){
        if(dimX.firstPointScreenCoord.equals(screenCoord) || dimX.secondPointScreenCoord.equals(screenCoord))
          removeDimension(dimX);
      }
      for each (var dimY:LinearDimensionYContainer in dimensionsY){
        if(dimY.firstPointScreenCoord.equals(screenCoord) || dimY.secondPointScreenCoord.equals(screenCoord))
          removeDimension(dimY);
      }
    }
    private function removeDimension(dim){
      for (var i in freeDimensions){
        if( dim == freeDimensions[i]){
          LinearDimensionContainer(dim).destroy();
          parent1.removeChild(dim);
          freeDimensions.splice(i,1)
          return;
        }
      }
      for ( i in dimensionsX){
        if( dim == dimensionsX[i]){
          LinearDimensionXContainer(dim).destroy();
          parent1.removeChild(dim);
          dimensionsX.splice(i,1)
        }
      }
      for ( i in dimensionsY){
        if( dim == dimensionsY[i]){
          LinearDimensionYContainer(dim).destroy();
          parent1.removeChild(dim);
          dimensionsY.splice(i,1)
        }
      }
    }

    private function lockAllElements(e:Event = null){
      for each (var element in pForces){
        element.lock();
      }
      for each (element in mForces){
        element.lock();
      }
      for each (element in qForcesR){
        element.lock();
      }
      for each (element in qForcesT){
        element.lock();
      }
      for each (element in dimensionsX){
        element.lock();
      }
      for each (element in dimensionsY){
        element.lock();
      }
      for each (element in freeDimensions){
        element.lock();
      }
      for each (element in angles){
        element.lock();
      }
      for each (element in opora1){
        element.lock();
      }
      if(opora2 != null){
        opora2.lock();
      }
      if(opora3 != null){
        opora3.lock();
      }
    }
    private function unlockAllElements(){
      for each (var element in pForces){
        element.unlock();
      }
      for each (element in mForces){
        element.unlock();
      }
      for each (element in qForcesR){
        element.unlock();
      }
      for each (element in qForcesT){
        element.unlock();
      }
      for each (element in dimensionsX){
        element.unlock();
      }
      for each (element in dimensionsY){
        element.unlock();
      }
      for each (element in freeDimensions){
        element.unlock();
      }
      for each (element in angles){
        element.unlock();
      }
      for each (element in opora1){
        element.unlock();
      }
      if(opora2 != null){
        opora2.unlock();
      }
      if(opora3 != null){
        opora3.unlock();
      }
    }

    private function onChangeElement(e:Event){
      trace("Изменения в объекте: ", e.target);
      unlockAllElements()
      if(e.target is ConcentratedForce) updateConcentratedForcesAndAngles(ConcentratedForce(e.target));
      if(e.target is Moment) updateMoments(Moment(e.target));
      if(e.target is DistributedForceT || e.target is DistributedForceR)
        updateDistributedForces(e.target);
      if(e.target is LinearDimensionYContainer || e.target is LinearDimensionXContainer
         || e.target is LinearDimensionContainer)
         updateLinearDimensions(e.target);
      if(e.target is AngleDimensionContainer) updateAngleDimensions(e.target);
      if(e.target is MovableJointContainer) updateAngleDimensions(e.target);
    }
    private function onDeleteElement(e:Event){
      trace("Удаление объекта: ", e.target);
      unlockAllElements();
      if(e.target is ConcentratedForce){
        for (var i in pForces){
          if(pForces[i] == e.target){
            pForces.splice(i, 1);
            ConcentratedForce(e.target).destroy();
            parent1.removeChild(ConcentratedForce(e.target));
            removeExcessDimensions(new Point(e.target.x, e.target.y));
          }
        }
      }
      if(e.target is DistributedForceR){
        for (i in qForcesR){
          if(qForcesR[i] == e.target){
            qForcesR.splice(i, 1);
            DistributedForceR(e.target).destroy();
            parent1.removeChild(DistributedForceR(e.target));
            removeExcessDimensions(DistributedForceR(e.target).firstScreenCoord);
            removeExcessDimensions(DistributedForceR(e.target).secondScreenCoord);
          }
        }
      }
      if(e.target is DistributedForceT){
        for (i in qForcesT){
          if(qForcesT[i] == e.target){
            qForcesT.splice(i, 1);
            DistributedForceT(e.target).destroy();
            parent1.removeChild(DistributedForceT(e.target));
            removeExcessDimensions(DistributedForceT(e.target).firstScreenCoord);
            removeExcessDimensions(DistributedForceT(e.target).secondScreenCoord);
          }
        }
      }
      if(e.target is Moment){
        for (i in mForces){
          if(mForces[i] == e.target){
            mForces.splice(i, 1);
            Moment(e.target).destroy();
            parent1.removeChild(Moment(e.target));
            removeExcessDimensions(new Point(e.target.x, e.target.y));
          }
        }
      }
      if(e.target is AngleDimensionContainer){
        for (i in angles){
          if(angles[i] == e.target){
            angles.splice(i, 1);
            AngleDimensionContainer(e.target).destroy();
            parent1.removeChild(AngleDimensionContainer(e.target));
          }
        }
      }
      if(e.target is LinearDimensionContainer || e.target is LinearDimensionXContainer
         || e.target is LinearDimensionYContainer){
        removeDimension(e.target);
      }
      if(e.target is MovableJointContainer){
        for (i in opora1){
          if(opora1[i] == e.target){
            opora1.splice(i, 1);
            MovableJointContainer(e.target).destroy();
            parent1.removeChild(MovableJointContainer(e.target));
            removeExcessDimensions(new Point(e.target.x, e.target.y));
          }
        }
      }
      if(e.target is FixedJointContainer){
        if(opora2 == e.target){
          opora2 = null;
          FixedJointContainer(e.target).destroy();
          parent1.removeChild(FixedJointContainer(e.target));
          removeExcessDimensions(new Point(e.target.x, e.target.y));
        }
      }
      if(e.target is SealingContainer){
        if(opora3 == e.target){
          opora3 = null;
          SealingContainer(e.target).destroy();
          parent1.removeChild(SealingContainer(e.target));
          removeExcessDimensions(new Point(e.target.x, e.target.y));
        }
      }
      mainPanel.setButtonsActiveState();
    }


    private function onSendData(e:Event){
      createOutData();
      // получаем имя для сохранения файла
      var loader:URLLoader = new URLLoader();
      var req:URLRequest = new URLRequest("http://teormeh.com/index.php?option=com_statr&task=get_name");

      // для тестирования
      //var req:URLRequest = new URLRequest("http://teormeh/index.php?option=com_statr&task=get_name");

      req.method = URLRequestMethod.POST;
      loader.dataFormat = URLLoaderDataFormat.TEXT;
      loader.load(req);
      loader.addEventListener(Event.COMPLETE, completeHandler);
    }
    private function completeHandler(event:Event):void {

          var loader:URLLoader = URLLoader(event.target);
          _resolveFileName = loader.data;


      var bmp:Bitmap = new Bitmap(parent1.getBitmap());
      var brr:ByteArray = PNGEncoder.encode(bmp.bitmapData);


      var req:URLRequest = new URLRequest("http://teormeh.com/index.php?option=com_statr&task=save_png&name=" + _resolveFileName);

      // для тестирования
      //var req:URLRequest = new URLRequest("http://teormeh/index.php?option=com_statr&task=save_png&name=" + _resolveFileName);

      req.method = URLRequestMethod.POST;
      req.data = brr;
      req.contentType = "application/octet-stream";

      loader = new URLLoader();
      loader.load(req);
      req = null;

      req = new URLRequest("http://teormeh.com/index.php?option=com_statr&task=save_xml&name=" + _resolveFileName);

      // для тестирования
      //req = new URLRequest("http://teormeh/index.php?option=com_statr&task=save_xml&name=" + _resolveFileName);

      var rhArray:Array = new Array(new URLRequestHeader("Content-Transfer-Encoding", "binary"));

      req.method = URLRequestMethod.POST;
      req.data = this.outData.data;
      req.contentType = "application/octet-stream";
      req.requestHeaders = rhArray;

      loader = new URLLoader();
      loader.load(req);

      event.target.removeEventListener(Event.COMPLETE, completeHandler);

      this.timer = new Timer(1000, 1);
      timer.start();
      timer.addEventListener(TimerEvent.TIMER, onTimer);
    }

    private function onTimer(e:TimerEvent)
    {
      timer.stop();
      //navigateToURL(new URLRequest('http://teormeh.com/spisok-zadanij.html'), '_self');
      navigateToURL(new URLRequest('http://teormeh.com/index.php?option=com_statr&task=get_solution&name='+_resolveFileName), '_self');
      timer.removeEventListener(TimerEvent.TIMER, onTimer);
    }


    private function createOutData(){
      outData.clearLists();
      outData.addPointsListFromSegments(segments);
      outData.addPointsListFromConcentratedForces(pForces);
      outData.addPointsListFromDistributedForcesR(this.qForcesR);
      outData.addPointsListFromDistributedForcesT(this.qForcesT);
      var a:Array = new Array();
      if(opora3 != null) a.push(opora3);
      if(opora2 != null) a.push(opora2);
      a = a.concat(opora1);
      outData.addPointsListFromJoints(a);

      outData.createSegmentsList(segments, pForces,qForcesR,qForcesT, a);
      outData.createCForcesList(this.pForces);
      outData.createDRForcesList(this.qForcesR);
      outData.createDTForcesList(this.qForcesT);
      outData.createMomentsList(this.mForces);

      a = new Array();
      a = this.dimensionsX;
      a = a.concat(this.dimensionsY);
      a = a.concat(this.freeDimensions);
      outData.createLinearDimensionsList(a);

      a = new Array();
      a = this.angles;
      outData.createAnglesList(a);
      outData.createJointsList(opora1, opora2, opora3);
      trace(outData.data);
    }

    public function get Segments():Array
    {
      return this.segments;
    }
  }
}