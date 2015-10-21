package  pr1.Shapes {
	import flash.geom.Point;
	import pr1.CoordinateTransformation;
	import flash.display.Shape;
	
	public class Segment extends Shape {
		public static const HORISONTAL:int = 0;
		public static const VERTICAL:int = 1;
		
		private var screenCoord1:Point;
		private var screenCoord2:Point;
		private var decartCoord1:Point;
		private var decartCoord2:Point;
		
		private var point1:int;
		private var point2:int;
		
		public function Segment(num1:int, num2:int, p1:Point, p2:Point, color:uint = 0x0) {
			// constructor code
			screenCoord1 = p1;
			screenCoord2 = p2;
			decartCoord1 = CoordinateTransformation.screenToLocal( p1, new Point(0, 600), 0);
			decartCoord2 = CoordinateTransformation.screenToLocal( p2, new Point(0, 600), 0);
			point1 = num1;
			point2 = num2;
			this.graphics.lineStyle(2, color);
			this.graphics.moveTo(p1.x, p1.y);
			this.graphics.lineTo(p2.x, p2.y);
		}
		
		public function setColor( color:uint){
			this.graphics.clear();
			this.graphics.lineStyle(2, color);
			this.graphics.moveTo(screenCoord1.x, screenCoord1.y);
			this.graphics.lineTo(screenCoord2.x, screenCoord2.y);
		}
		
		public function get firstScreenCoord():Point {
			return screenCoord1.clone();
		}
		
		public function get secondScreenCoord():Point {
			return screenCoord2.clone();
		}
		
		public function get firstDecartCoord():Point {
			return decartCoord1.clone();
		}
		
		public function get secondDecartCoord():Point {
			return decartCoord2.clone();
		}
		
		public function get firstPointNumber():int{
			return point1;
		}
		
		public function get secondPointNumber():int{
			return point2;
		}
		
		public function get specialDirection():int {
			if(screenCoord1.x == screenCoord2.x){
				return VERTICAL;
			}
			if(screenCoord1.y == screenCoord2.y){
				return HORISONTAL;
			}
			return -1;
		}
	}
	
}
