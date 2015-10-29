package  pr1.forces
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.display.DisplayObject;
  import flash.display.Shape;
  import flash.text.Font;
  import flash.events.*;
  import pr1.windows.EditWindow;
  import pr1.events.DialogEvent;
  import pr1.Shapes.Segment;
  import pr1.Frame;
  import pr1.ComConst;

  public class Element extends Sprite
  {
    protected var params:Object;
    protected var signatures:Object;
    protected var sigPoses:Object;

    protected var dialogWnd:EditWindow;
    protected var parent1:*;
    protected var button:SimpleButton;

    protected var tempHitTestState:DisplayObject;

    protected var timesFont:Font;


    public function Element(frame:Frame, upState:DisplayObject, overState:DisplayObject, downState:DisplayObject, hitTestState:DisplayObject)
    {
      parent1 = frame.parent1;
      params     = new Object();
      sigPoses   = new Object();
      signatures = new Object();

      timesFont  = new Times1();

      button = new SimpleButton(upState, overState, downState, hitTestState);
      addChild(button);

      tempHitTestState = hitTestState;

      button.addEventListener(MouseEvent.CLICK, onMouseClick);
    }

  protected function onMouseClick(e:MouseEvent)
  {
  }

    private function releaseDialog()
    {
      dialogWnd.removeEventListener(DialogEvent.END_DIALOG, onEndDialog);
      parent1.removeChild(dialogWnd);
      dialogWnd = null;
    }

    protected final function onEndDialog(e:DialogEvent)
    {
      releaseDialog();

      if(e.canceled)
        deleteElement();
      else
        changeValues(e.eventData);

      dispatchEvent(new Event(ComConst.CHANGE_ELEMENT, true));
    }


    private function deleteElement()
    {
      dispatchEvent(new Event(ComConst.DELETE_ELEMENT, true));
    }


    protected function changeValues(data:Object)
    {
    }


    public function lock()
    {
      button.hitTestState = null;
      for each (var sig in signatures)
        sig.disable();
    }

    public function unlock()
    {
      button.hitTestState = tempHitTestState;
      for each (var sig in signatures)
        sig.enable();
    }

    public function destroy()
    {
      button.removeEventListener(MouseEvent.CLICK, onMouseClick);
      for each (var sig in signatures)
        sig.destroy();
    }

    public function set segment(seg:Segment)
    {
      params.seg = seg;
    }

    public function get segment():Segment
    {
      return params.seg;
    }

  }
}