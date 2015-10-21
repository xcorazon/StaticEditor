//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows {
	
	import flash.display.*;
	import pr1.windows.EditWindow;
//	import flash.display.Sprite;
	import pr1.EditEvent1;
	import flash.events.*;
	import flash.text.*;
	
	public class EditWindowFixedJoint extends Sprite {
		public static const DELETE_OBJECT:String = "Delete object"; 
		//текстовые поля для ввода информации
		private var hReaction:TextField;
		private var vReaction:TextField;
		// фоновое изображение окна
		internal var fon:MovieClip;
		// окно с ошибкой
		private var errWindow:Sprite;
		
		//кнопки
		internal var okButton:SimpleButton;
		internal var cancelButton:SimpleButton;
		
		public function EditWindowFixedJoint(horisontalReaction:String, verticalReaction:String) {
			var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
			addFon();
			hReaction = new TextField();
			hReaction.x = 160;
			hReaction.y = -51.5;
			hReaction.width = 45;
			hReaction.height = 20;
			hReaction.border = true;
			hReaction.background = true;
			hReaction.type = TextFieldType.INPUT;
			hReaction.restrict = "A-Za-z0-9_";
			hReaction.multiline = false;
			hReaction.maxChars = 5;
			hReaction.defaultTextFormat = txtFormat;
			addChild(hReaction);
			if(horisontalReaction != null) hReaction.text = horisontalReaction; 
			
			vReaction = new TextField();
			vReaction.x = 160;
			vReaction.y = -8.8;
			vReaction.width = 45;
			vReaction.height = 20;
			vReaction.border = true;
			vReaction.background = true;
			vReaction.type = TextFieldType.INPUT;
			vReaction.defaultTextFormat = txtFormat;
			vReaction.restrict = "A-Za-z0-9_";
			vReaction.multiline = false;
			addChild(vReaction);
			if(verticalReaction != "") vReaction.text = String(verticalReaction);
			
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
			fon = new FixedJointDialog();
			fon.stop();
			addChild(fon);
		}
		
		public function okListener(e:MouseEvent){
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
			okButton.removeEventListener(MouseEvent.CLICK, okListener);
			
			if(hReaction.length == 0 || vReaction.length == 0){
				// вывести окно с повтором ввода
				trace("forceName ",hReaction.text," forceValue ",vReaction.text);
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
			hReaction.text = "";
			vReaction.text = "";
			
			dispatchEvent(new Event(EditWindow.CANCEL_EDIT));

		}
		
		public function errorListener(e:Event){
			errWindow.removeEventListener("EndError", errorListener);
			okButton.addEventListener(MouseEvent.CLICK, okListener);
			cancelButton.addEventListener(MouseEvent.CLICK, cancelListener);
			removeChild(errWindow);
		}
		
		public function get verticalReaction():String {
			return vReaction.text;
		}
		
		public function get horizontalReaction():String {
			return String(hReaction.text);
		}
	}
}