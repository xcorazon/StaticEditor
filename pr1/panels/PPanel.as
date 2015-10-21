package pr1.panels{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class PPanel extends Panel{
		private var st_forceName:TextField;		// статический текст (название силы)
		private var st_forceValue:TextField;
		
		private var forceVarName:TextField;		// вводимый текст (название силы)
		private var forceVarValue:TextField;
		
		private var st_AngleName:TextField;
		private var angleVarName:TextField;
		
		private var st_AngleValue:TextField;
		private var angleVarValue:TextField;
		
		private var razmernost:ComBox;
		
		public function PPanel( x:int=80, y:int=550){
			super(x,y);
			st_forceName = new TextField();
			st_forceName.width = 125;
			st_forceName.height = 20;
			st_forceName.text = "Обозначение нагрузки:";
			st_forceName.x = 40;
			st_forceName.y = 5;
			addChild(st_forceName);
			
			forceVarName = new TextField();
			forceVarName.width = 20;
			forceVarName.height = 18;
			forceVarName.type = TextFieldType.INPUT;
			forceVarName.border = true;
			forceVarName.background = true;
			forceVarName.backgroundColor = 0xffffff;
			forceVarName.borderColor = 0x909090;
			forceVarName.x = 165;
			forceVarName.y = 5;
			addChild(forceVarName);
			
						
			st_forceValue = new TextField();
			st_forceValue.width = 105;
			st_forceValue.height = 20;
			st_forceValue.text = "Значение нагрузки:";
			st_forceValue.x = 40;
			st_forceValue.y = 28;
			addChild(st_forceValue);
			
			forceVarValue = new TextField();
			forceVarValue.width = 50;
			forceVarValue.height = 18;
			forceVarValue.type = TextFieldType.INPUT;
			forceVarValue.border = true;
			forceVarValue.background = true;
			forceVarValue.backgroundColor = 0xffffff;
			forceVarValue.borderColor = 0x909090;
			forceVarValue.x = 165;
			forceVarValue.y = 28;
			addChild(forceVarValue);

			st_AngleName = new TextField();
			st_AngleName.text = "Обозначение угла:";
			st_AngleName.width = 100;
			st_AngleName.height = 20;
			st_AngleName.x = 420;
			st_AngleName.y = 5;
			addChild(st_AngleName);

			angleVarName = new TextField();
			angleVarName.width = 20;
			angleVarName.height = 18;
			angleVarName.type = TextFieldType.INPUT;
			angleVarName.border = true;
			angleVarName.background = true;
			angleVarName.defaultTextFormat = new TextFormat("Symbol");
			angleVarName.backgroundColor = 0xffffff;
			angleVarName.borderColor = 0x909090;
			angleVarName.x = 525;
			angleVarName.y = 5;
			addChild(angleVarName);
			
			st_AngleValue = new TextField();
			st_AngleValue.text = "Значение угла:";
			st_AngleValue.width = 80;
			st_AngleValue.height = 20;
			st_AngleValue.x = 535;
			st_AngleValue.y = 5;
			addChild(st_AngleValue);

			angleVarValue = new TextField();
			angleVarValue.width = 30;
			angleVarValue.height = 18;
			angleVarValue.type = TextFieldType.INPUT;
			angleVarValue.border = true;
			angleVarValue.background = true;
			angleVarValue.backgroundColor = 0xffffff;
			angleVarValue.borderColor = 0x909090;
			angleVarValue.x = 620;
			angleVarValue.y = 5;
			addChild(angleVarValue);
			
			var txtArray:Array = new Array("Н","кН");
			razmernost = new ComBox(30, 18, txtArray);
			razmernost.x = 230;
			razmernost.y = 28;
			addChild(razmernost);
		}
		
		public function get forceName(){
			return forceVarName.text;
		}
		
		public function get forceIndex(){
			return forceVarIndex.text;
		}
		
		public function get forceValue(){
			return forceVarValue.text;
		}
		
		public function get angleName(){
			return angleVarName.text;
		}
		
		public function get angleValue(){
			return angleVarValue.text;
		}
	}

}