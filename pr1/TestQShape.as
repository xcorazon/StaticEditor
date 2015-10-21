package pr1{
	import pr1.Shapes.TriangularArrowsArray;
	import pr1.CoordinateTransformation;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class TestQShape extends Sprite {
		
		var position:Point;
		var angle:Number;
		var shapeContainer:Sprite;
		var isShapeIn:Boolean;
		
		public function TestQShape():void {
			
			var global = new Point(100,50);
			var localCoordPos = new Point(30,60);
			var angle:Number = 30 * Math.PI /180;
			
			var pLoc = CoordinateTransformation.screenToLocal(global, localCoordPos, angle);
			var pGlob = CoordinateTransformation.localToScreen(pLoc, localCoordPos, angle);
			
			var s:Shape = new Shape();
			s.graphics.beginFill(0xffffff);
			s.graphics.drawRect(0,0,800,600);
			s.graphics.endFill();
			this.addChild(s);
			shapeContainer = new Sprite();
			this.addChild(shapeContainer);
			stage.addEventListener(MouseEvent.CLICK, firstClick)
			isShapeIn = false;
		}
		
		private function firstClick(e:MouseEvent):void {
			position = new Point(e.stageX, e.stageY);
			shapeContainer.x = position.x;
			shapeContainer.y = position.y;
			stage.removeEventListener(MouseEvent.CLICK, firstClick);
			stage.addEventListener(MouseEvent.CLICK, secondClick);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, firstMove);
		}
		
		private function firstMove(e:MouseEvent):void {
			var shape;
			if(!isShapeIn){
			   isShapeIn = true;
			} else {
				shapeContainer.removeChildAt(0);
			}
			
			var length:Number = new Point(e.stageX - position.x, e.stageY - position.y).length;
			var angle:Number  = Math.acos((e.stageX - position.x)/length);
			if((-e.stageY + position.y) < 0) angle = -angle;
			shape = new TriangularArrowsArray(length, 65, angle, 0x0);
			shapeContainer.addChild(shape);
		}
		
		private function secondClick(e:MouseEvent):void {
			// получаем угол
			var dx:Number = e.stageX - position.x;
			var dy:Number = e.stageY - position.y;
			var R:Number = Math.sqrt( Math.pow((dx),2) + Math.pow((dy),2));
			
			var angle = Math.acos( dx/R);
			if (dy > 0){
				angle = -angle;
			}
			this.angle = angle;
			stage.removeEventListener(MouseEvent.CLICK, secondClick);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, firstMove);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(e:MouseEvent):void {
			var shape:Shape;
			this.removeChild(shapeContainer);
			
			//shape = new RectangularArrowsArray(this.position, new Point(e.stageX, e.stageY), false, 0xff0000);
			shapeContainer.x = position.x;
			shapeContainer.y = position.y;
			shapeContainer.addChild(shape);
			this.addChild(shapeContainer);
			
		}
		
	}
}