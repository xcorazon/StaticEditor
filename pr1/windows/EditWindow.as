//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows {
	
	import flash.display.*;
//	import flash.display.Sprite;
	import pr1.EditEvent;
	import flash.events.*;
	import flash.text.*;
	import pr1.panels.ComBox;
	
	public class EditWindow extends Sprite {
		public static const DELETE_FORCE:String = "Delete force";
		public static const END_EDIT:String = "End Edit";
		public static const CANCEL_EDIT:String = "Cancel Edit";

		//текстовые поля для ввода информации
		internal var forceName:TextField;
		internal var forceValue:TextField;
		// фоновое изображение окна
		internal var fon:MovieClip;
		// окно с ошибкой
		internal var errWindow:Sprite;
		//размерность нагрузки
		internal var dimension1:ComBox;
		
		//кнопки
		internal var okButton:SimpleButton;
		internal var cancelButton:SimpleButton;
		
		public function EditWindow(value:String, name:String) {
			var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
			addFon();
			forceName = new TextField();
			forceName.x = 70;
			forceName.y = -60;
			forceName.width = 41;
			forceName.height = 20;
			forceName.border = true;
			forceName.background = true;
			forceName.type = TextFieldType.INPUT;
			forceName.restrict = "A-Za-z_0-9";
			forceName.multiline = false;
			forceName.maxChars = 6;
			forceName.defaultTextFormat = txtFormat;
			addChild(forceName);
			if(name != null) forceName.text = name; 
			
									
			forceValue = new TextField();
			forceValue.x = 70;
			forceValue.y = 0;
			forceValue.width = 72;
			forceValue.height = 20;
			forceValue.border = true;
			forceValue.background = true;
			forceValue.type = TextFieldType.INPUT;
			forceValue.defaultTextFormat = txtFormat;
			forceValue.restrict = "0-9.";
			forceValue.multiline = false;
			addChild(forceValue);
			if(value != "") forceValue.text = value;
			
			errWindow = new ErrorDialog();
			errWindow.x = -65;
			errWindow.y = -35;
			
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
			
			okButton.addEventListener(MouseEvent.CLICK, okListener);
			cancelButton.addEventListener(MouseEvent.CLICK, cancelListener);
			
		}
		
		internal function addFon():void {
			fon = new Dialog1();
			fon.stop();
			addChild(fon);
		}
		
		public function okListener(e:MouseEvent){
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
			okButton.removeEventListener(MouseEvent.CLICK, okListener);
						
			if(forceName.length == 0 || forceValue.length == 0){
				// вывести окно с повтором ввода
				trace("forceName ",forceName.text," forceValue ",forceValue.text);
				errWindow.addEventListener("EndError", errorListener);
				addChild(errWindow);
			} else {
				// послать сообщение об окончании ввода
				dispatchEvent( new Event(END_EDIT));
				dimension1.destroy();
			}
		}
		
		public function cancelListener(e:MouseEvent){
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
			okButton.removeEventListener(MouseEvent.CLICK, okListener);
			forceName.text = "";
			forceValue.text = "";
			
			// послать сообщение об окончании ввода
			dispatchEvent(new Event(CANCEL_EDIT));
			dimension1.destroy();
		}
		
		public function errorListener(e:Event){
			errWindow.removeEventListener("EndError", errorListener);
			okButton.addEventListener(MouseEvent.CLICK, okListener);
			cancelButton.addEventListener(MouseEvent.CLICK, cancelListener);
			removeChild(errWindow);
		}
		
		public function get value():String {
			return forceValue.text;
		}
		
		public function get force():String {
			return forceName.text;
		}
	}
}