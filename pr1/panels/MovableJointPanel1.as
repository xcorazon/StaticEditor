package  pr1.panels {
	import flash.geom.Point;
	import flash.events.*;
	import flash.display.MovieClip;
	import pr1.buttons.PanelButton;
	
	public class MovableJointPanel1 extends MovieClip {
		private static const FORWARD_ANGLE_DOWN:String = "forward angle";
		private static const REVERSE_ANGLE_DOWN:String = "reverse angle";
		public static const CHANGE_STATE:String = "Change panel state";
		
		// кнопки
		private var forwardAngle:BtnForwardFreeDirection;
		private var reverseAngle:BtnReverseFreeDirection;
		
		private var dragging:Boolean = false;
		private var	beginCursorPosition:Point;
		private var angle1:Number = 0;
		private var returnedAngle:Number;
		
		public function MovableJointPanel1() {
			// constructor code
			
			// создаем кнопки
			forwardAngle = new BtnForwardFreeDirection();
			forwardAngle.parentPanel = this;
			forwardAngle.msgButton = FORWARD_ANGLE_DOWN;
			forwardAngle.x = 15;
			forwardAngle.y = 13.375;
			forwardAngle.changeState(PanelButton.DOWN);
			addChild(forwardAngle);
			
			reverseAngle = new BtnReverseFreeDirection();
			reverseAngle.parentPanel = this;
			reverseAngle.msgButton = REVERSE_ANGLE_DOWN;
			reverseAngle.x = 70;
			reverseAngle.y = 13.375;
			addChild(reverseAngle);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			this.addEventListener(FORWARD_ANGLE_DOWN, doForwardAngle);
			this.addEventListener(REVERSE_ANGLE_DOWN, doReverseAngle);
		}
		
		public function destroy():void {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			this.removeEventListener(FORWARD_ANGLE_DOWN, doForwardAngle);
			this.removeEventListener(REVERSE_ANGLE_DOWN, doReverseAngle);
			
			// уничтожаем все кнопки
			forwardAngle.destroy();
			reverseAngle.destroy();
		}
		
		private function onMouseDown(e:MouseEvent){
			this.startDrag();
			e.stopPropagation();
		}
		
		private function onMouseUp(e:MouseEvent){
			this.stopDrag();
		}
		
		private function doForwardAngle(e:Event){
			forwardAngle.changeState(PanelButton.DOWN);
			reverseAngle.changeState(PanelButton.UP);
			returnedAngle = angle1;
			dispatchEvent( new Event(CHANGE_STATE));
		}
		
		private function doReverseAngle(e:Event){
			reverseAngle.changeState(PanelButton.DOWN);
			forwardAngle.changeState(PanelButton.UP);
			returnedAngle = angle1 + Math.PI;
			if(returnedAngle >= 2*Math.PI){
				returnedAngle = returnedAngle - 2*Math.PI;
			}
			dispatchEvent( new Event(CHANGE_STATE));
		}

		public function get angleOfAxis():Number {
			return this.returnedAngle;
		}
		
		public function set angleOfAxis(value:Number) {
			this.angle1 = value;
			this.returnedAngle = value;
		}
	}
	
}
