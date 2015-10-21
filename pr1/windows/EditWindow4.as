//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows {
	
	import flash.display.*;
	import pr1.windows.EditWindow;
	import pr1.panels.ComBox;
//	import flash.display.Sprite;
	import pr1.EditEvent1;
	import flash.events.*;
	import flash.text.*;
	
	public class EditWindow4 extends Sprite {
		public static const DELETE_OBJECT:String = "Delete object"; 
		//текстовые поля для ввода информации
		private var razmerName:TextField;
		private var razmerValue:TextField;
		// фоновое изображение окна
		internal var fon:MovieClip;
		// окно с ошибкой
		private var errWindow:Sprite;
		//размерность нагрузки
		internal var dimension1:ComBox;
		
		//кнопки
		internal var okButton:SimpleButton;
		internal var cancelButton:SimpleButton;
		
		public function EditWindow4(value:String, name:String) {
			var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
			addFon();
			razmerName = new TextField();
			razmerName.x = 70;
			razmerName.y = -60;
			razmerName.width = 41;
			razmerName.height = 20;
			razmerName.border = true;
			razmerName.background = true;
			razmerName.type = TextFieldType.INPUT;
			razmerName.restrict = "A-Za-z0-9_";
			razmerName.multiline = false;
			razmerName.maxChars = 5;
			razmerName.defaultTextFormat = txtFormat;
			addChild(razmerName);
			if(name != null) razmerName.text = name; 
			
			razmerValue = new TextField();
			razmerValue.x = 70;
			razmerValue.y = 0;
			razmerValue.width = 72;
			razmerValue.height = 20;
			razmerValue.border = true;
			razmerValue.background = true;
			razmerValue.type = TextFieldType.INPUT;
			razmerValue.defaultTextFormat = txtFormat;
			razmerValue.restrict = "0-9.";
			razmerValue.multiline = false;
			addChild(razmerValue);
			if(value != "") razmerValue.text = String(value);
			
			dimension1 = new ComBox(35, 20, new Array("м","см","мм"));
			dimension1.x = 70;
			dimension1.y = -30;
			addChild(dimension1);
			
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
			fon = new Dialog4();
			fon.stop();
			addChild(fon);
		}
		
		public function okListener(e:MouseEvent){
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
			okButton.removeEventListener(MouseEvent.CLICK, okListener);
			
			if(razmerName.length == 0 || razmerValue.length == 0){
				// вывести окно с повтором ввода
				trace("forceName ",razmerName.text," forceValue ",razmerValue.text);
				errWindow.addEventListener("EndError", errorListener);
				addChild(errWindow);
			} else {
				// послать сообщение об окончании ввода
				dispatchEvent(new Event(EditWindow.END_EDIT));
				dimension1.destroy();
			}
		}
		
		public function cancelListener(e:MouseEvent){
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
			okButton.removeEventListener(MouseEvent.CLICK, okListener);
			razmerName.text = "";
			razmerValue.text = "";
			
			dispatchEvent(new Event(EditWindow.CANCEL_EDIT));
			dimension1.destroy();

		}
		
		public function errorListener(e:Event){
			errWindow.removeEventListener("EndError", errorListener);
			okButton.addEventListener(MouseEvent.CLICK, okListener);
			cancelButton.addEventListener(MouseEvent.CLICK, cancelListener);
			removeChild(errWindow);
		}
		
		public function get value():String {
			return razmerValue.text;
		}
		
		public function get razmer():String {
			return String(razmerName.text);
		}
		
		public function get dimension():String{
			return dimension1.textInBox;
		}
		
		public function set dimension(s:String) {
			if( s == "м"){
				dimension1.numberOfText = 0;
			}
			if( s == "см"){
				dimension1.numberOfText = 1;
			}
			if( s == "мм"){
				dimension1.numberOfText = 2;
			}
		}
	}
}