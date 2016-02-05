package  pr1.Shapes
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindowFixedJoint;
  import pr1.opora.FixedJointContainer;
  import pr1.Frame;
  import pr1.events.DialogEvent;

  public class FixedJointCreator extends Creator
  {
    private var highlightedSegment:Segment;

    // выходные данные
    private var pointNumber:int;
    private var angleOfFixedJoint:Number;
    private var fixedJointPosition:Point;

    //cам элемент защемления в полном виде
    private var fixedJointContainer:FixedJointContainer = null;


    public function FixedJointCreator(frame:Frame)
    {
      super(frame);
    }
    
    override public function create()
    {
      super.create();
    
      this.pointNumber = frame.lastNonUsedJoint;

      initEvents();
      initHandlers();
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

    private function highlightSegment(e)
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
      this.elementImage.x = p.x;
      this.elementImage.y = p.y;
      fixedJointPosition = p;
    }

    private function rotateJoint(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var angle = getAngle(cursorPosition);

      elementImage.rotation = angle;
      angleOfFixedJoint = angle;
    }


    private function selectSegment(e:MouseEvent)
    {
      var angle:Number;
      var p:Point;
      var positionOfJoint:Point;
      if( this.highlightedSegment != null)
      {
        nextHandlers();

        elementImage = new FixedJoint();
        elementImage.scaleX = 0.8;
        elementImage.scaleY = 0.8;
        parent1.addChild(elementImage);
        highlightedSegment.setColor(0x0);
        positionOfJoint = snap.doSnapToSegment( new Point(e.stageX, e.stageY), highlightedSegment);
        elementImage.x = positionOfJoint.x;
        elementImage.y = positionOfJoint.y;
      }
    }

    private function fixPosition(e:MouseEvent)
    {
      nextHandlers();
    }

    private function fixAngle(e:MouseEvent)
    {
      releaseEvents();
      initDialog();
    }


    private function getAngle(cursorPosition:Point):Number
    {
      var localSnap:Number;
      var verticalSnap:Number;
      var horisontalSnap:Number;
      var resultPoint:Point;
      var resultAngle:Number;
      var p:Point = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
      var localAngle = CoordinateTransformation.decartToPolar(p).y;

      var localPoint:Point = CoordinateTransformation.screenToLocal(cursorPosition, fixedJointPosition, localAngle);
      // получаем наименьшую привязку
      localSnap = Math.abs(localPoint.x);
      verticalSnap = Math.abs(cursorPosition.x - fixedJointPosition.x);
      horisontalSnap = Math.abs(cursorPosition.y - fixedJointPosition.y);
      var snap = Math.min(localSnap, verticalSnap, horisontalSnap);

      if(snap == localSnap)
      {
        localPoint.x = 0;
        if(localPoint.y <= 0)
        {
          resultAngle = -(localAngle * 180/Math.PI);
        }
        else
        {
          resultAngle = -(180 + localAngle * 180/Math.PI);
        }
      }
      else if(snap == verticalSnap)
      {
        if(cursorPosition.y - fixedJointPosition.y >= 0)
        {
          resultAngle = 0;
        }
        else
        {
          resultAngle = 180 ;
        }
      }
      else
      {
        if(cursorPosition.x - fixedJointPosition.x >= 0)
        {
          resultAngle = -90;
        }
        else
        {
          resultAngle = 90;
        }
      }
      return resultAngle;
    }

    private function initDialog()
    {
      dialogWnd = new EditWindowFixedJoint("","");
      parent1.addChild(dialogWnd);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }

    override protected function createObject(data:Object)
    {
      var p:Point;
      var angle:Number;
      fixedJointContainer = new FixedJointContainer(frame, this.angleOfFixedJoint);
      fixedJointContainer.x = this.fixedJointPosition.x;
      fixedJointContainer.y = this.fixedJointPosition.y;
      fixedJointContainer.segment = highlightedSegment;

      fixedJointContainer.horisontalReaction = data.hReaction;
      fixedJointContainer.verticalReaction = data.vReaction;

      fixedJointContainer.pointNumber = this.pointNumber;
      fixedJointContainer.setCoordOfSignatures();

      super.createObject(data);
    }


    override public function get result():*
    {
      return fixedJointContainer;
    }
  }
}