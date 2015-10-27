package pr1.Shapes
{
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.events.Event;
  import pr1.window.EditWindow;
  import pr1.Frame;
  import pr1.events.DialogEvent;
  import pr1.Snap;
  import flash.display.Shape;
  import pr1.windows.EditWindow;

  public class Creator extends Sprite
  {
    public static const CREATE_CANCEL:String = "Cancel creation of moment";
    public static const CREATE_DONE:String = "Done creation of moment";

    // обработчики событий
    protected var moveHandlers:Array;
    protected var downHandlers:Array;

    protected var elementImage:Shape; // стрелка, размер, и т.п.
    protected var segments:Array;

    protected var parent1:*;
    protected var snap:Snap;

    private var _moveIndex:int;
    private var _downIndex:int;

    private var dialogWnd:EditWindow;


    public function Creator(frame:Frame)
    {
      moveHandlers = new Array();
      downHandlers = new Array();
      this.parent1 = frame.parent1;
      this.segments = frame.Segments;
      snap = parent1.snap;

      moveIndex = 0;
      downIndex = 0;
    }


    protected function initEvents()
    {
      parent1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }


    protected function releaseEvents()
    {
      parent1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }


    private function onMouseMove(e:MouseEvent)
    {
      moveHandlers[moveIndex](e);
    }


    private function onMouseDown(e:MouseEvent)
    {
      downHandlers[downIndex](e);
    }

    private function releaseDialog()
    {
      dialogWnd.removeEventListener(DialogEvent.END_DIALOG, onEndDialog);

      parent1.removeChild(dialogWnd);
      parent1.removeChild(elementImage);
      dialogWnd = null;
    }

    private function onEndDialog(e:DialogEvent)
    {
      releaseDialog();

      if(e.canceled)
        creationCancel();
      else
        createObject(e.eventData);
    }

    protected function createObject(data:Object)
    {
      dispatchEvent(new Event(Creator.CREATE_DONE));
    }


    private function creationCancel()
    {
      dispatchEvent(new Event(Creator.CREATE_CANCEL));
    }


    protected function get moveIndex():int
    {
      return _moveIndex;
    }


    protected function get downIndex():int
    {
      return _downIndex;
    }


    protected function set moveIndex(idx:int)
    {
      if (idx < moveHandlers.length)
        _moveIndex = idx;
    }


    protected function set downIndex(idx:int)
    {
      if (idx < downHandlers.length)
        _downIndex = idx;
    }


    protected function nextMoveHandler()
    {
      moveIndex += 1;
    }


    protected function nextDownHandler()
    {
      downIndex += 1;
    }

    protected function nextHandlers()
    {
      moveIndex += 1;
      downIndex += 1;
    }
  }
}