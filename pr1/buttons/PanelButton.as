package pr1.buttons {
	import flash.display.SimpleButton;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
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
		private var messageToParent:String;
		
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
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function set parentPanel(p){
			parent1 = p;
		}
		
		public function set msgButton(msg:String){
			messageToParent = msg;
		}
		
		public function changeState(st:int){
			
			switch(st){
				case DOWN:
					upState = downStateCpy;
					overState = downStateCpy;
					hitTestState = null;
					enabled = false;
					break;
				case UP:
					upState = upStateCpy;
					overState = overStateCpy;
					hitTestState = hitTestStateCpy;
					enabled  = true;
					break;
				case INACTIVE:
					upState = upStateCpy;
					overState = overStateCpy;
					hitTestState = null;
					enabled = false;
					break;
			}
		}
		
		private function onMouseDown(e:MouseEvent) {
			e.stopPropagation();
			parent1.dispatchEvent(new Event(messageToParent));
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