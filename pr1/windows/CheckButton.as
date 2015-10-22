package pr1.windows
{
  import flash.display.SimpleButton;
  import flash.display.Shape;
  import flash.events.*;

  public class CheckButton extends SimpleButton
  {

    private var checkShape:Shape;
    private var unCheckShape:Shape;

    private var check:Boolean;

    public function CheckButton()
    {
      super();
      checkShape = Shape(downState);
      unCheckShape = Shape(upState);
      checked = false;

      addEventListener(MouseEvent.MOUSE_UP, buttonClick);
    }

    public function set checked(i:Boolean):void
    {
      check = i;
      if(check)
      {
        upState = checkShape;
        downState = unCheckShape;
      }
      else
      {
        upState = unCheckShape;
        downState = checkShape;
      }
      overState = upState;
    }

    public function get checked():Boolean
    {
      return check;
    }

    public function destroy()
    {
      removeEventListener(MouseEvent.CLICK, buttonClick);
    }

    private function buttonClick(e:MouseEvent)
    {
      checked = !checked;
    }
  }
}