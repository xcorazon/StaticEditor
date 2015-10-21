package pr1 {
	import flash.display.*;
	import flash.geom.Point;
	import flash.events.*;
	// опора с одной реакцией
	public class Opora extends Sprite {
		
		private var r1:Number;			// реакция в опоре
		private var coord:Point;		// координаты опоры на экране
		
		private var alpha_x:Number;		// угол между опорой и осью x
		private var isXY:Boolean;		// является ли эта опора началом координат
		
		private var angle_s:Number = -45;	// угол штриховки
		private var step:Number = 4;		// шаг штриховки
		
		private var tempSprite:Sprite;
		
		
		
		public function Opora() {
			drawElement();
			balka.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			balka.stage.addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		private function mouseMove(e:MouseEvent){
			var p:Point = balkaClose(e.stageX, e.stageY);
			this.x = p.x;
			this.y = p.y;
		}
		
		private function mouseClick(e:MouseEvent){
			var a:Array = balka.balkaCoords;
			var p:Point = balkaClose(e.stageX, e.stageY);
			
			if(FlatGeom.isPointBetween(p, a[0], a[1]) && FlatGeom.dLine(p, a[0], a[1]) == 0){
				balka.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				balka.stage.removeEventListener(MouseEvent.CLICK, mouseClick);
			}
		}
		
		// функция для штриховки 4-х угольного контура
		protected function fillShtrih(p1:Point, p2:Point, p3:Point, p4:Point):void {
			
			var shape:Shape = new Shape();
			var x1, a, b:Point;
			var s:Boolean = true;
			
			var p0:Point = p1.clone();
			// устанавливаем стиль линии
			shape.graphics.lineStyle(1,0,1);
			
			while(s){			
				// начинаем штриховку
				s = false;	
				p0.x += this.step;
				p0.y += this.step;

			
				x1 = crossLines(p1, p2, p0, Math.PI / 180 * this.angle_s);
				if(s = isOnTheLine(p1, p2, x1)){
					a = x1;
					trace(x1.toString());
				}
			
				x1 = crossLines(p2, p3, p0, Math.PI / 180 * this.angle_s);
				if(isOnTheLine(p2, p3, x1)){
					
					trace(x1.toString());
					if(s){
						b = x1;
					} else {
						a = x1;
						s = true;
					}
				}
			
				x1 = crossLines(p3, p4, p0, Math.PI / 180 * this.angle_s);
				if(isOnTheLine(p3, p4, x1)){
					trace(x1.toString());
					if(s){
						b = x1;
					} else {
						a = x1;
						s = true;
					}
				}
			
				x1 = crossLines(p4, p1, p0, Math.PI / 180 * this.angle_s);
				if(isOnTheLine(p4, p1, x1)){
					trace(x1.toString());
					if(s){
						b = x1;
					} else {
						a = x1;
						s = true;
					}
				}
				
				if(s){
					// если координаты получены, - добавляем линию
					shape.graphics.moveTo(a.x, a.y);
					shape.graphics.lineTo(b.x, b.y);
					addChild(shape);	
					}
			}
		}
		
		
		
		
		
		private function crossLines(p1:Point,
					    p2:Point,
					    p0:Point, angle):Point {
			// функция определяет точку пересечения двух прямых
			var p:Point = new Point();
			
			var a1 = p2.x - p1.x;
			var b1 = p2.y - p1.y;
			var c1 = p1.x * b1 - p1.y * a1;
			var a0 = Math.tan(angle);
			var b0 = p0.y - p0.x * a0;
			p.x = (c1 + a1 * b0)/(b1 - a1 * a0);
			p.y = a0 * p.x + b0;
			
			return p;
		}
		
		
		
		
		private function isOnTheLine(p1:Point, p2:Point, x1:Point):Boolean {
			// функция определяет принадлежит ли точка пересечения заданному отрезку
			// подразумевается что точка лежит на прямой, которая содержит в себе заданный отрезок
			var temp1:Point;
			var temp2:Point;
			var dotProduct:Number;
			
			temp1 = p1.subtract(x1);
			temp2 = p2.subtract(x1);
			
			dotProduct = temp1.x * temp2.x + temp1.y * temp2.y;
			
			return (dotProduct <=0);
		}
		
		public function drawElement():void {
			var shape:Shape = new Shape();
			var shape2:Shape = new Shape();
			
			var width_op = 25;
			var height_op = 30;
			fillShtrih( new Point(0,height_op),
						new Point(0,height_op + 10),
						new Point(width_op, height_op + 10),
						new Point(width_op, height_op));

			//this.graphics.beginFill(0xffffff);
			//this.graphics.drawRect(0, 0, width_op, height_op+10);
			//this.graphics.endFill();
			
			shape.graphics.lineStyle(2, 0, 1);
			shape.graphics.moveTo(0, height_op);
			shape.graphics.lineTo(width_op/2 - 4, height_op);
			addChild(shape);

			shape.graphics.lineStyle(2, 0, 1);
			shape.graphics.moveTo(width_op, height_op);
			shape.graphics.lineTo(width_op/2 + 4, height_op);
			addChild(shape);

			shape.graphics.drawCircle(width_op/2, height_op, 4);
			addChild(shape);
			
			shape.graphics.drawCircle(width_op/2, 8, 4);
			addChild(shape);
			
			shape2.graphics.beginFill(0xFFffFF);
			shape2.graphics.drawCircle(width_op/2, height_op, 3);
			shape2.graphics.endFill();
			addChild(shape2);
			
			shape2.graphics.lineStyle(2, 0, 1);
			shape2.graphics.moveTo(width_op/2, height_op-4);
			shape2.graphics.lineTo(width_op/2, 12);
			addChild(shape2);			
			
		}

		// проверка наличия рядом балки или составляющих ее элементов
		protected function balkaClose(x:Number, y:Number):Point {
			
			// проверяем находится ли точка на отрезке
			
			var p:Point = new Point(x,y);
			var p1:Point = new Point(x,y);
			var a:Array = balka.balkaCoords;
			
			var b:Boolean = false;
			
			// проверяем концы отрезка
				for( var i in a){
					if(FlatGeom.dPoint(p, a[i]) < DELTA){
						b = true;
						p1 = a[i];
						return p1;
					}
				}
			// проверяем весь отрезок	
			if(FlatGeom.dLine(p, a[0], a[1]) < DELTA || b){
				p1 = FlatGeom.nearPoint(p, a[0], a[1]);
				if(!FlatGeom.isPointBetween(p1, a[0], a[1])) return p;
				
				// проверяем силы
				var forces:Array = balka.forces;
				for( i in forces){
					if(FlatGeom.dPoint(p, forces[i].getCoord()) < DELTA){
						b = true;
						p1 = forces[i].getCoord()
						return p1;
					}
				}
				// проверяем моменты
				forces = balka.moments;
				for( i in forces){
					if(FlatGeom.dPoint(p, forces[i].getCoord()) < DELTA){
						b = true;
						p1 = forces[i].getCoord()
						return p1;
					}
				}
				
				// проверяем распределенные нагрузки
				forces = balka.ql;
				for( i in forces){
					if(FlatGeom.dPoint(p, forces[i].getCoord1()) < DELTA){
						b = true;
						p1 = forces[i].getCoord1()
						return p1;
					}
					if(FlatGeom.dPoint(p, forces[i].getCoord2()) < DELTA){
						b = true;
						p1 = forces[i].getCoord2()
						return p1;
					}
				}
			}
			return p1;
		}
		
	}
}