package pr1.buttons {
  import flash.display.SimpleButton;
  import flash.display.Shape;
  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  import flash.events.Event;
  import pr1.events.PanelEvent;

  public class PanelButton extends SimpleButton {
    public static const DOWN:int = 0;
    public static const UP:int = 1;
    public static const INACTIVE:int = 2;

    // переменные для хранения копий состояния кнопки
    private var downStateCpy:DisplayObject;
    private var upStateCpy:DisplayObject;
    private var overStateCpy:DisplayObject;
    private var hitTestStateCpy:DisplayObject;

    private var parent1;
    private var _message:PanelEvent;

    private var _decor:BtnDecor;

    public function PanelButton(upState:DisplayObject = null,
                  overState:DisplayObject = null,
                  downState:DisplayObject = null,
                  hitTestState:DisplayObject = null
                  ){

      super(upState, overState, downState, hitTestState);

      downStateCpy = this.downState;
      upStateCpy = this.upState;
      overStateCpy = this.overState;
      hitTestStateCpy = this.hitTestState;

      _decor = new BtnDecor();

      this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      changeState(INACTIVE);
    }

    public function set parentPanel(p){
      parent1 = p;
    }

    public function set message(msg:PanelEvent){
      _message = msg;
    }

    public function set decorator(decor:BtnDecor)
    {
      if (decor != null)
        _decor = decor;
    }

    public function changeState(st:int){

      switch(st){
        case DOWN:
          if(_decor.isAllowDown())
          {
            upState = downStateCpy;
            overState = downStateCpy;
            hitTestState = null;
            enabled = false;
          }
          break;
        case UP:
          if(_decor.isAllowUp())
          {
            upState = upStateCpy;
            overState = overStateCpy;
            hitTestState = hitTestStateCpy;
            enabled  = true;
          }
          break;
        case INACTIVE:
          if(_decor.isAllowInactive())
          {
            upState = upStateCpy;
            overState = overStateCpy;
            hitTestState = null;
            enabled = false;
          }
          break;
      }
    }

    private function onMouseDown(e:MouseEvent) {
      e.stopPropagation();
      _message.button = this;
      parent1.dispatchEvent(_message.clone());
      _message.button = null;
    }

    private function onMouseMove(e:MouseEvent){
      e.stopPropagation();
    }

    public function destroy():void {
      this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1 = null;
    }

  }
}