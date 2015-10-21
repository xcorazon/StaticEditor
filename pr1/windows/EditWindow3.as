package pr1.windows {
	import flash.display.MovieClip;
	import pr1.EditEvent;
	import pr1.panels.ComBox;
	import flash.events.*;
	import flash.text.*;
	
	public class EditWindow3 extends EditWindow {
		
		private var angleNameField:TextField;	// поле для ввода обозначения угла
		private var angleField:TextField;		// поле для ввода значения угла в градусах
		
		public function EditWindow3(forceValue:String, forceName:String, angleName:String, angle:String) {
			super(forceValue, forceName);
			
			okButton.y = 100;
			cancelButton.y = 100;
			
			var txtFormat:TextFormat = new TextFormat("Symbol1", 16, 0x0, true);
			angleNameField = new TextField();
			with(angleNameField){
				x = 70;
				y = 30;
				width = 41;
				height = 20;
				border = true;
				embedFonts = true;
				background = true;
				type = TextFieldType.INPUT;
				restrict = "a-z_0-9";
				multiline = false;
				maxChars = 6;
				defaultTextFormat = txtFormat;
				if(angleName != null) text = angleName;
			}
			addChild(angleNameField);
			
			dimension1 = new ComBox(35, 20, new Array("Н","кН"));
			dimension1.x = 70;
			dimension1.y = -30;
			addChild(dimension1);
			
			txtFormat.font = "Arial";
			txtFormat.size = 12;
			angleField = new TextField();
			with(angleField){
				x = 70;
				y = 60;
				width = 72;
				height = 20;
				border = true;
				background = true;
				type = TextFieldType.INPUT;
				restrict = "0-9.";
				multiline = false;
				defaultTextFormat = txtFormat;
				if(angle != "") text = angle;
			}
			addChild(angleField);
			if((angle == "0" || angle == "90" || angle == "180") && angleName == ""){
				angleField.type = TextFieldType.DYNAMIC;
				angleNameField.type = TextFieldType.DYNAMIC;
			}
			
		}
		
		override public function okListener(e:MouseEvent){
			cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
			okButton.removeEventListener(MouseEvent.CLICK, okListener);
						
			if(forceName.length == 0 || forceValue.length == 0 || (angleName.length == 0 && !(angle == "0" || angle == "90" || angle == "180"))){
				// вывести окно с повтором ввода
				trace("forceName ",forceName.text," forceValue ",forceValue.text);
				errWindow.addEventListener("EndError", errorListener);
				addChild(errWindow);
			} else {
				// послать сообщение об окончании ввода
				dispatchEvent(new Event(EditWindow.END_EDIT));
				dimension1.destroy();
			}
		}
		
		override internal function addFon():void {
			fon = new Dialog3();
			fon.stop();
			addChild(fon);
		}
		
		public function get angleName():String {
			return angleNameField.text;
		}
		
		public function get angle():String {
			return angleField.text;
		}
		
		public function get dimension():String {
			return dimension1.textInBox;
		}
		
		public function set dimension(s:String) {
			if( s == "Н"){
				dimension1.numberOfText = 0;
			}
			if( s == "кН"){
				dimension1.numberOfText = 1;
			}
		}
	}
}