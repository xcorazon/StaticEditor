package  pr1{
	
	public class ComConst {
		// номера точек положительных и отрицательных направлений осей координат
		public static const OX_PLUS:int = 0;
		public static const OX_MINUS:int = 1;
		public static const OY_PLUS:int = 2;
		public static const OY_MINUS:int = 3;
		public static const FORCE_FROM:int = 4; // сила направлена наружу, от отрезка
		public static const FORCE_TO:int = 5;	// сила направлена к отрезку.
		// глобальные события
		public static const LOCK_ALL:String = "Lock all elements";
		public static const DELETE_ELEMENT:String = "Delete force event";
		public static const CHANGE_ELEMENT:String = "Change element";
		
		public function ComConst() {
			// constructor code
		}

	}
	
}
