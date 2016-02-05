package  pr1.Shapes
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import pr1.Shapes.Arrow;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindowMovableJoint1;
  import pr1.windows.EditWindowMovableJoint2;
  import pr1.windows.EditWindow;
  import pr1.Snap;
  import pr1.opora.MovableJointContainer;
  import pr1.panels.MovableJointPanel1;
  import pr1.Frame;
  import pr1.events.DialogEvent;
  
  public class MovableJointCreator extends Creator
  {
    private var movableJoint:MovableJoint;
    private var isAnglePresent:Boolean = false;
    private var highlightedSegment:Segment;
    private var panel:MovableJointPanel1;

    // выходные данные

    public var firstPointOfAngle:int;
    public var secondPointOfAngle:int;
    public var thirdPointOfAngle:int;

    private var angleOfMovableJoint:Number;
    private var angleOfAxis:Number;
    private var pointNumber:int;
    private var jointPos:Point;
    private var angleValue:String;
    private var angleSign:int;
    private var upState:MovableJoint;
    private var overState:MovableJoint;
    private var downState:MovableJoint;
    private var hitTestState:MovableJoint;

    //cам элемент подвижного шарнира в полном виде
    private var joint:MovableJointContainer = null;

    public function MovableJointCreator(frame:Frame)
    {
      super(frame);
    }
    
    override public function create()
    {
      this.pointNumber = this.frame.lastNonUsedJoint;
      this.thirdPointOfAngle = 4;
      this.angleValue = "90";
      
      this.upState = new MovableJoint();;
      this.upState.scaleX = 0.9;
      this.upState.scaleY = 0.9;
      this.overState = new MovableJoint(0xff);
      this.overState.scaleX = 0.9;
      this.overState.scaleY = 0.9;
      this.downState = upState;
      this.hitTestState = this.upState;
      
      initHandlers();
      initEvents();
    }
    
    private function initHandlers()
    {
      moveHandlers[0] = highlightSegment;
      moveHandlers[1] = moveJoint;
      moveHandlers[2] = rotateJoint;

      downHandlers[0] = selectSegment;
      downHandlers[1] = fixPosition;
      downHandlers[2] = fixAngle;
    }

    private function highlightSegment(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var thres:Number = 8;
      var tempSegment:Segment = null;
      var tempThres:Number;

      for each (var seg in this.segments)
      {
        tempThres = snap.distance(cursorPosition, seg);
        if( tempThres <= thres)
        {
          tempSegment = seg;
          thres = tempThres;
        }
      }

      if(highlightedSegment != null)
      {
        if(tempSegment == null)
        {
          highlightedSegment.setColor(0x0);
          highlightedSegment = null;
          return;
        }
        else
        {
          highlightedSegment.setColor(0x0);
          highlightedSegment = tempSegment;
          highlightedSegment.setColor(0xff);
          return;
        }
      }
      else
      {
        if(tempSegment != null)
        {
          highlightedSegment = tempSegment;
          highlightedSegment.setColor(0xff);
          return;
        }
      }
    }

    private function moveJoint(e:MouseEvent)
    {
      var p:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
      p = snap.doSnapToForce(p, highlightedSegment);
      this.movableJoint.x = p.x;
      this.movableJoint.y = p.y;
      jointPos = p;
    }

    private function rotateJoint(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var angle = getAngle(cursorPosition);// !!!в этой функции будет изменена одна из координат cursorPosition
      var angleOfSide:Number;
      var angleOfSegment:Number;
      var arrowTip:Point = jointPos.clone();
      var vec:Point = cursorPosition.subtract(jointPos);
      arrowTip = jointPos.subtract(vec);

      secondPointOfAngle = this.pointNumber;

      if( angle == 0 || angle == 90 || angle == -90 || angle == 180 || angle == -180)
      {
        angleOfSide = 0; //angle * Math.PI/180;
        firstPointOfAngle = 0;
        this.angleOfAxis = 0;
        if(jointPos.x == cursorPosition.x)
        {
          angleValue = "90";
          if(cursorPosition.y - jointPos.y >= 0)
          {
            angleSign = 1;
          }
          else
            angleSign = -1;
        }
        if(jointPos.y == cursorPosition.y)
        {
          if(cursorPosition.x - jointPos.x >= 0)
          {
            angleValue = "180";
          }
          else
            angleValue = "0";
        }
      }
      else
      {
        angleOfSide = panel.angleOfAxis;
        this.angleOfAxis = panel.angleOfAxis;
        angleValue = null;
        vec = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
        angleOfSegment = CoordinateTransformation.decartToPolar(vec).y;
        if(angleOfSegment == angleOfSide)
        {
          firstPointOfAngle = highlightedSegment.secondPointNumber;
        }
        else
        {
          firstPointOfAngle = highlightedSegment.firstPointNumber;
        }
      }

      movableJoint.rotation = angle;
      angleOfMovableJoint = angle;
      /*trace("Угол полки: ", angleOfSide * 180/Math.PI, "angle = ", angle);
      trace("Координаты курсора: ", cursorPosition.toString());
      trace("Координаты конца стрелки: ", arrowTip.toString());
      trace(firstPointOfAngle, " ",secondPointOfAngle," ", thirdPointOfAngle); */
      this.upState = movableJoint;
      this.overState = new MovableJoint(0xff);
      this.overState.scaleX = 0.9;
      this.overState.scaleY = 0.9;
      this.overState.rotation = angle;
      this.downState = upState;
      this.hitTestState = this.upState;
      parent1.removeChild(elementImage);
      elementImage = new Arrow(jointPos, angleOfSide, arrowTip, false, 0xCC0000);
      if(angleValue == null)
      {
        angleSign = elementImage.angleSign;
        angleValue = (Math.abs(elementImage.angleOfTipOrTail)*180/Math.PI).toFixed(0);
      }

      elementImage.x = jointPos.x;
      elementImage.y = jointPos.y;
      parent1.addChild(elementImage);
    }

    private function selectSegment(e:MouseEvent)
    {
      var angle:Number;
      var p:Point;
      var positionOfJoint:Point;
      if( this.highlightedSegment != null)
      {
        movableJoint = new MovableJoint();
        movableJoint.scaleX = 0.9;
        movableJoint.scaleY = 0.9;
        parent1.addChild(movableJoint);
        highlightedSegment.setColor(0x0);
        positionOfJoint = snap.doSnapToSegment( new Point(e.stageX, e.stageY), highlightedSegment);
        movableJoint.x = positionOfJoint.x;
        movableJoint.y = positionOfJoint.y;
        
        nextHandlers();
      }
    }

    private function fixPosition(e:MouseEvent)
    {
      elementImage = new Arrow(jointPos, Math.PI/2, new Point(jointPos.x, jointPos.y-20), false, 0xCC0000);

      elementImage.x = jointPos.x;
      elementImage.y = jointPos.y;
      parent1.addChild(elementImage);
      panel = new MovableJointPanel1();
      panel.x = 800-135;
      parent1.addChild(panel);
      var p = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
      var angle = CoordinateTransformation.decartToPolar(p).y;
      panel.angleOfAxis = angle;
      
      nextHandlers();
    }

    private function fixAngle(e:MouseEvent)
    {
      // убираем всех прослушивателей событий
      releaseEvents();
      
      parent1.removeChild(panel);
      panel.destroy();
      
      angleSign = elementImage.angleSign;
      initDialog();
    }
    
    private function initDialog()
    {
      if(this.isAnglePresent)
        dialogWnd = new EditWindowMovableJoint1("","","");
      else
        dialogWnd = new EditWindowMovableJoint2("");
      
      parent1.addChild(dialogWnd);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }
    
    override protected function createObject(data:Object)
    {
      joint = new MovableJointContainer(parent1, this.upState, this.overState, this.downState, hitTestState, elementImage);
      joint.reaction = data.reaction;
      joint.angleSign = this.angleSign;
      if(this.isAnglePresent)
      {
        joint.angle = data.angle;
        angleValue = data.angleValue;
      }
      joint.angleValue = angleValue;
      joint.firstPointOfAngle = this.firstPointOfAngle;
      joint.secondPointOfAngle = this.secondPointOfAngle;
      joint.thirdPointOfAngle = this.thirdPointOfAngle;
      joint.isAnglePresent = this.isAnglePresent;
      joint.pointNumber = this.pointNumber;

      joint.angleOfAxis = this.angleOfAxis;
      joint.angleOfMovableJoint = Math.abs(elementImage.angleOfTipOrTail);

      joint.segment = this.highlightedSegment;
      joint.setCoordOfSignatures();
      joint.x = this.jointPos.x;
      joint.y = this.jointPos.y;
      
      super.createObject(data);
    }
    
    override protected function preEndDialog()
    {
      parent1.removeChild(movableJoint);
    }


    private function getAngle(cursorPosition:Point):Number
    {
      var verticalSnap:uint = 2;
      var horisontalSnap:uint = 3;
      var resultPoint:Point;
      var resultAngle:Number;
      var p:Point = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
      var localAngle = CoordinateTransformation.decartToPolar(p).y;
      var snap:uint = 0;

      var localPoint:Point = CoordinateTransformation.screenToLocal(cursorPosition, jointPos, localAngle);
      // получаем наименьшую привязку
      if (Math.abs(localPoint.x) <= 10 )
      {
        localPoint.x = 0;
        isAnglePresent = false;
        if(localPoint.y <= 0)
          return -(localAngle * 180/Math.PI);
        else
          return -(180 + localAngle * 180/Math.PI);
      }
      if (Math.abs(localPoint.y) <=10)
      {
        localPoint.y = 0;
        isAnglePresent = false;
        if(localPoint.x <= 0)
          return 180;
        else
          return 0;
      }
      
      if(Math.abs(cursorPosition.x - jointPos.x) <= 10)
      {
        snap = verticalSnap;
      }
      if(Math.abs(cursorPosition.y - jointPos.y) <= 10)
      {
        snap = horisontalSnap;
      }
      p = cursorPosition.subtract(jointPos);
      p = CoordinateTransformation.screenToLocal(p,new Point(0,0), 0);
      resultAngle = -CoordinateTransformation.decartToPolar(p).y * 180/Math.PI - 90;
      isAnglePresent = true;
      if(snap == verticalSnap)
      {
        isAnglePresent = false;
        if(cursorPosition.y - jointPos.y >= 0)
        {
          resultAngle = 0;
        }
        else
        {
          resultAngle = 180 ;
        }
        cursorPosition.x = jointPos.x;

      }
      else if(snap == horisontalSnap)
      {
        isAnglePresent = false;
        if(cursorPosition.x - jointPos.x >= 0)
        {
          resultAngle = -90;
        }
        else
        {
          resultAngle = 90;
        }
        cursorPosition.y = jointPos.y;
      }
      return resultAngle;
    }

    override public function get result():*
    {
      return joint;
    }
  }
}