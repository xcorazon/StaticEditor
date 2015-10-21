package pr1{
	import flash.geom.Point;
	// класс для координатных приобразований Coordinate Conversions
	
	// Свойства локальной системы координат:
	// ось х направлена вправо, ось y - вверх.
			
	// Свойства экранной системы координат:
	// ось х направлена вправо, ось y - вниз.
	
	public class CoordinateTransformation {
		private static var localCoordPosition:Point = new Point(0,0);
		private static var angle:Number = 0;
		
		
		public function setLocalCoordSystemPosition(localCoordSysPosition:Point){
			CoordinateTransformation.localCoordPosition = localCoordSysPosition
		}
		
		public function setLocalCoordSystemAngle(angle:Number){
			CoordinateTransformation.angle = angle;
		}
		
		public static function localToScreen(pointInLocal:Point, localCoordPosition:Point, angleLocalCoordSys:Number):Point {
			// pointInLocal - координата точки в локальной системе координат
			// localCoordPosition - положение локальной системы координат в глобальной 
			// angleLocalCoordSys - угол поворота локальной системы координат относительно глобальной в радианах
			var global:Point = new Point();
			
			global.x = localCoordPosition.x + pointInLocal.x * Math.cos(angleLocalCoordSys) - pointInLocal.y * Math.sin(angleLocalCoordSys);
			global.y = localCoordPosition.y - pointInLocal.x * Math.sin(angleLocalCoordSys) - pointInLocal.y * Math.cos(angleLocalCoordSys);
			
			return global;
		}
		//
		public static function screenToLocal(pointInGlobal:Point, localCoordPosition:Point, angleLocalCoordSys:Number):Point {
			// pointInGlobal - координата точки в глобальной системе координат
			var local:Point = new Point();;
			
			local.x = -(localCoordPosition.x - pointInGlobal.x)*Math.cos(angleLocalCoordSys) + (localCoordPosition.y - pointInGlobal.y)*Math.sin(angleLocalCoordSys);
			local.y = (localCoordPosition.x - pointInGlobal.x)*Math.sin(angleLocalCoordSys) + (localCoordPosition.y - pointInGlobal.y)*Math.cos(angleLocalCoordSys);
			return local;
		}
		
		// повернуть точку в декартовой системе координат на определенный угол
		public static function rotate(point:Point, angle:Number):Point {
			
			var retCoord:Point = new Point();
			retCoord.x = point.x * Math.cos(angle) - point.y * Math.sin(angle);
			retCoord.y = point.x * Math.sin(angle) + point.y * Math.cos(angle);
			
			return retCoord;
		}
		
		// преобразовать координаты точки из декартовой системы координат в полярную
		public static function decartToPolar(pointDecart:Point):Point {
			// на выходе Point.x = R
			// Point.y = angle
			var polarPoint:Point;
			var R:Number = Math.sqrt( Math.pow (pointDecart.x, 2) + Math.pow (pointDecart.y, 2) );
			var angle:Number;
			if( R != 0){
				angle = Math.acos( pointDecart.x / R );
			} else {
				angle = 0;
			}
			angle = (pointDecart.y < 0) ? -angle : angle;
			polarPoint = new Point(R, angle);
			return polarPoint;
		}
	}
}