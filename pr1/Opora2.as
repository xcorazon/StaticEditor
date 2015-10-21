package pr1 {
	import flash.display.*;
	import flash.geom.Point;
	import pr1.Balka;
	import pr1.Sheme;
	import pr1.geometriya.FlatGeom;
	import pr1.forces.PShapeDisplayState;
	
	public class Opora2 extends Opora1 {
		
		private var r2:Number;			// 2-я реакция в опоре (r1 =Rx, r2 = Ry)
		
		public function Opora2(balka:Balka, sheme:Sheme) {
			super(balka,sheme);
		}
		
		override public function drawElement(color:uint = 0x00, left:Boolean = true, txt:String = ""):Sprite {
			
			var shape:Shape = new Shape();
			var shape2:Shape = new Shape();
			var tempSprite:Sprite = new Sprite();
			
			const WIDTH_OP = 45;
			const HEIGHT_OP = 30;
			
			tempSprite.addChild(super.fillShtrih( new Point(-WIDTH_OP/2, HEIGHT_OP),
						new Point(-WIDTH_OP/2, HEIGHT_OP + 10),
						new Point(WIDTH_OP/2, HEIGHT_OP + 10),
						new Point(WIDTH_OP/2, HEIGHT_OP)));
			
			
			
			shape.graphics.lineStyle(2, color, 1);
			shape.graphics.moveTo(-WIDTH_OP/2,HEIGHT_OP);
			shape.graphics.lineTo(WIDTH_OP/2, HEIGHT_OP);
			
			shape.graphics.moveTo( -((HEIGHT_OP / 2 )/Math.cos(Math.PI/6)), HEIGHT_OP);
			shape.graphics.lineTo(0, 0);
			
			shape.graphics.moveTo( ((HEIGHT_OP / 2)/Math.cos(Math.PI/6)), HEIGHT_OP);
			shape.graphics.lineTo(0, 0);
			
			shape.graphics.drawCircle( ((HEIGHT_OP / 2)/Math.cos(Math.PI/6)), HEIGHT_OP, 4);
			
			shape.graphics.drawCircle(-((HEIGHT_OP / 2)/Math.cos(Math.PI/6)), HEIGHT_OP, 4);
			
			shape.graphics.drawCircle(0, 0, 4);
			tempSprite.addChild(shape);
			
			
			shape2.graphics.beginFill(0xFFffFF);
			shape2.graphics.drawCircle( ((HEIGHT_OP / 2)/Math.cos(Math.PI/6)), HEIGHT_OP, 3.3);
			shape2.graphics.endFill();
			
			shape2.graphics.beginFill(0xFFffFF);
			shape2.graphics.drawCircle( -((HEIGHT_OP / 2)/Math.cos(Math.PI/6)), HEIGHT_OP, 3.3);
			shape2.graphics.endFill();
			
			shape2.graphics.beginFill(0xFFffFF);
			shape2.graphics.drawCircle(0, 0, 3.3);
			shape2.graphics.endFill();
			tempSprite.addChild(shape2);
			tempSprite.addChild(addText(txt));
			if(txt != ""){
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
			}
			return tempSprite;
		}
	}
}
