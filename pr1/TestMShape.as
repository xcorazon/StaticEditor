package pr1{
	import pr1.Shapes.ArcArrow;
	import pr1.CoordinateTransformation;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class TestMShape extends Sprite {
		
		var position:Point;
		var angle:Number;
		var shapeContainer:Sprite;
		var isShapeIn:Boolean;
		
		public function TestMShape():void {
			
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
			stage.removeEventListener(MouseEvent.CLICK, firstClick);
			stage.addEventListener(MouseEvent.CLICK, secondClick);
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
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(e:MouseEvent):void {
			var shape;
			if(!isShapeIn){
			   isShapeIn = true;
			} else {
				shapeContainer.removeChildAt(0);
			}
			this.removeChild(shapeContainer);
			
			shape = new ArcArrow(this.position, new Point(e.stageX, e.stageY), false, 0xff0000);
			shapeContainer.x = position.x;
			shapeContainer.y = position.y;
			shapeContainer.addChild(shape);
			this.addChild(shapeContainer);
			
		}
		
	}
}