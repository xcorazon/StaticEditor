﻿package pr1 {
	import flash.display.*;
	import flash.geom.Point;
	import flash.events.*;
	import pr1.Balka;
	import pr1.Sheme;
	import pr1.geometriya.FlatGeom;
	import pr1.windows.*;
	import pr1.forces.PShapeDisplayState;
	import pr1.forces.MShapeDisplayState;
	
	public class Opora3 extends Opora1 {
		
		private var r2:Number;			// 2-я реакция в опоре (r1 =Rx, r2 = Ry)
		
		public function Opora3(balka:Balka, sheme:Sheme) {
			super(balka,sheme);
		}
		
		override public function drawElement(color:uint = 0x00, left:Boolean = true, txt:String = ""):Sprite {
			
			var shape:Shape = new Shape();
			var tempSprite:Sprite = new Sprite();
			
			const HEIGHT_OP = 80;
			
			if(left){
				tempSprite.addChild(super.fillShtrih( new Point(-10, -HEIGHT_OP/2),
						  new Point(-10, HEIGHT_OP/2),
						  new Point(0, HEIGHT_OP/2),
						  new Point(0, -HEIGHT_OP/2)));
			} else {
				tempSprite.addChild(super.fillShtrih( new Point(0, -HEIGHT_OP/2),
						  new Point(0, HEIGHT_OP/2),
						  new Point(10, HEIGHT_OP/2),
						  new Point(10, -HEIGHT_OP/2)));
			}
			shape.graphics.lineStyle(2, color, 1);
			shape.graphics.moveTo(0, HEIGHT_OP/2);
			shape.graphics.lineTo(0, -HEIGHT_OP/2);
			tempSprite.addChild(shape);
			tempSprite.addChild(addText(txt));
			
			if(txt != "" ){
				var t:Sprite  = new PShapeDisplayState("R", txt +"y", "", new Point(0,-60), Math.PI/2, 0, 0, 0xff0000);
				var t1 = t.getChildAt(1);
				t1.y -=60;
				t1.x += 5;
				t1 = t.getChildAt(2);
				t1.y -=60;
				t1.x += 5;
				tempSprite.addChild(t);
				t = new PShapeDisplayState("R", txt +"x", "", new Point(60, 0), 0, 0, 0, 0xff0000);
				t1 = t.getChildAt(1);
				t1.y -=10;
				t1.x += 60;
				t1 = t.getChildAt(2);
				t1.y -=10;
				t1.x += 60;
				tempSprite.addChild(t);
				var k = -10;
				/*if(!left){
					k= 10;
				}*/
					t = new MShapeDisplayState("M",txt, new Point(0, 0), new Point(k,k),0, true,0, 0xff0000);
					tempSprite.addChild(t);
			}

			return tempSprite;
		}
		
		
		
		
		
		override protected function mouseMove(e:MouseEvent){
			var p:Point = new Point();		// здесь будет записана координата "прилипшего" курсора
			var a:Array = balka.balkaCoords;
			p = balkaClose(e.stageX, e.stageY);
			
			if(p == a[0]) left = true;
			else if(p == a[1]) left = false;
			
			super.mouseMove(e);
			
		}
		
		
		
		
		override protected function mouseClick(e:MouseEvent){
			var a:Array = balka.balkaCoords;
			var p:Point = balkaClose(e.stageX, e.stageY);
			
			
			if(p == a[0] || p == a[1]){
				sheme.removeEventListener(Sheme.CHANGE_BUTTON, super.changeButtonListener);
				balka.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				balka.stage.removeEventListener(MouseEvent.CLICK, mouseClick);
				tempSprite = drawElement(0x0, (p == a[0]));
				downState = tempSprite;
				upState = tempSprite;
				overState = drawElement(0xff, (p == a[0]));
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
	}
}
