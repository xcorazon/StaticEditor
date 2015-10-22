package  pr1.panels
{
  import flash.geom.Point;
  import flash.events.*;
  import flash.display.MovieClip;
  import pr1.buttons.PanelButton;

  public class AnglePanel extends MovieClip
  {
    private static const INNER_ANGLE_DOWN:String = "Inner angle select";
    private static const OUTER_ANGLE_DOWN:String = "Outer angle select";
    public static const CHANGE_STATE:String = "Change panel state";

    // кнопки
    private var innerAngle:BtnInnerAngle;
    private var outerAngle:BtnOuterAngle;

    private var dragging:Boolean = false;
    private var beginCursorPosition:Point;
    private var isInnerAngle1:Boolean = true;

    public function AnglePanel()
    {
      // constructor code

      // создаем кнопки
      innerAngle = new BtnInnerAngle();
      innerAngle.parentPanel = this;
      innerAngle.msgButton = INNER_ANGLE_DOWN;
      innerAngle.x = 15;
      innerAngle.y = 13.375;
      innerAngle.changeState(PanelButton.DOWN);
      addChild(innerAngle);

      outerAngle = new BtnOuterAngle();
      outerAngle.parentPanel = this;
      outerAngle.msgButton = OUTER_ANGLE_DOWN;
      outerAngle.x = 70;
      outerAngle.y = 13.375;
      addChild(outerAngle);

      this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

      this.addEventListener(INNER_ANGLE_DOWN, doInnerAngle);
      this.addEventListener(OUTER_ANGLE_DOWN, doOuterAngle);
    }

    public function destroy():void
    {
      this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

      this.removeEventListener(INNER_ANGLE_DOWN, doInnerAngle);
      this.removeEventListener(OUTER_ANGLE_DOWN, doOuterAngle);

      // уничтожаем все кнопки
      innerAngle.destroy();
      outerAngle.destroy();
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

    private function doInnerAngle(e:Event)
    {
      innerAngle.changeState(PanelButton.DOWN);
      outerAngle.changeState(PanelButton.UP);
      isInnerAngle1 = true;
      dispatchEvent( new Event(CHANGE_STATE));
    }

    private function doOuterAngle(e:Event)
    {
      outerAngle.changeState(PanelButton.DOWN);
      innerAngle.changeState(PanelButton.UP);
      isInnerAngle1 = false;
      dispatchEvent( new Event(CHANGE_STATE));
    }

    public function get isInnerAngle():Boolean
    {
      return isInnerAngle1;
    }
  }
}
