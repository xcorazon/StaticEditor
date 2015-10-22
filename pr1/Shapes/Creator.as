package pr1.Shapes
{
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import pr1.Frame;

  public class Creator extends Sprite
  {
    // обработчики событий
    protected var moveHandlers:Array;
    protected var downHandlers:Array;

    protected var parent1:*;

    private var _moveIndex:int;
    private var _downIndex:int;



    public function Creator(frame:Frame)
    {
      moveHandlers = new Array();
      downHandlers = new Array();
      this.parent1 = frame.parent1;
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