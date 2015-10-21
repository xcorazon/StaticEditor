//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows {
	
	import flash.display.*;
//	import flash.display.Sprite;
	import pr1.EditEvent1;
	import flash.events.*;
	import flash.text.*;
	
	public class EditWindow5 extends Sprite {
		public static const DELETE_OBJECT:String = "Delete opora"; 
		//текстовые поля для ввода информации
		private var oporaName:TextField;
		// фоновое изображение окна
		internal var fon:MovieClip;
		
		//кнопки
		internal var okButton:SimpleButton;
		internal var cancelButton:SimpleButton;
		
		public function EditWindow5(name:String) {
			var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
			addFon();
			oporaName = new TextField();
			oporaName.x = 70;
			oporaName.y = -50;
			oporaName.width = 41;
			oporaName.height = 20;
			oporaName.border = true;
			oporaName.background = true;
			oporaName.type = TextFieldType.INPUT;
			oporaName.restrict = "A-Za-z";
			oporaName.multiline = false;
			oporaName.maxChars = 5;
			oporaName.defaultTextFormat = txtFormat;
			addChild(oporaName);
			if(name != null) oporaName.text = name; 
			
						
			okButton = new OkButton();
			okButton.x = 30;
			okButton.y = 0;
			okButton.width = 40;
			okButton.height = 29;
			addChild(okButton);
			
			cancelButton = new CancelButton();
			cancelButton.x = 100;
			cancelButton.y = 0;
			cancelButton.width = 62;
			cancelButton.height = 29;
			addChild(cancelButton);
			
			
			okButton.addEventListener(MouseEvent.CLICK, okListener);
			cancelButton.addEventListener(MouseEvent.CLICK, cancelListener);
			
			//error_ok_button.addEventListener(MouseEvent.CLICK, errorListener);
		}
		
		internal function addFon():void {
			fon = new Dialog5();
			fon.stop();
			addChild(fon);
		}
		
		public function okListener(e:MouseEvent){
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
			okButton.removeEventListener(MouseEvent.CLICK, okListener);
			
			dispatchEvent(new Event(EditEvent1.END_EDIT, true, true));
		}
		
		public function cancelListener(e:MouseEvent){
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
			okButton.removeEventListener(MouseEvent.CLICK, okListener);
			oporaName.text = "";

			dispatchEvent(new Event(EditWindow5.DELETE_OBJECT));

		}
		

		
		public function get value():String {
			return oporaName.text;
		}
		
	}
}