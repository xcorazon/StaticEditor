//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows {
	
	import flash.display.*;
	import pr1.windows.EditWindow;
//	import flash.display.Sprite;
	import pr1.EditEvent1;
	import flash.events.*;
	import flash.text.*;
	
	public class EditWindowMovableJoint1 extends Sprite {
		public static const DELETE_OBJECT:String = "Delete object"; 
		//текстовые поля для ввода информации
		private var reaction1:TextField;
		private var angleName1:TextField;
		private var angleValue1:TextField;
		// фоновое изображение окна
		internal var fon:MovieClip;
		// окно с ошибкой
		private var errWindow:Sprite;
		
		//кнопки
		internal var okButton:SimpleButton;
		internal var cancelButton:SimpleButton;
		
		public function EditWindowMovableJoint1(reaction:String, angle:String, angleValue:String) {
			var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
			var txtFormat1:TextFormat = new TextFormat("Symbol1", 14, 0x0, true);
			addFon();
			reaction1 = new TextField();
			reaction1.x = 160;
			reaction1.y = -68.5;
			reaction1.width = 45;
			reaction1.height = 20;
			reaction1.border = true;
			reaction1.background = true;
			reaction1.type = TextFieldType.INPUT;
			reaction1.restrict = "A-Za-z0-9_";
			reaction1.multiline = false;
			reaction1.maxChars = 5;
			reaction1.defaultTextFormat = txtFormat;
			addChild(reaction1);
			if(reaction != null) reaction1.text = reaction; 
			
			angleName1 = new TextField();
			angleName1.x = 160;
			angleName1.y = -32.8;
			angleName1.width = 45;
			angleName1.height = 20;
			angleName1.border = true;
			angleName1.background = true;
			angleName1.embedFonts = true;
			angleName1.type = TextFieldType.INPUT;
			angleName1.defaultTextFormat = txtFormat1;
			angleName1.restrict = "A-Za-z0-9_";
			angleName1.multiline = false;
			addChild(angleName1);
			if(angle != "") angleName1.text = String(angle);
			
			angleValue1 = new TextField();
			angleValue1.x = 160;
			angleValue1.y = 1.70;
			angleValue1.width = 45;
			angleValue1.height = 20;
			angleValue1.border = true;
			angleValue1.background = true;
			angleValue1.type = TextFieldType.INPUT;
			angleValue1.defaultTextFormat = txtFormat;
			angleValue1.restrict = "0-9.";
			angleValue1.multiline = false;
			addChild(angleValue1);
			if(angleValue != "") angleValue1.text = angleValue;
			
			okButton = new OkButton();
			okButton.x = 30;
			okButton.y = 50;
			okButton.width = 40;
			okButton.height = 29;
			addChild(okButton);
			
			cancelButton = new CancelButton();
			cancelButton.x = 100;
			cancelButton.y = 50;
			cancelButton.width = 62;
			cancelButton.height = 29;
			addChild(cancelButton);
			
			errWindow = new ErrorDialog();
			errWindow.x = -65;
			errWindow.y = -35;
			
			okButton.addEventListener(MouseEvent.CLICK, okListener);
			cancelButton.addEventListener(MouseEvent.CLICK, cancelListener);
			
			//error_ok_button.addEventListener(MouseEvent.CLICK, errorListener);
		}
		
		internal function addFon():void {
			fon = new MovableJointDialog1();
			fon.stop();
			addChild(fon);
		}
		
		public function okListener(e:MouseEvent){
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
			okButton.removeEventListener(MouseEvent.CLICK, okListener);
			
			if(reaction.length == 0 || angleName.length == 0 || angleValue.length == 0){
				// вывести окно с повтором ввода
				errWindow.addEventListener("EndError", errorListener);
				addChild(errWindow);
			} else {
				// послать сообщение об окончании ввода
				dispatchEvent(new Event(EditWindow.END_EDIT));
			}
		}
		
		public function cancelListener(e:MouseEvent){
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
			okButton.removeEventListener(MouseEvent.CLICK, okListener);
			reaction1.text = "";
			angleName1.text = "";
			angleValue1.text = "";
			
			dispatchEvent(new Event(EditWindow.CANCEL_EDIT));

		}
		
		public function errorListener(e:Event){
			errWindow.removeEventListener("EndError", errorListener);
			okButton.addEventListener(MouseEvent.CLICK, okListener);
			cancelButton.addEventListener(MouseEvent.CLICK, cancelListener);
			removeChild(errWindow);
		}
		
		public function get reaction():String {
			return reaction1.text;
		}
		
		public function get angleName():String {
			return this.angleName1.text;
		}
		
		public function get angleValue():String {
			return this.angleValue1.text;
		}
	}
}