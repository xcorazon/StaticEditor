package pr1.geometriya{
	import flash.geom.Point;
	
	public class FlatGeom {
	
			// функция определяет расстояние между прямой и точкой 
		// p - координаты точки
		// p1, p2 - координаты точек направляющего вектора прямой
		public static function dLine(p:Point, p1:Point, p2:Point):Number {
			var a_x:Number = p2.x - p1.x;
			var a_y:Number = p2.y - p1.y;
		
			var A:Number = a_y;
			var B:Number = -a_x;
			var C:Number = a_x * p1.y - a_y * p1.x;
		
			var d:Number = Math.abs((A*p.x + B*p.y + C)/Math.sqrt(A*A + B*B));
		
			return d;
		}
		// вычисляет расстояние между двумя точками
		public static function dPoint(p1:Point, p2:Point):Number{
			return Math.sqrt((p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y));
		}

		// определяем находится ли точка на отрезке (не на прямой это существенный пункт!!!
		public static function isPointBetween(p:Point, p1:Point, p2:Point):Boolean{
			// функция определяет принадлежит ли точка пересечения заданному отрезку
			// подразумевается что точка лежит на прямой, которая содержит в себе заданный отрезок
			var temp1:Point;
			var temp2:Point;
			var dotProduct:Number;
			
			temp1 = p1.subtract(p);
			temp2 = p2.subtract(p);
			
			dotProduct = temp1.x * temp2.x + temp1.y * temp2.y;
			
			return (dotProduct <= 0);
		}
		
		// определяем положение ближайшей к данной точки, лежащей на прямой
		public static function nearPoint(p:Point, p1:Point, p2:Point):Point {
			var a_x:Number = p2.x - p1.x;
			var a_y:Number = p2.y - p1.y;
			var l1:Number = Math.sqrt(a_x * a_x + a_y * a_y);
			
			var b_x:Number = p.x - p1.x;
			var b_y:Number = p.y - p1.y;
			var l2:Number = Math.sqrt(b_x * b_x + b_y * b_y);
			
			var cos:Number = (a_x * b_x + a_y * b_y)/(l1 * l2);
			
			var retPoint:Point = new Point();
			retPoint.x = p1.x + a_x/l1 * l2 * cos;
			retPoint.y = p1.y + a_y/l1 * l2 * cos;
			
			return retPoint;
		}
		
	}
}