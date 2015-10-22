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
  import pr1.windows.EditWindowMovableJoint1;
  import pr1.windows.EditWindowMovableJoint2;
  import pr1.windows.EditWindow;
  import pr1.forces.ConcentratedForce;
  import pr1.Snap;
  import pr1.opora.MovableJointContainer;
  import pr1.panels.MovableJointPanel1;

  public class MovableJointCreator extends Sprite
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
    private var movableJoint:MovableJoint;
    private var arrow:Arrow;
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
    private var movableJointPosition:Point;
    private var reaction:String;
    private var angleName:String;
    private var angleValue:String;
    private var angleSign:int;
    private var upState:MovableJoint;
    private var overState:MovableJoint;
    private var downState:MovableJoint;
    private var hitTestState:MovableJoint;

    //cам элемент подвижного шарнира в полном виде
    private var movableJointContainer:MovableJointContainer = null;


    private var dialogWnd:*;

    private var doNow:int;

    public function MovableJointCreator(parent, segments:Array, lastNonUsedjoint:int)
    {
      this.parent1 = parent;
      this.segments = segments;
      this.doNow = SELECT_SEGMENT;
      this.thirdPointOfAngle = 4;
      this.pointNumber = lastNonUsedjoint;

      this.angleValue = "90";
      this.snap = parent1.snap;
      parent1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

      this.upState = new MovableJoint();;
      this.upState.scaleX = 0.9;
      this.upState.scaleY = 0.9;
      this.overState = new MovableJoint(0xff);
      this.overState.scaleX = 0.9;
      this.overState.scaleY = 0.9;
      this.downState = upState;
      this.hitTestState = this.upState;
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
      this.movableJoint.x = p.x;
      this.movableJoint.y = p.y;
      movableJointPosition = p;
    }

    private function doRotateJoint(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var angle = getAngle(cursorPosition);// !!!в этой функции будет изменена одна из координат cursorPosition
      var angleOfSide:Number;
      var angleOfSegment:Number;
      var arrowTip:Point = movableJointPosition.clone();
      var vec:Point = cursorPosition.subtract(movableJointPosition);
      arrowTip = movableJointPosition.subtract(vec);

      secondPointOfAngle = this.pointNumber;

      if( angle == 0 || angle == 90 || angle == -90 || angle == 180 || angle == -180)
      {
        angleOfSide = 0; //angle * Math.PI/180;
        firstPointOfAngle = 0;
        this.angleOfAxis = 0;
        if(movableJointPosition.x == cursorPosition.x)
        {
          angleValue = "90";
          if(cursorPosition.y - movableJointPosition.y >= 0)
          {
            angleSign = 1;
          }
          else
            angleSign = -1;
        }
        if(movableJointPosition.y == cursorPosition.y)
        {
          if(cursorPosition.x - movableJointPosition.x >= 0)
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
      parent1.removeChild(arrow);
      arrow = new Arrow(movableJointPosition, angleOfSide, arrowTip, false, 0xCC0000);
      if(angleValue == null)
      {
        angleSign = arrow.angleSign;
        angleValue = (Math.abs(arrow.angleOfTipOrTail)*180/Math.PI).toFixed(0);
      }

      arrow.x = movableJointPosition.x;
      arrow.y = movableJointPosition.y;
      parent1.addChild(arrow);
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
        movableJoint = new MovableJoint();
        movableJoint.scaleX = 0.9;
        movableJoint.scaleY = 0.9;
        parent1.addChild(movableJoint);
        highlightedSegment.setColor(0x0);
        positionOfJoint = snap.doSnapToSegment( new Point(e.stageX, e.stageY), highlightedSegment);
        movableJoint.x = positionOfJoint.x;
        movableJoint.y = positionOfJoint.y;
      }
    }

    private function doSelectPosition()
    {
      arrow = new Arrow(movableJointPosition, Math.PI/2, new Point(movableJointPosition.x, movableJointPosition.y-20), false, 0xCC0000);

      arrow.x = movableJointPosition.x;
      arrow.y = movableJointPosition.y;
      parent1.addChild(arrow);
      panel = new MovableJointPanel1();
      panel.x = 800-135;
      parent1.addChild(panel);
      var p = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
      var angle = CoordinateTransformation.decartToPolar(p).y;
      panel.angleOfAxis = angle;
      doNow = SELECT_ANGLE;
    }

    private function doSelectAngle()
    {
      // убираем всех прослушивателей событий
      parent1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

      parent1.removeChild(panel);
      panel.destroy();

      angleSign = arrow.angleSign;

      if(this.isAnglePresent)
      {
        dialogWnd = new EditWindowMovableJoint1("","","");
      }
      else
      {
        dialogWnd = new EditWindowMovableJoint2("");
      }
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
      parent1.removeChild(movableJoint);
      parent1.removeChild(arrow);
      if(this.isAnglePresent)
      {
        reaction = dialogWnd.reaction;
        this.angleName = dialogWnd.angleName;
        this.angleValue = dialogWnd.angleValue;
      }
      else
      {
        reaction = dialogWnd.reaction;
      }

      dialogWnd = null;
      doCreateMovableJoint();
      dispatchEvent(new Event(MovableJointCreator.CREATE_DONE));
    }

    private function doCreateMovableJoint()
    {
      movableJointContainer = new MovableJointContainer(parent1, this.upState, this.overState, this.downState, hitTestState, arrow);
      movableJointContainer.reaction = this.reaction;
      movableJointContainer.angleSign = this.angleSign;
      if(this.isAnglePresent)
      {
        movableJointContainer.angle = this.angleName;
      }
      movableJointContainer.angleValue = this.angleValue;
      movableJointContainer.firstPointOfAngle = this.firstPointOfAngle;
      movableJointContainer.secondPointOfAngle = this.secondPointOfAngle;
      movableJointContainer.thirdPointOfAngle = this.thirdPointOfAngle;
      movableJointContainer.isAnglePresent = this.isAnglePresent;
      movableJointContainer.pointNumber = this.pointNumber;

      movableJointContainer.angleOfAxis = this.angleOfAxis;
      movableJointContainer.angleOfMovableJoint = Math.abs(arrow.angleOfTipOrTail);

      movableJointContainer.segment = this.highlightedSegment;
      movableJointContainer.setCoordOfSignatures();
      movableJointContainer.x = this.movableJointPosition.x;
      movableJointContainer.y = this.movableJointPosition.y;

    }

    private function getAngle(cursorPosition:Point):Number
    {
      var localSnap:uint = 1;
      var verticalSnap:uint = 2;
      var horisontalSnap:uint = 3;
      var resultPoint:Point;
      var resultAngle:Number;
      var p:Point = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
      var localAngle = CoordinateTransformation.decartToPolar(p).y;
      var snap:uint = 0;

      var localPoint:Point = CoordinateTransformation.screenToLocal(cursorPosition, movableJointPosition, localAngle);
      // получаем наименьшую привязку
      if (Math.abs(localPoint.x) <= 10)
      {
        snap = localSnap;
      }
      if(Math.abs(cursorPosition.x - movableJointPosition.x) <= 10)
      {
        snap = verticalSnap;
      }
      if(Math.abs(cursorPosition.y - movableJointPosition.y) <= 10)
      {
        snap = horisontalSnap;
      }
      p = cursorPosition.subtract(movableJointPosition);
      p = CoordinateTransformation.screenToLocal(p,new Point(0,0), 0);
      resultAngle = -CoordinateTransformation.decartToPolar(p).y * 180/Math.PI - 90;
      isAnglePresent = true;
      if(snap == localSnap)
      {
        localPoint.x = 0;
        isAnglePresent = false;
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
        isAnglePresent = false;
        if(cursorPosition.y - movableJointPosition.y >= 0)
        {
          resultAngle = 0;
        }
        else
        {
          resultAngle = 180 ;
        }
        cursorPosition.x = movableJointPosition.x;

      }
      else if(snap == horisontalSnap)
      {
        isAnglePresent = false;
        if(cursorPosition.x - movableJointPosition.x >= 0)
        {
          resultAngle = -90;
        }
        else
        {
          resultAngle = 90;
        }
        cursorPosition.y = movableJointPosition.y;
      }
      return resultAngle;
    }


    private function onCancelEditInDialogWindow(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

      parent1.removeChild(dialogWnd);
      parent1.removeChild(movableJoint);
      parent1.removeChild(arrow);

      dialogWnd = null;
      dispatchEvent(new Event(MovableJointCreator.CREATE_CANCEL));
    }

    public function get result():MovableJointContainer
    {
      return movableJointContainer;
    }
  }
}