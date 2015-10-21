package pr1.tests {
	import pr1.Shapes.AngleDimension;
	import pr1.CoordinateTransformation;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class TestAngleDimension extends Sprite {
		private static const FIRST_POINT:int = 0;
		private static const SECOND_POINT:int = 1;
		private static const HEIGHT:int = 2;
		
		var position:Point;
		private var pointOfSecondSegment:Point
		
		var shapeContainer:Sprite;
		var razmer:AngleDimension;
		
		private var firstPoint:Point;
		private var secondPoint:Point;
		private var angle1:Number = 25 * Math.PI/180;
		
		private var doNow:int = FIRST_POINT;
		
		public function TestAngleDimension():void {
			
			var s:Shape = new Shape();
			s.graphics.beginFill(0xffffff);
			s.graphics.drawRect(0,0,800,600);
			s.graphics.endFill();
			this.addChild(s);
			shapeContainer = new Sprite();
			this.addChild(shapeContainer);
			
			this.stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			
		}
		
		private function onMouseClick(e:MouseEvent){
			switch(doNow){
				case FIRST_POINT:
					firstPointClick(e);
					break;
				case SECOND_POINT:
					secondPointClick(e);
					break;
				case HEIGHT:
					getHeight(e);
			}
		}
		
		private function onMouseMove(e:MouseEvent){
			switch(doNow){
				case SECOND_POINT:
					secondPointMove(e);
					break;
				case HEIGHT:
					heightMove(e);
			}
		}
		
		private function firstPointClick(e:MouseEvent){
			doNow = SECOND_POINT;
			position = new Point(e.stageX, e.stageY);
		}
		
		private function secondPointClick(e:MouseEvent){
			doNow = HEIGHT;
			pointOfSecondSegment = new Point(e.stageX, e.stageY);
			razmer = new AngleDimension(this.position, angle1, this.pointOfSecondSegment, new Point(10,10), 0xff5050);
			razmer.x = position.x;
			razmer.y = position.y;
			this.addChild(razmer);
		}
		
		private function getHeight(e:MouseEvent){
			this.stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function secondPointMove(e:MouseEvent){

		}
		
		private function heightMove(e:MouseEvent){
			var p:Point = new Point(e.stageX, e.stageY);
			
			this.removeChild(razmer);
			razmer = new AngleDimension(this.position, angle1, this.pointOfSecondSegment, p, 0xff5050);
			razmer.x = position.x;
			razmer.y = position.y;
			this.addChild(razmer);
		}
		
	}
}