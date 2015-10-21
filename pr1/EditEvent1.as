// класс EditEvent

package pr1 {
	import flash.events.*;
	import pr1.windows.EditWindow4;
	
	// Класс представляющий пользовательское событие "textisin"
	public class EditEvent1 extends Event {
		// Константа для типа события "textisin"
		public static const BEGIN_EDIT:String = "begin edit1";
		public static const END_EDIT:String = "end edit1";

		public var wnd:EditWindow4;

		// Конструктор
		public function EditEvent1 (type:String,
						bubbles:Boolean = false,
						cancelable:Boolean = false,
						wnd:EditWindow4 = null) {
			// Передаем параметры конструктора  в конструктор суперкласса
			this.wnd = wnd;
			super(type, bubbles, cancelable);

		}

		// Любой класс пользовательского события должен переопределить
		// метод clone( )
		public override function clone( ):Event {
			return new EditEvent1(type, bubbles, cancelable, wnd);
		}

		// Любой класс пользовательского события должен переопределить
		// метод toString( )
		public override function toString( ):String {
			return formatToString	("TextIsInEvent", "type", "bubbles",
						"cancelable", "eventPhase", "wnd");
		}
		
	}
}