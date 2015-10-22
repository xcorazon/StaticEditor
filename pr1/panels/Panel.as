package pr1.panels
{
	import flash.display.Sprite;
	import flash.display.JointStyle;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.ui.Keyboard;
	import flash.events.*;

	public class Panel extends Sprite
  {
		// константы
		public static const DESTROY:String = "Destroy panel";
		public static const STOP:String = "Panel stop";

		// переменные

		protected var panel_width:int = 720;
		protected var panel_height:int = 50;
		private var btnStop:BtnStop;
		private var btnEnter:BtnEnter;

		// конструктор

		public function Panel(  x:int=80, y:int=550)
    {
			this.graphics.beginFill(0xcccccc);
			this.graphics.lineStyle(1,0x505050,1,false, "normal",CapsStyle.ROUND, JointStyle.MITER);
			this.graphics.drawRect(0,0, panel_width, panel_height);
			this.graphics.endFill();
			this.x = x;
			this.y = y;

			btnStop = new BtnStop();
			btnStop.x = 12.5;
			btnStop.y = 12.5;
			btnStop.scaleX = 0.5;
			btnStop.scaleY = 0.5;
			addChild(btnStop);
			addEventListener(Panel.DESTROY, destroyPanel);
			addEventListener(KeyboardEvent.KEY_DOWN, escKeyDown);
			btnStop.addEventListener(MouseEvent.CLICK, clickBtnStop);

			btnEnter = new BtnEnter();
			btnEnter.x = 12.5;
			btnEnter.y = 32;
			btnEnter.scaleX = 0.4;
			btnEnter.scaleY = 0.4;
			addChild(btnEnter);

		}

		// уничтожение всех слушателей событий панели
		private function destroyPanel(e:Event)
    {
			removeEventListener(Panel.DESTROY, destroyPanel);
			btnStop.removeEventListener(MouseEvent.CLICK, clickBtnStop);
			// добавить сюда удаление всех слушателей событий
		}

		// слушатель события нажатия кнопки стоп
		private function clickBtnStop(e:MouseEvent)
    {
			dispatchEvent( new Event(Panel.DESTROY));
			dispatchEvent( new Event(Panel.STOP));
		}

		// обработка нажатия кнопки ESC
		private function escKeyDown(e:KeyboardEvent)
    {
			if( e.charCode == Keyboard.ESCAPE)
      {
				dispatchEvent( new Event(Panel.DESTROY));
			}
		}

		// добавляем объект содержащий переменные схемы
		// например P1 = 300H. Сила P - это переменная, 300 - значение переменной.
		// Это делается для того чтобы исключить повторяющиеся переменные. Т.е. пользователь может ввести Р = 300, и следующую нагрузку обозвать также
		// но присвоить ей другое значение например Р = 400 и у нас получится в рассчетах будет фигурировать одна и та же переменная но с разными значениями.
		// Этого не должно быть. Значения переменных будут синхронизированы и у одинаковых переменных будут одинаковые значения.
		public function addVarConteiner():void {

		}

	}
}