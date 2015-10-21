package pr1 {
	import flash.display.*;
	import flash.geom.Point;
	import flash.events.*;
	import flash.text.*;
	import pr1.Balka;
	import pr1.Sheme;
	import pr1.windows.*;
	import pr1.geometriya.FlatGeom;
	import pr1.forces.PShapeDisplayState;
	
	// опора с одной реакцией
	public class Opora1 extends SimpleButton {
		
		public static const CREATE_COMPLETE:String = "Opora create done";
		public static const CREATE_CANCEL:String = "Opora create cancel";		
		
		private static const DELTA:int = 8;	// необходимая разница в пикселях для выравнивания
		
		private var r1:Number;			// реакция в опоре
		protected var coord:Point;		// координаты опоры на экране
		protected var oporaName:String; // наименование опоры
		
		private var alpha_x:Number;		// угол между опорой и осью x
		private var isXY:Boolean;		// является ли эта опора началом координат
		
		private var angle_s:Number = -45;	// угол штриховки
		private var step:Number = 4;		// шаг штриховки
		
		protected var tempSprite:Sprite;
		
		protected var balka:Balka;
		protected var sheme:Sheme;
		protected var left:Boolean = true;
		
		private var isChanged:int = 0;		// для функции mouseMove, если в первый раз
		public var wnd:EditWindow5;		// окно для редактирования опоры
		
		
		public function Opora1(balka:Balka, sheme:Sheme) {
			this.balka = balka;
			this.sheme = sheme;
			this.scaleX = 0.8;
			this.scaleY = 0.8;			
			tempSprite = drawElement(0x0, left);
			
			upState = tempSprite;
			this.balka.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			this.balka.stage.addEventListener(MouseEvent.CLICK, mouseClick);
			sheme.addEventListener(Sheme.CHANGE_BUTTON, changeButtonListener);
		}
		
		protected function mouseMove(e:MouseEvent){
			
			var xCursor:Number = e.stageX;
			var yCursor:Number = e.stageY;
			var p:Point = new Point();		// здесь будет записана координата "прилипшего" курсора
			p = balkaClose(xCursor, yCursor);
			
			
			tempSprite = drawElement(0x0, left);
			upState = tempSprite;
			
			if(p.x <= 90) return;
			
			if(isChanged == 1 ){
				this.x = p.x;
				this.y = p.y;
			} else {
				balka.addChild(this);
				this.x = p.x;
				this.y = p.y;
				isChanged = 1;
			}
			
		}
		
		
		
		protected function mouseClick(e:MouseEvent){
			var a:Array = balka.balkaCoords;
			var p:Point = balkaClose(e.stageX, e.stageY);
			
			
			if(FlatGeom.isPointBetween(p, a[0], a[1]) && FlatGeom.dLine(p, a[0], a[1]) == 0){
				sheme.removeEventListener(Sheme.CHANGE_BUTTON, changeButtonListener);
				balka.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				balka.stage.removeEventListener(MouseEvent.CLICK, mouseClick);
				downState = tempSprite;
				overState = drawElement(0xff, left);
				hitTestState   = downState;
				coord = p;
				
				balka.removeChild(this);
				balka.addOpora(this);
				
				wnd = new EditWindow5(oporaName);
				sheme.addChild(wnd);
				wnd.x = 400;
				// передаем сообщение о создании окна вверх по списку отображения
				wnd.y = 200;
				wnd.addEventListener(EditEvent1.END_EDIT, receiveDataFromWindow);
				wnd.addEventListener(EditWindow5.DELETE_OBJECT, deleteObjectListener);
				
			}
		}
		
		protected function receiveDataFromWindow(e:Event) {
			sheme.removeChild(wnd);
			wnd.removeEventListener(EditEvent1.END_EDIT, receiveDataFromWindow);
			wnd.removeEventListener(EditWindow5.DELETE_OBJECT, deleteObjectListener);
			oporaName = wnd.value;
			
			tempSprite = drawElement(0x0, left, oporaName);
			upState = tempSprite;
			downState = tempSprite;
			overState = drawElement(0xff, left, oporaName);
			hitTestState   = downState;
			
			dispatchEvent( new Event(Opora1.CREATE_COMPLETE));
			if(isChanged != 2){
				addEventListener(MouseEvent.CLICK, clickOnOpora);
				isChanged = 2;
			}
		}
		
		protected function deleteObjectListener(e:Event){
			sheme.removeChild(wnd);
			wnd.removeEventListener(EditEvent1.END_EDIT, receiveDataFromWindow);
			wnd.removeEventListener(EditWindow5.DELETE_OBJECT, deleteObjectListener);
			
			balka.removeOpora(this);
			dispatchEvent( new Event(Opora1.CREATE_COMPLETE));
			sheme.dispatchEvent( new Event(Sheme.SOMETHING_DELETE));
			if(isChanged == 2){
				removeEventListener(MouseEvent.CLICK, clickOnOpora);
			}
		}
		
		protected function clickOnOpora(e:MouseEvent){
			wnd = new EditWindow5(oporaName);
			sheme.addChild(wnd);
			wnd.x = 400;
			// передаем сообщение о создании окна вверх по списку отображения
			wnd.y = 200;
			wnd.addEventListener(EditEvent1.END_EDIT, receiveDataFromWindow);
			wnd.addEventListener(EditWindow5.DELETE_OBJECT, deleteObjectListener);
		}
				
		// функция для штриховки 4-х угольного контура
		protected function fillShtrih(p1:Point, p2:Point, p3:Point, p4:Point, color:uint = 0x00):Shape {
			
			var shape:Shape = new Shape();
			var x1, a, b:Point;
			var s:Boolean = true;
			
			var p0:Point = p1.clone();
			// устанавливаем стиль линии
			shape.graphics.beginFill(0xffffff);
			shape.graphics.drawRect(p1.x, p1.y, p3.x-p1.x, p3.y - p1.y);
			shape.graphics.endFill();
			
			shape.graphics.lineStyle(1,color,1);
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
					}
			}
			return shape;
		}
		
		
		
		
		protected function crossLines(p1:Point,
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
		
		
		
		protected function changeButtonListener(e:Event):void {
			sheme.removeEventListener(Sheme.CHANGE_BUTTON, changeButtonListener);
			
			balka.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			balka.stage.removeEventListener(MouseEvent.CLICK, mouseClick);
			balka.removeChild(this);
					
		}
		
		
		
		
		// функция определяет принадлежит ли точка пересечения заданному отрезку
		// подразумевается что точка лежит на прямой, которая содержит в себе заданный отрезок
		private function isOnTheLine(p1:Point, p2:Point, x1:Point):Boolean {
			
			var temp1:Point;
			var temp2:Point;
			var dotProduct:Number;
			
			temp1 = p1.subtract(x1);
			temp2 = p2.subtract(x1);
			
			dotProduct = temp1.x * temp2.x + temp1.y * temp2.y;
			
			return (dotProduct <=0);
		}
		
		
		
		// функция отрисовки опоры
		public function drawElement(color:uint = 0x00, left:Boolean = true, txt:String = ""):Sprite {
			var shape:Shape = new Shape();
			var shape2:Shape = new Shape();
			var tempSprite:Sprite = new Sprite();
			
			var width_op = 25;
			var height_op = 25;
			// заштриховываем нижнюю часть опоры
			tempSprite.addChild(fillShtrih( new Point(-width_op/2, height_op),
						new Point(-width_op/2, height_op + 10),
						new Point(width_op/2, height_op + 10),
						new Point(width_op/2, height_op)));
						
			// рисуем над штриховкой полосу			
			shape.graphics.lineStyle(2, color, 1);
			shape.graphics.moveTo(-width_op/2, height_op);
			shape.graphics.lineTo(-4, height_op);

			shape.graphics.moveTo(width_op/2, height_op);
			shape.graphics.lineTo(4, height_op);
			
			// рисуем вертикальную линию
			shape.graphics.moveTo(0, 4);
			shape.graphics.lineTo(0, height_op - 4);
			
			// рисуем окружность в полосе
			shape.graphics.drawCircle(0, height_op, 4);
			tempSprite.addChild(shape);
			
			shape2.graphics.lineStyle(2, color, 1);
			shape2.graphics.beginFill(0xFFFFFF);
			shape2.graphics.drawCircle(0, 0, 4);
			shape2.graphics.endFill();
			tempSprite.addChild(shape2);
			tempSprite.addChild(addText(txt));
			if(txt != ""){
				var t:Sprite  = new PShapeDisplayState("R", txt, "", new Point(0,-60), Math.PI/2, 0, 0, 0xff0000);
				var t1 = t.getChildAt(1);
				t1.y -=60;
				t1.x += 5;
				t1 = t.getChildAt(2);
				t1.y -=60;
				t1.x += 5;
				tempSprite.addChild(t);
			}
			return tempSprite;
		}

		protected function addText(txt:String):TextField {
			//добавляем текст
			var nadpis:TextField = new TextField();
			var txtFormat:TextFormat = new TextFormat("Times New Roman", 20, 0x0, true);
			txtFormat.italic = true;
			nadpis.defaultTextFormat = txtFormat;
			nadpis.text = txt;
			nadpis.height = nadpis.textHeight + 4;
			nadpis.width = nadpis.textWidth + 5;
			nadpis.multiline = false;
			nadpis.x = 10;
			nadpis.y = -25;
			return nadpis;
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
		
		
		public function activate():void {
			hitTestState   = tempSprite;
		}
		
		public function deactivate():void {
			hitTestState   = null;
		}
		
		public function getCoord():Point {
			return coord;
			
		}
		public function getName():String {
			return oporaName;
		}
	}
}