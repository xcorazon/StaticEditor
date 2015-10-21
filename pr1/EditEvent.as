// класс EditEvent

package pr1 {
	import flash.events.*;
	
	public class EditEvent extends Event {
		// Константа для типа события "textisin"
		public static const DELETE_ELEMENT:String = "Delete force event";
		public static const CHANGE_ELEMENT:String = "Change element";
		
		public var obj:*;

		// Конструктор
		public function EditEvent (type:String,
						bubbles:Boolean = false,
						cancelable:Boolean = false,
						obj:* = null) {
			// Передаем параметры конструктора  в конструктор суперкласса
			this.obj = obj;
			super(type, bubbles, cancelable);

		}

		// Любой класс пользовательского события должен переопределить
		// метод clone( )
		public override function clone( ):Event {
			return new EditEvent(type, bubbles, cancelable, obj);
		}

		// Любой класс пользовательского события должен переопределить
		// метод toString( )
		public override function toString( ):String {
			return formatToString	("EditEvent", "type", "bubbles",
						"cancelable", "eventPhase", "obj");
		}
		
	}
}