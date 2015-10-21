package pr1.windows{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	
	public class ErrorDialog extends Sprite{
		private var fon:MovieClip;
		private var ok_button:SimpleButton;
		
		public function ErrorDialog(){
			fon = new ErrDialog();
			addChild(fon);
			ok_button = new Button1();
			ok_button.x = 65;
			ok_button.y = 55;
			ok_button.width = 46;
			ok_button.height = 22;
			addChild(ok_button);
			ok_button.addEventListener(MouseEvent.CLICK, buttonClick);
		}
		
		private function buttonClick(e:MouseEvent){
			dispatchEvent(new Event("EndError", true, true));
		}
	}
}