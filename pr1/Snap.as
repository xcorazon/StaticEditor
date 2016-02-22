package  pr1{
	import pr1.forces.*;
	import pr1.CoordinateTransformation;
	import flash.geom.Point;
	import pr1.Shapes.Segment;
	
	public class Snap {
		public var segments:Array;
		public var distributedForcesR:Array;	// прямоугольная распределенная нагрузка
		public var distributedForcesT:Array;	// треугольная распределенная нагрузка
		public var concentratedForces:Array;
		public var joints:Array;
		
		private var threshold1:Number;
		
		private var lastSnappedObject1:*;		// последний объект к которому была осуществлена
												// привязка
		
		public function Snap(segments:Array = null, distributedForcesR:Array = null,
							 distributedForcesT:Array = null, concentratedForces:Array = null,
							 joints:Array = null) {
			// constructor code
			this.segments = segments;
			this.distributedForcesR = distributedForcesR;
			this.distributedForcesT = distributedForcesT;
			this.concentratedForces = concentratedForces;
			this.joints = joints;
			this.threshold = 10;
		}
		
		public function setSegments(segments:Array){
			this.segments = segments;
		}
		
		public function setDistributedForcesR(dfr:Array){
			this.distributedForcesR = dfr;
		}
		
		public function setDistributedForcesT(dft:Array){
			this.distributedForcesT = dft;
		}
		
		public function setConcentratedForces(cf:Array){
			this.concentratedForces = cf;
		}
		
		public function set threshold(n1:Number){
			this.threshold1 = n1;
		}
		
		// возвращает координату точки выровненную относительно координат точки
		// какого либо из существующих отрезков
		// Point - в экранной системе координат
		public function alignY(cursorPosition:Point):Point {
			var tempThres:Number;
			var seg:Segment;
			var p = cursorPosition.clone();
			tempThres = this.threshold1;
			for each (seg in segments){
				if(Math.abs(seg.firstScreenCoord.y - cursorPosition.y) < tempThres){
					p.y = seg.firstScreenCoord.y;
					tempThres = Math.abs(seg.firstScreenCoord.y - cursorPosition.y);
				}
				if(Math.abs(seg.secondScreenCoord.y - cursorPosition.y) < tempThres){
					p.y = seg.secondScreenCoord.y;
					tempThres = Math.abs(seg.secondScreenCoord.y - cursorPosition.y);
				}
			}
			return p;
		}
		
		// возвращает координату точки выровненную относительно координат точки
		// какого либо из существующих отрезков
		// Point - в экранной системе координат
		public function alignX(cursorPosition:Point):Point {
			var tempThres:Number;
			var seg:Segment;
			var p = cursorPosition.clone();
			tempThres = this.threshold1;
			for each (seg in segments){
				if(Math.abs(seg.firstScreenCoord.x - cursorPosition.x) < tempThres){
					p.x = seg.firstScreenCoord.x;
					tempThres = Math.abs(seg.firstScreenCoord.x - cursorPosition.x);
				}
				if(Math.abs(seg.secondScreenCoord.x - cursorPosition.x) < tempThres){
					p.x = seg.secondScreenCoord.x;
					tempThres = Math.abs(seg.secondScreenCoord.x - cursorPosition.x);
				}
			}
			return p;
		}
		
		// функция вычисляет расстояни от точки до отрезка
		public function distance(cursorPosition:Point, seg:Segment):Number {
			var segmentAngle:Number;
			var p:Point;
			var secondCoordOfSegment:Point;
			var localSecondCoordOfSegment:Point;
			var localCoordSystemPosition:Point;
			var thres:Number;
			
			localCoordSystemPosition = seg.firstScreenCoord;
			secondCoordOfSegment = seg.secondScreenCoord;
			
			p = seg.secondDecartCoord.subtract(seg.firstDecartCoord);
			segmentAngle = CoordinateTransformation.decartToPolar(p).y;
			p = CoordinateTransformation.screenToLocal(cursorPosition, localCoordSystemPosition, segmentAngle);
			localSecondCoordOfSegment = CoordinateTransformation.screenToLocal(secondCoordOfSegment, localCoordSystemPosition, segmentAngle);
			// расстояние от точки до прямой содержащей отрезок содержитсяя в p.y
			thres = Point.distance( new Point(0,0), p);
			thres = Math.min(thres, Point.distance(localSecondCoordOfSegment, p));
			if(p.x >=0 && p.x <= localSecondCoordOfSegment.x){
				thres = Math.min( thres, Math.abs(p.y));
			}
			return thres;
		}
		
		// функция выполняет привязку к отрезку в перпендикулярном направлении к отрезку
		// т.е. курсор прилипает к отрезку не зависимо от расстояния
		public function doSnapToSegment(cursorPosition:Point, seg:Segment):Point{
			var localCoordSystemPosition:Point = seg.firstScreenCoord;
			var localCoordSystemAngle:Number;
			var p:Point;	// временная переменная
			
			p = seg.secondDecartCoord.subtract(seg.firstDecartCoord);
			localCoordSystemAngle = CoordinateTransformation.decartToPolar(p).y;
			p = CoordinateTransformation.screenToLocal(cursorPosition, localCoordSystemPosition, localCoordSystemAngle);
			p.y = 0; // привязываем в локальной системе координат курсор к отрезку
			if(p.x < 0){
				p.x = 0;
			}
			var lengthOfSegment = Point.distance(seg.firstScreenCoord, seg.secondScreenCoord);
			if(p.x > lengthOfSegment){
				p.x = lengthOfSegment;
			}
			p = CoordinateTransformation.localToScreen(p, localCoordSystemPosition, localCoordSystemAngle);
			if(Point.distance(p, seg.firstScreenCoord) <= this.threshold1){
				p = seg.firstScreenCoord;
			}
			if(Point.distance(p, seg.secondScreenCoord) <= this.threshold1){
				p = seg.secondScreenCoord;
			}
			if(!p.equals(cursorPosition)){
				lastSnappedObject1 = seg;
			}
			return p;
		}
		
		// привязка к точке нагрузки принадлежащей определенному отрезку при достижении
		// определенного порога
		public function doSnapToForce(cursorPosition:Point, seg:Segment):Point {
			var localCoordSystemPosition:Point = seg.firstScreenCoord;
			var forcesPoints:Array = new Array();
			var tempThres = this.threshold1;
			var p:Point;
			var segAngle:Number;
			
			for each (var f:* in concentratedForces){
				if(f.segment == seg){
					forcesPoints.push( new Point(f.x, f.y));
				}
			}
			
			for each ( f in distributedForcesR){
				if(f.segment == seg){
					forcesPoints.push(f.firstScreenCoord);
					forcesPoints.push(f.secondScreenCoord);
				}
			}
			
			for each ( f in distributedForcesT){
				if(f.segment == seg){
					forcesPoints.push(f.firstScreenCoord);
					forcesPoints.push(f.secondScreenCoord);
				}
			}
			
			for each ( f in joints){
				if(f.segment == seg){
					forcesPoints.push( new Point(f.x, f.y));
				}
			}
			
			if(forcesPoints.length == 0) return cursorPosition;
			
			p = seg.secondDecartCoord.subtract(seg.firstDecartCoord);
			segAngle = CoordinateTransformation.decartToPolar(p).y;
			p = CoordinateTransformation.screenToLocal(cursorPosition, localCoordSystemPosition, segAngle);
			p.y = 0; // делаем привязку к отрезку
			var p1:Point = null;
			var tempPoint:Point;
			for ( var i in forcesPoints){
				tempPoint = CoordinateTransformation.screenToLocal(forcesPoints[i], localCoordSystemPosition, segAngle);
				if(Math.abs(tempPoint.x - p.x) < tempThres){
					p1 = forcesPoints[i].clone();
					tempThres = Math.abs(tempPoint.x - p.x);
				}
			}
			if(p1 == null){
				p = CoordinateTransformation.localToScreen(p, localCoordSystemPosition, segAngle);
			} else {
				p = p1;
			}
			return p;
		}
		
		public function doSnapToJoint(cursorPosition:Point, joint:*):Point {
			var p:Point = new Point(joint.x, joint.y);
			if(Point.distance(p, cursorPosition) <= this.threshold1){
				lastSnappedObject1 = joint;
				return p;
			} else {
				return cursorPosition;
			}
		}
		
		public function doSnapToConcentratedForce(cursorPosition:Point, force:ConcentratedForce):Point {
			var p:Point = new Point(force.x, force.y);
			if(Point.distance(p, cursorPosition) <= this.threshold1){
				lastSnappedObject1 = force;
				return p;
			} else {
				return cursorPosition;
			}
		}
		
		public function doSnapToDistributedForceR(cursorPosition:Point, force:DistributedForceR):Point {
			var p1:Point = force.firstScreenCoord;
			var p2:Point = force.secondScreenCoord;
			if(Point.distance(p1, cursorPosition) <= this.threshold1){
				lastSnappedObject1 = force;
				return p1;
			} else if(Point.distance(p2, cursorPosition) <= this.threshold1){
				lastSnappedObject1 = force;
				return p2;
			} else {
				return cursorPosition;
			}
		}
		
		public function doSnapToDistributedForceT(cursorPosition:Point, force:DistributedForceT):Point {
			var p1:Point = force.firstScreenCoord;
			var p2:Point = force.secondScreenCoord;
			if(Point.distance(p1, cursorPosition) <= this.threshold1){
				lastSnappedObject1 = force;
				return p1;
			} else if(Point.distance(p2, cursorPosition) <= this.threshold1){
				lastSnappedObject1 = force;
				return p2;
			} else {
				return cursorPosition;
			}
		}
		
		// привязка к любой существующей точке принадлежащей нагрузке отрезку или опоре при достижении
		// определенного порога
		public function doSnapToAnything(cursorPosition:Point):Point {
			var p:Point;
			for each (var seg in segments){
				if(Point.distance(cursorPosition, seg.firstScreenCoord) <= threshold1){
					lastSnappedObject1 = seg;
					return seg.firstScreenCoord.clone();
				}
				if(Point.distance(cursorPosition, seg.secondScreenCoord) <= threshold1){
					lastSnappedObject1 = seg;
					return seg.secondScreenCoord.clone();
				}
			}
			
			for each (var force in concentratedForces){
				p = doSnapToConcentratedForce(cursorPosition, force);
				if(!p.equals(cursorPosition)){
					return p;
				}
			}
			
			for each (var joint in joints){
				p = doSnapToJoint(cursorPosition, joint);
				if(!p.equals(cursorPosition)){
					return p;
				}
			}
			
			for each (force in distributedForcesR){
				p = doSnapToDistributedForceR(cursorPosition, force);
				if(!p.equals(cursorPosition)){
					return p;
				}
			}
			
			for each (force in distributedForcesT){
				p = doSnapToDistributedForceT(cursorPosition, force);
				if(!p.equals(cursorPosition)){
					return p;
				}
			}
			
			return cursorPosition;
		}
		
		public function get lastSnappedObject():Object{
			return lastSnappedObject1;
		}
		
	}
	
}
