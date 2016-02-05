package  pr1.panels {
  import flash.geom.Point;
  import flash.events.*;
  import flash.display.MovieClip;
  import pr1.buttons.PanelButton;
  import pr1.events.PanelEvent;

  public class MomentPanel extends MovieClip
  {
    private static const CLOCKWISE_DOWN:String = "Arrow clock wise";
    private static const ANTI_CLOCKWISE_DOWN:String = "Arrow anti clock wise";
    public static const CHANGE_STATE:String = "Change panel state";

    // кнопки
    private var arrowClockWise:BtnClockWise;
    private var arrowAntiClockWise:BtnAntiClockWise;

    private var dragging:Boolean = false;
    private var beginCursorPosition:Point;
    private var momentClockWise:Boolean = true;

    public function MomentPanel()
    {
      // constructor code

      // создаем кнопки
      arrowClockWise = new BtnClockWise();
      arrowClockWise.parentPanel = this;
      arrowClockWise.message = new PanelEvent(CLOCKWISE_DOWN);
      arrowClockWise.x = 15;
      arrowClockWise.y = 13.375;
      arrowClockWise.changeState(PanelButton.DOWN);
      addChild(arrowClockWise);

      arrowAntiClockWise = new BtnAntiClockWise();
      arrowAntiClockWise.parentPanel = this;
      arrowAntiClockWise.message = new PanelEvent(ANTI_CLOCKWISE_DOWN);
      arrowAntiClockWise.x = 70;
      arrowAntiClockWise.y = 13.375;
      addChild(arrowAntiClockWise);

      this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

      this.addEventListener(CLOCKWISE_DOWN, doClockWise);
      this.addEventListener(ANTI_CLOCKWISE_DOWN, doAntiClockWise);
    }

    public function destroy():void
    {
      this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

      this.removeEventListener(CLOCKWISE_DOWN, doClockWise);
      this.removeEventListener(ANTI_CLOCKWISE_DOWN, doAntiClockWise);

      // уничтожаем все кнопки
      arrowClockWise.destroy();
      arrowAntiClockWise.destroy();
    }

    private function onMouseDown(e:MouseEvent)
    {
      this.startDrag();
      e.stopPropagation();
    }

    private function onMouseUp(e:MouseEvent)
    {
      this.stopDrag();
    }

    private function doClockWise(e:Event)
    {
      arrowClockWise.changeState(PanelButton.DOWN);
      arrowAntiClockWise.changeState(PanelButton.UP);
      momentClockWise = true;
      dispatchEvent( new Event(CHANGE_STATE));
    }

    private function doAntiClockWise(e:Event)
    {
      arrowAntiClockWise.changeState(PanelButton.DOWN);
      arrowClockWise.changeState(PanelButton.UP);
      momentClockWise = false;
      dispatchEvent( new Event(CHANGE_STATE));
    }

    public function get isMomentClockWise():Boolean
    {
      return momentClockWise;
    }
  }

}
