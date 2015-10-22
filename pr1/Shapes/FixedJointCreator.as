package  pr1.Shapes
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.Shapes.Arrow;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindowFixedJoint;
  import pr1.windows.EditWindow;
  import pr1.forces.ConcentratedForce;
  import pr1.Snap;
  import pr1.opora.FixedJointContainer;

  public class FixedJointCreator extends Sprite
  {
    // события в объекте
    public static const CREATE_CANCEL:String = "Cancel creation of sealing";
    public static const CREATE_DONE:String = "Done creation of sealing";
    // константы для внутреннего использования
    private static const SELECT_SEGMENT:int = 0;
    private static const SELECT_POSITION:int = 1;
    private static const SELECT_ANGLE:int = 2;

    private var parent1:*;
    private var segments:Array;
    private var snap:Snap;
    private var fixedJoint:FixedJoint;
    private var highlightedSegment:Segment;

    // выходные данные
    private var pointNumber:int;
    private var angleOfFixedJoint:Number;
    private var fixedJointPosition:Point;
    private var horisontalReaction:String;
    private var verticalReaction:String;

    //cам элемент защемления в полном виде
    private var fixedJointContainer:FixedJointContainer = null;


    private var dialogWnd:EditWindowFixedJoint;

    private var doNow:int;

    public function FixedJointCreator(parent, segments:Array, lastNonUsedJoint:int)
    {
      this.parent1 = parent;
      this.segments = segments;
      this.doNow = SELECT_SEGMENT;
      this.pointNumber = lastNonUsedJoint;

      this.snap = parent1.snap;
      parent1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }

    private function onMouseMove(e:MouseEvent)
    {
      switch(doNow)
      {
        case SELECT_SEGMENT:
          doHighlightSegment(e);
          break;
        case SELECT_POSITION:
          doMoveJoint(e);
          break;
        case SELECT_ANGLE:
          doRotateJoint(e);
      }
    }

    private function doHighlightSegment(e)
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

    private function doMoveJoint(e:MouseEvent)
    {
      var p:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
      p = snap.doSnapToForce(p, highlightedSegment);
      this.fixedJoint.x = p.x;
      this.fixedJoint.y = p.y;
      fixedJointPosition = p;
    }

    private function doRotateJoint(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var angle = getAngle(cursorPosition);

      fixedJoint.rotation = angle;
      angleOfFixedJoint = angle;
    }

    private function onMouseDown(e:MouseEvent)
    {
      switch(doNow)
      {
        case SELECT_SEGMENT:
          doSelectSegment(e);
          break;
        case SELECT_POSITION:
          doSelectPosition();
          break;
        case SELECT_ANGLE:
          doSelectAngle();
      }
    }

    private function doSelectSegment(e:MouseEvent)
    {
      var angle:Number;
      var p:Point;
      var positionOfJoint:Point;
      if( this.highlightedSegment != null)
      {
        doNow = SELECT_POSITION;
        fixedJoint = new FixedJoint();
        fixedJoint.scaleX = 0.8;
        fixedJoint.scaleY = 0.8;
        parent1.addChild(fixedJoint);
        highlightedSegment.setColor(0x0);
        positionOfJoint = snap.doSnapToSegment( new Point(e.stageX, e.stageY), highlightedSegment);
        fixedJoint.x = positionOfJoint.x;
        fixedJoint.y = positionOfJoint.y;
      }
    }

    private function doSelectPosition()
    {
      doNow = SELECT_ANGLE;
    }

    private function doSelectAngle()
    {
      // убираем всех прослушивателей событий
      parent1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

      dialogWnd = new EditWindowFixedJoint("","");
      parent1.addChild(dialogWnd);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.addEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.addEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);
    }

    private function onEndEditInDialogWindow(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

      parent1.removeChild(dialogWnd);
      parent1.removeChild(fixedJoint);

      horisontalReaction = dialogWnd.horizontalReaction;
      verticalReaction = dialogWnd.verticalReaction;

      dialogWnd = null;
      doCreateFixedJoint();
      dispatchEvent(new Event(FixedJointCreator.CREATE_DONE));
    }

    private function doCreateFixedJoint()
    {
      var p:Point;
      var angle:Number;
      fixedJointContainer = new FixedJointContainer(parent1, this.angleOfFixedJoint);
      fixedJointContainer.x = this.fixedJointPosition.x;
      fixedJointContainer.y = this.fixedJointPosition.y;
      fixedJointContainer.segment = highlightedSegment;
      fixedJointContainer.horisontalReaction = horisontalReaction;
      fixedJointContainer.verticalReaction = verticalReaction;
      fixedJointContainer.pointNumber = this.pointNumber;
      fixedJointContainer.setCoordOfSignatures();

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

    private function getPointNumber(pointOnSegment:Point):int
    {
      var pointNumber:int = 5000;
        if(pointOnSegment.equals(highlightedSegment.firstScreenCoord))
        {
           pointNumber = highlightedSegment.firstPointNumber;
        }
        if(pointOnSegment.equals(highlightedSegment.secondScreenCoord))
        {
           pointNumber = highlightedSegment.secondPointNumber;
        }
      return pointNumber;
    }

    private function onCancelEditInDialogWindow(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

      parent1.removeChild(dialogWnd);
      parent1.removeChild(fixedJoint);

      dialogWnd = null;
      dispatchEvent(new Event(FixedJointCreator.CREATE_CANCEL));
    }

    public function get result():FixedJointContainer
    {
      return fixedJointContainer;
    }
  }
}