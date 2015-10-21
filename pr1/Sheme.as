package pr1{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*; //TextField;
	import flash.ui.Keyboard;
	
	import pr1.forces.*;
	import pr1.buttons.*;
	import com.adobe.images.PNGEncoder;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;
	import flash.system.Security;
	
	public class Sheme extends Sprite {
		public static const CHANGE_BUTTON = "change button";
		public static const SOMETHING_DELETE = "Something delete";
		
		public static const STAGE_WIDTH = 800;		
		public static const STAGE_HEIGHT = 400;

		private var rama:Balka;
		
		// кнопки на панели
		private var btnForce:BtnForce;
		private var btnMoment:BtnMoment;
		private var btnRazmer:BtnRazmer;
		private var btnQl:BtnQl;
		private var btnOpora1:BtnOpora1;
		private var btnOpora2:BtnOpora2;
		private var btnOpora3:BtnOpora3;
		// дополнительные кнопки
		private var btnProv:Proverka;
		
		// Конструктор основного класса
		public function Sheme() {
		
			Security.allowDomain("http://teormeh.com");
			Security.loadPolicyFile("http://teormeh.com/crossdomain.xml");									
			// устанавливаем кнопки на панели
			btnForce = new BtnForce();
			addChild(btnForce);
			btnForce.x = 38.5;
			btnForce.y = 215.5;
			
			btnMoment = new BtnMoment();
			addChild(btnMoment);
			btnMoment.x = 38.5;
			btnMoment.y = 307.5;
			
			btnRazmer = new BtnRazmer();
			addChild(btnRazmer);
			btnRazmer.x = 38.5;
			btnRazmer.y = 169.5;
			
			btnQl = new BtnQl();
			addChild(btnQl);
			btnQl.x = 38.5;
			btnQl.y = 261.5;
			
			btnOpora1 = new BtnOpora1()
			btnOpora1.x = 38.5;
			btnOpora1.y = 123.5;
			addChild(btnOpora1);
			
			btnOpora2 = new BtnOpora2()
			btnOpora2.x = 38.5;
			btnOpora2.y = 77.5;
			addChild(btnOpora2);
			
			btnOpora3 = new BtnOpora3()
			btnOpora3.x = 38.5;
			btnOpora3.y = 31.5;
			addChild(btnOpora3);
			
			btnProv = new Proverka();
			btnProv.x = 150;
			btnProv.y = 320;
			addChild(btnProv);
			
			addEventListener(EditEvent.BEGIN_EDIT, beginEditListener);
			addEventListener(EditEvent.END_EDIT, endEditListener);
			addEventListener(Sheme.SOMETHING_DELETE, somethingDelete);

			balka = new Balka();
				addChild(balka);
				balka.changeActiveElement(Balka.NO_CHANGE);
				//var a = new Razmer(balka);
				
				btnForce.addEventListener(MouseEvent.MOUSE_DOWN, btnForceDown);
				btnMoment.addEventListener(MouseEvent.MOUSE_DOWN, btnMomentDown);
				btnRazmer.addEventListener(MouseEvent.MOUSE_DOWN, btnRazmerDown);
				btnQl.addEventListener(MouseEvent.MOUSE_DOWN, btnQlDown);
				btnOpora1.addEventListener(MouseEvent.MOUSE_DOWN, btnOpora1Down);
				btnOpora2.addEventListener(MouseEvent.MOUSE_DOWN, btnOpora2Down);
				btnOpora3.addEventListener(MouseEvent.MOUSE_DOWN, btnOpora3Down);
				btnProv.addEventListener(MouseEvent.MOUSE_DOWN, btnProvDown);
				
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN, escapeDownListener);
		}
		
		
		// функция блокировки панели (все кнопки на панели будут недоступны)
		public function lockPanel():void
		{
			
		}
		
		// функция разблокирования панели (все кнопки будут вновь доступны)
		public function unlockPanel():void {
			
		}
		
		private function escapeDownListener(e:KeyboardEvent):void {
			if(e.keyCode == Keyboard.ESCAPE){
				dispatchEvent(new Event(Sheme.CHANGE_BUTTON));
				allButtonsUp();
			}
		}
				
		private function beginEditListener(e:EditEvent){
			this.lockPanel();
			balka.deactivateForces();
			addChild(e.wnd);
			e.wnd.x = 400;
			e.wnd.y = 200;
		}
		
		private function endEditListener(e:EditEvent){
			this.unlockPanel();
			balka.activateForces();
			removeChild(e.wnd);
			allButtonsUp();
		}
		
		public function allButtonsUp():void {
			btnMoment.changeState(PanelButton.UP);
			btnForce.changeState(PanelButton.UP);
			btnRazmer.changeState(PanelButton.UP);
			btnQl.changeState(PanelButton.UP);
			
			oporaButtonsUp();
			balka.activateForces();
			
		}
		
		private function oporaButtonsUp():void {
			var a = balka.numReactions;
			switch(a){
				case 0:
					btnOpora1.changeState(PanelButton.UP);
					btnOpora2.changeState(PanelButton.UP);
					btnOpora3.changeState(PanelButton.UP);
					break;
				case 1:
					btnOpora3.changeState(PanelButton.INACTIVE);
					btnOpora2.changeState(PanelButton.UP);
					btnOpora1.changeState(PanelButton.INACTIVE);
					break;
				case 2:
					btnOpora3.changeState(PanelButton.INACTIVE);
					btnOpora1.changeState(PanelButton.UP);
					btnOpora2.changeState(PanelButton.INACTIVE);
					break;
				case 3:
					btnOpora3.changeState(PanelButton.INACTIVE);
					btnOpora2.changeState(PanelButton.INACTIVE);
					btnOpora1.changeState(PanelButton.INACTIVE);
					break;
			}
			
		}
		
		// обработчики нажатия кнопок на панели
		private function btnForceDown(e:MouseEvent){
			dispatchEvent(new Event(Sheme.CHANGE_BUTTON));
			btnForce.changeState(PanelButton.DOWN);
			balka.changeActiveElement(Balka.P_CHANGE);
			// подымаем ранее нажатые кнопки
			btnMoment.changeState(PanelButton.UP);
			btnRazmer.changeState(PanelButton.UP);
			btnQl.changeState(PanelButton.UP);
			
			oporaButtonsUp();
			
			var a = new PForce(balka, this);
			a.addEventListener(PForce.CREATE_DONE, pForceCreated);
			a.addEventListener(PForce.CREATE_CANCEL, pForceCreationCanceled);
			balka.deactivateForces();
		}
		
		private function btnMomentDown(e:MouseEvent){
			dispatchEvent(new Event(Sheme.CHANGE_BUTTON));			
			btnMoment.changeState(PanelButton.DOWN);
			balka.changeActiveElement(Balka.M_CHANGE);
			// подымаем ранее нажатые кнопки
			btnForce.changeState(PanelButton.UP);
			btnRazmer.changeState(PanelButton.UP);
			btnQl.changeState(PanelButton.UP);
			
			oporaButtonsUp();
			
			var a = new MForce(balka, this);
			balka.deactivateForces();
		}
		
		private function btnRazmerDown(e:MouseEvent){
			dispatchEvent(new Event(Sheme.CHANGE_BUTTON));			
			btnRazmer.changeState(PanelButton.DOWN);
			balka.changeActiveElement(Balka.L_CHANGE);
			// подымаем ранее нажатые кнопки
			btnForce.changeState(PanelButton.UP);
			btnMoment.changeState(PanelButton.UP);
			btnQl.changeState(PanelButton.UP);
			
			oporaButtonsUp();
			
			var a = new Razmer(balka, this);
			a.addEventListener(Razmer.CREATE_COMPLETE, razmerCreated);
			a.addEventListener(Razmer.CREATE_CANCEL, razmerCreationCanceled);
			balka.deactivateForces();
		}
		
		private function btnQlDown(e:MouseEvent){
			dispatchEvent(new Event(Sheme.CHANGE_BUTTON));			
			btnQl.changeState(PanelButton.DOWN);
			balka.changeActiveElement(Balka.Q_CHANGE);
			// подымаем ранее нажатые кнопки
			btnForce.changeState(PanelButton.UP);
			btnMoment.changeState(PanelButton.UP);
			btnRazmer.changeState(PanelButton.UP);
			
			oporaButtonsUp();
			
			var a = new QForce(balka, this);
			balka.deactivateForces();
		}
		
		private function btnOpora1Down(e:MouseEvent){
			dispatchEvent(new Event(Sheme.CHANGE_BUTTON));			
			btnOpora1.changeState(PanelButton.DOWN);
			balka.changeActiveElement(Balka.NO_CHANGE);
			// подымаем ранее нажатые кнопки
			btnForce.changeState(PanelButton.UP);
			btnMoment.changeState(PanelButton.UP);
			btnRazmer.changeState(PanelButton.UP);
			btnQl.changeState(PanelButton.UP);
			
			btnOpora2.changeState(PanelButton.UP);
			btnOpora3.changeState(PanelButton.UP);
			var a = new Opora1(balka, this);
			a.addEventListener(Opora1.CREATE_COMPLETE, oporaCreated);
			a.addEventListener(Opora1.CREATE_CANCEL, oporaCreationCanceled);
			balka.deactivateForces();
		}
		
		private function btnOpora2Down(e:MouseEvent){
			dispatchEvent(new Event(Sheme.CHANGE_BUTTON));			
			btnOpora2.changeState(PanelButton.DOWN);
			balka.changeActiveElement(Balka.NO_CHANGE);
			// подымаем ранее нажатые кнопки
			btnForce.changeState(PanelButton.UP);
			btnMoment.changeState(PanelButton.UP);
			btnRazmer.changeState(PanelButton.UP);
			btnQl.changeState(PanelButton.UP);
			
			btnOpora1.changeState(PanelButton.UP);
			btnOpora3.changeState(PanelButton.UP);
			var a = new Opora2(balka, this);
			a.addEventListener(Opora1.CREATE_COMPLETE, oporaCreated);
			a.addEventListener(Opora1.CREATE_CANCEL, oporaCreationCanceled);
			balka.deactivateForces();
		}
		
		private function btnOpora3Down(e:MouseEvent){
			dispatchEvent(new Event(Sheme.CHANGE_BUTTON));			
			btnOpora3.changeState(PanelButton.DOWN);
			balka.changeActiveElement(Balka.NO_CHANGE);
			// подымаем ранее нажатые кнопки
			btnForce.changeState(PanelButton.UP);
			btnMoment.changeState(PanelButton.UP);
			btnRazmer.changeState(PanelButton.UP);
			btnQl.changeState(PanelButton.UP);
			
			btnOpora1.changeState(PanelButton.UP);
			btnOpora2.changeState(PanelButton.UP);

			var a = new Opora3(balka, this);
			a.addEventListener(Opora1.CREATE_COMPLETE, oporaCreated);
			a.addEventListener(Opora1.CREATE_CANCEL, oporaCreationCanceled);
			balka.deactivateForces();
		}
		
		private function oporaCreated(e:Event){
			allButtonsUp();
			e.target.removeEventListener(Opora1.CREATE_COMPLETE, oporaCreated);
			e.target.removeEventListener(Opora1.CREATE_CANCEL, oporaCreationCanceled);
		}
		
		private function oporaCreationCanceled(e:Event){
			allButtonsUp();
			e.target.removeEventListener(Opora1.CREATE_COMPLETE, oporaCreated);
			e.target.removeEventListener(Opora1.CREATE_CANCEL, oporaCreationCanceled);
		}

		
		private function razmerCreated(e:Event){
			balka.addRazmer(Razmer(e.target));
			e.target.removeEventListener(Razmer.CREATE_COMPLETE, razmerCreated);
			e.target.removeEventListener(Razmer.CREATE_CANCEL, razmerCreationCanceled);
			balka.changeActiveElement(Balka.NO_CHANGE);
			btnRazmer.changeState(PanelButton.UP);
			btnForce.changeState(PanelButton.UP);
			btnMoment.changeState(PanelButton.UP);
			btnQl.changeState(PanelButton.UP);
			balka.activateForces();
		}
		private function razmerCreationCanceled(e:Event){
			e.target.removeEventListener(Razmer.CREATE_COMPLETE, razmerCreated);
			e.target.removeEventListener(Razmer.CREATE_CANCEL, razmerCreationCanceled);
			// подымаем кнопку размера
			btnRazmer.changeState(PanelButton.UP);
			balka.activateForces();
		}
		
		private function pForceCreated(e:Event){
			//balka.addPForce(PForce(e.target));
			e.target.removeEventListener(PForce.CREATE_DONE, pForceCreated);
			e.target.removeEventListener(PForce.CREATE_CANCEL, pForceCreationCanceled)
			balka.changeActiveElement(Balka.NO_CHANGE);
			allButtonsUp();
			balka.activateForces();
		}
		private function pForceCreationCanceled(e:Event){
			e.target.removeEventListener(PForce.CREATE_DONE, pForceCreated);
			e.target.removeEventListener(PForce.CREATE_CANCEL, pForceCreationCanceled)
			// подымаем кнопку размера
			allButtonsUp();
			balka.activateForces();
		}
		
		private function somethingDelete(e:Event){
			allButtonsUp();
			// функция проверки размеров
			// если размер указывает в "никуда" то его необходимо удалить
			balka.deleteNenuzhnieRazmeri();
		}
		
		private function btnProvDown(e:MouseEvent){
			

			// получаем имя для сохранения файла
			var loader:URLLoader = new URLLoader();
			var req:URLRequest = new URLRequest("http://teormeh.com/index.php?option=com_static&task=get_name");
			req.method = URLRequestMethod.POST;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(req);
			loader.addEventListener(Event.COMPLETE, completeHandler);
						
		}
		
		
		private function completeHandler(event:Event):void {
			
        		var loader:URLLoader = URLLoader(event.target);
        		var f_name:String = loader.data;
			
			var a = new Prepare(balka);
			
			var b:Boolean = a.checkRazmers(true);
			
			var bmp:Bitmap = new Bitmap(a.getBitmap());
			var brr:ByteArray = PNGEncoder.encode(bmp.bitmapData);
			var outData:ByteArray = a.createOutputData();
			
			
			var req:URLRequest = new URLRequest("http://teormeh.com/index.php?option=com_static&task=save_png&name=" + f_name);
			req.method = URLRequestMethod.POST;
			req.data = brr;
			req.contentType = "application/octet-stream";

			loader = new URLLoader();
			loader.load(req);
			req = null;
			
			req = new URLRequest("http://teormeh.com/index.php?option=com_static&task=save_bin&name=" + f_name);
			var rhArray:Array = new Array(new URLRequestHeader("Content-Transfer-Encoding", "binary"));

			req.method = URLRequestMethod.POST;
			req.data = outData;
			req.contentType = "application/octet-stream";
			req.requestHeaders = rhArray;

			loader = new URLLoader();
			loader.load(req);
			
			event.target.removeEventListener(Event.COMPLETE, completeHandler);
        	}
		
	}
}