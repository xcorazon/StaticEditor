package  pr1.panels
{
  import flash.display.MovieClip;
  import flash.events.MouseEvent;
  import flash.events.EventPhase;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.buttons.PanelButton;
  import pr1.ComConst;
  import pr1.CoordinateTransformation;
  import pr1.events.PanelEvent;

  public class ConcentratedForcePanel extends MovieClip
  {

    private static const ARROW_FROM_DOWN:String = "Arrow FROM Down";
    private static const ARROW_TO_DOWN:String = "Arrow TO Down";
    private static const FORWARD_DIRECTION_X:String = "Forward Direction X Down";
    private static const REVERSE_DIRECTION_X:String = "Reverse Direction X Down";
    private static const FORWARD_DIRECTION_Y:String = "Forward Direction Y Down";
    private static const REVERSE_DIRECTION_Y:String = "Reverse Direction Y Down";
    private static const FORWARD_FREE_DIRECTION:String = "Forward Free Direction Down";
    private static const REVERSE_FREE_DIRECTION:String = "Reverse Free Direction Down";
    public static const CHANGE_STATE:String = "Change panel state";
    // кнопки
    private var arrowFrom:BtnArrowFrom;
    private var arrowTo:BtnArrowTo;
    private var reverseDirectionX:BtnReverseDirectionX;
    private var forwardDirectionX:BtnForwardDirectionX;
    private var reverseDirectionY:BtnReverseDirectionY;
    private var forwardDirectionY:BtnForwardDirectionY;
    private var forwardFreeDirection:BtnForwardFreeDirection;
    private var reverseFreeDirection:BtnReverseFreeDirection;

    private var dragging:Boolean = false;
    private var beginCursorPosition:Point;  // для перемещения панели по экрану

    private var angleOfChosenSegment:Number;
    private var anglePoints:Array = [-1, -1, ComConst.FORCE_FROM];
    private var angle:Number;
    private var firstPoint:int;
    private var secondPoint:int;


    public function ConcentratedForcePanel()
    {
      // constructor code
      // создаем кнопки
      arrowFrom = new BtnArrowFrom();
      arrowFrom.parentPanel = this;
      arrowFrom.message = new PanelEvent(ARROW_FROM_DOWN);
      arrowFrom.x = 5;
      arrowFrom.y = 20;
      arrowFrom.changeState(PanelButton.DOWN);
      addChild(arrowFrom);

      arrowTo = new BtnArrowTo();
      arrowTo.parentPanel = this;
      arrowTo.message = new PanelEvent(ARROW_TO_DOWN);
      arrowTo.x = 5;
      arrowTo.y = 70;
      addChild(arrowTo);

      forwardDirectionX = new BtnForwardDirectionX();
      forwardDirectionX.parentPanel = this;
      forwardDirectionX.message = new PanelEvent(FORWARD_DIRECTION_X);
      forwardDirectionX.x = 125;
      forwardDirectionX.y = 20;
      addChild(forwardDirectionX);

      reverseDirectionX = new BtnReverseDirectionX();
      reverseDirectionX.parentPanel = this;
      reverseDirectionX.message = new PanelEvent(REVERSE_DIRECTION_X);
      reverseDirectionX.x = 125;
      reverseDirectionX.y = 70;
      addChild(reverseDirectionX);

      forwardDirectionY = new BtnForwardDirectionY();
      forwardDirectionY.parentPanel = this;
      forwardDirectionY.message = new PanelEvent(FORWARD_DIRECTION_Y);
      forwardDirectionY.x = 180;
      forwardDirectionY.y = 20;
      addChild(forwardDirectionY);

      reverseDirectionY = new BtnReverseDirectionY();
      reverseDirectionY.parentPanel = this;
      reverseDirectionY.message = new PanelEvent(REVERSE_DIRECTION_Y);
      reverseDirectionY.x = 180;
      reverseDirectionY.y = 70;
      addChild(reverseDirectionY);

      forwardFreeDirection = new BtnForwardFreeDirection();
      forwardFreeDirection.parentPanel = this;
      forwardFreeDirection.message = new PanelEvent(FORWARD_FREE_DIRECTION);
      forwardFreeDirection.x = 70;
      forwardFreeDirection.y = 20;
      forwardFreeDirection.changeState(PanelButton.DOWN)
      addChild(forwardFreeDirection);

      reverseFreeDirection = new BtnReverseFreeDirection();
      reverseFreeDirection.parentPanel = this;
      reverseFreeDirection.message = new PanelEvent(REVERSE_FREE_DIRECTION);
      reverseFreeDirection.x = 70;
      reverseFreeDirection.y = 70;
      addChild(reverseFreeDirection);


      this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

      this.addEventListener(ARROW_FROM_DOWN, doArrowFrom);
      this.addEventListener(ARROW_TO_DOWN, doArrowTo);
      this.addEventListener(FORWARD_DIRECTION_X, doForwardDirectionX);
      this.addEventListener(REVERSE_DIRECTION_X, doReverseDirectionX);
      this.addEventListener(FORWARD_DIRECTION_Y, doForwardDirectionY);
      this.addEventListener(REVERSE_DIRECTION_Y, doReverseDirectionY);
      this.addEventListener(FORWARD_FREE_DIRECTION, doForwardFreeDirection);
      this.addEventListener(REVERSE_FREE_DIRECTION, doReverseFreeDirection);

    }
    // координаты передаются в ДЕКАРТОВОЙ системе координат, не в ОКОННОЙ
    public function setSegmentPoints(first:int, firstPoint:Point, second:int, secondPoint:Point)
    {
      var angle:Number;
      this.firstPoint = first;
      this.secondPoint = second;
      angle = CoordinateTransformation.decartToPolar( secondPoint.subtract(firstPoint)).y;
      angleOfChosenSegment = angle;
      this.angle = angle;
      doForwardFreeDirection(null);
    }

    public function destroy():void
    {
      this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

      this.removeEventListener(ARROW_FROM_DOWN, doArrowFrom);
      this.removeEventListener(ARROW_TO_DOWN, doArrowTo);
      this.removeEventListener(FORWARD_DIRECTION_X, doForwardDirectionX);
      this.removeEventListener(REVERSE_DIRECTION_X, doReverseDirectionX);
      this.removeEventListener(FORWARD_DIRECTION_Y, doForwardDirectionY);
      this.removeEventListener(REVERSE_DIRECTION_Y, doReverseDirectionY);
      this.removeEventListener(FORWARD_FREE_DIRECTION, doForwardFreeDirection);
      this.removeEventListener(REVERSE_FREE_DIRECTION, doReverseFreeDirection);
      // уничтожаем все кнопки
      arrowFrom.destroy();
      arrowTo.destroy();
      reverseDirectionX.destroy();
      forwardDirectionX.destroy();
      reverseDirectionY.destroy();
      forwardDirectionY.destroy();
      forwardFreeDirection.destroy();
      reverseFreeDirection.destroy();
    }

    public function get angleOfAxis():Number
    {
      return angle;
    }

    public function get pointsOfAngle():Array
    {
      return anglePoints;
    }

    private function onMouseDown(e:MouseEvent)
    {
      e.stopPropagation();
      dragging = true;
      beginCursorPosition = new Point(e.stageX - this.x, e.stageY - this.y);
    }

    private function onMouseMove(e:MouseEvent)
    {
      if (dragging)
      {
        e.stopPropagation();
        this.x = (e.stageX - beginCursorPosition.x);
        this.y = (e.stageY - beginCursorPosition.y);
      }
    }

    private function onMouseUp(e:MouseEvent)
    {
      dragging = false;
    }

    private function rightButtonsUp()
    {
      reverseDirectionX.changeState(PanelButton.UP);
      forwardDirectionX.changeState(PanelButton.UP);
      reverseDirectionY.changeState(PanelButton.UP);
      forwardDirectionY.changeState(PanelButton.UP);
      forwardFreeDirection.changeState(PanelButton.UP);
      reverseFreeDirection.changeState(PanelButton.UP);
    }

    private function doArrowFrom(e:Event)
    {
      arrowFrom.changeState(PanelButton.DOWN);
      arrowTo.changeState(PanelButton.UP);
      anglePoints[2] = ComConst.FORCE_FROM;
      dispatchEvent( new Event(CHANGE_STATE));
    }

    private function doArrowTo(e:Event)
    {
      arrowTo.changeState(PanelButton.DOWN);
      arrowFrom.changeState(PanelButton.UP);
      anglePoints[2] = ComConst.FORCE_TO;
      dispatchEvent( new Event(CHANGE_STATE));
    }

    private function doForwardDirectionX(e:Event)
    {
      rightButtonsUp();
      forwardDirectionX.changeState(PanelButton.DOWN);
      anglePoints[0] = ComConst.OX_PLUS;
      angle = 0;
      dispatchEvent( new Event(CHANGE_STATE));
    }

    private function doReverseDirectionX(e:Event)
    {
      rightButtonsUp();
      reverseDirectionX.changeState(PanelButton.DOWN);
      anglePoints[0] = ComConst.OX_MINUS;
      angle = Math.PI;
      dispatchEvent( new Event(CHANGE_STATE));
    }

    private function doForwardDirectionY(e:Event)
    {
      rightButtonsUp();
      forwardDirectionY.changeState(PanelButton.DOWN);
      anglePoints[0] = ComConst.OY_PLUS;
      angle = Math.PI/2;
      dispatchEvent( new Event(CHANGE_STATE));
    }

    private function doReverseDirectionY(e:Event)
    {
      rightButtonsUp();
      reverseDirectionY.changeState(PanelButton.DOWN);
      anglePoints[0] = ComConst.OY_MINUS;
      angle = -Math.PI/2;
      dispatchEvent( new Event(CHANGE_STATE));
    }

    private function doForwardFreeDirection(e:Event)
    {
      rightButtonsUp();
      forwardFreeDirection.changeState(PanelButton.DOWN);
      anglePoints[0] = this.secondPoint;
      angle = angleOfChosenSegment;
      dispatchEvent( new Event(CHANGE_STATE));
    }

    private function doReverseFreeDirection(e:Event)
    {
      rightButtonsUp();
      reverseFreeDirection.changeState(PanelButton.DOWN);
      anglePoints[0] = this.firstPoint;
      angle = angleOfChosenSegment + Math.PI;
      dispatchEvent( new Event(CHANGE_STATE));
    }
  }
}
