package  pr1.razmers {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	import pr1.windows.EditWindowAngle;
	import pr1.windows.EditWindow;
	import pr1.Shapes.Segment;
	import pr1.Shapes.Designation;
	import pr1.Shapes.AngleDimension;
	import pr1.ComConst;
	import pr1.CoordinateTransformation;

	
	public class AngleDimensionContainer extends Sprite {
		
		private var razmerName1:String;
		private var razmerValue1:String;
		public var firstPointNumber:int;
		public var secondPointNumber:int;
		public var thirdPointNumber:int;
		public var firstPointScreenCoord:Point;
		public var secondPointScreenCoord:Point;
		public var thirdPointScreenCoord:Point;
		public var radius:Number;
		public var isInnerAngle:Boolean;
		public var razmerSign:int;
				
		private var button:SimpleButton;
		private var dialogWnd:EditWindowAngle;
		
		private var razmerSignature:Designation = null;
		private var razmerSignatureCoord:Point;
		private var parent1:*;
		
		public var mustBeDeleted:Boolean = false;
		
		public function AngleDimensionContainer(parent:*, upState:DisplayObject = null,
							   overState:DisplayObject = null,
							   downState:DisplayObject = null,
							   hitTestState:DisplayObject = null,
							   razmerName:String = null) {
			super();
			parent1 = parent;
			button = new SimpleButton(upState, overState, downState, hitTestState);
			addChild(button);
			this.razmerName = razmerName;
			razmerSignature.disable();
						
			button.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent){
			razmerSignatureCoord = new Point(razmerSignature.x, razmerSignature.y);
			
			dialogWnd = new EditWindowAngle(razmerValue1, razmerName1);
			dialogWnd.x = 400;
			dialogWnd.y = 300;
			parent1.addChild(dialogWnd);
			dialogWnd.addEventListener(EditWindow.END_EDIT, onEndDialog);
			dialogWnd.addEventListener(EditWindow.CANCEL_EDIT, onCancelDialog);
		}
		
		private function onEndDialog(e:Event){
			dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndDialog);
			dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelDialog);

			parent1.removeChild(dialogWnd);
			razmerName = dialogWnd.razmer;
			razmerValue = dialogWnd.value;
			setCoordOfRazmerName();
			dialogWnd = null;
			dispatchEvent(new Event(ComConst.CHANGE_ELEMENT, true));
		}
		
		private function onCancelDialog(e:Event){
			dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndDialog);
			dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelDialog);

			parent1.removeChild(dialogWnd);
			dialogWnd = null;
			mustBeDeleted = true;
			dispatchEvent(new Event(ComConst.DELETE_ELEMENT, true));
		}
		
		
		public function setCoordOfRazmerName(){
			var startAngle:Number;
			var endAngle:Number;
			var R:Number = this.radius + Math.abs(this.radius)/this.radius * 10;
			var p1:Point = CoordinateTransformation.screenToLocal(this.firstPointScreenCoord, new Point(0,600), 0);
			var p2:Point = CoordinateTransformation.screenToLocal(this.secondPointScreenCoord, new Point(0,600), 0);
			var p3:Point = CoordinateTransformation.screenToLocal(this.thirdPointScreenCoord, new Point(0,600), 0);
			var vector1:Point = p1.subtract(p2);
			var vector2:Point = p3.subtract(p2);
			startAngle = CoordinateTransformation.decartToPolar(vector1).y;
			endAngle = CoordinateTransformation.decartToPolar(vector2).y;
			
			if(!this.isInnerAngle) {
				if(startAngle > endAngle) R = -R;
				startAngle += Math.PI;
			}
			
			/*trace("Начальный угол: ", startAngle * 180/Math.PI);
			trace("Конечный угол: ", endAngle * 180/Math.PI);
			trace("Радиус: ", R);*/
			var positionOfSignature:Point = CoordinateTransformation.rotate( new Point(R,0), (startAngle + endAngle)/2);
			positionOfSignature.x = positionOfSignature.x - razmerSignature.width/2;
			positionOfSignature.y = positionOfSignature.y + razmerSignature.height/2;
			positionOfSignature = CoordinateTransformation.localToScreen(positionOfSignature, new Point(0,0), 0);
			
			razmerSignature.x = positionOfSignature.x;
			razmerSignature.y = positionOfSignature.y;			
		}
		
		public function set razmerValue(value:String){
			razmerValue1 = value;
		}
		
		public function get razmerValue():String {
			return razmerValue1;
		}
		
				
		public function set razmerName(value:String){
			
			razmerName1 = value;
			if(razmerSignature == null){
				razmerSignature = new Designation(razmerName1, "Symbol1");
			} else {
				removeChild(razmerSignature);
				razmerSignature.destroy();
				razmerSignature = new Designation(razmerName1, "Symbol1");
			}
			addChild(razmerSignature);
		}
		
		public function get razmerName():String {
			return razmerName1;
		}
		
		public function lock(){
			button.hitTestState = null;
			razmerSignature.disable();
		}
		
		public function unlock(){
			button.hitTestState = button.upState;
			razmerSignature.disable();
		}
		
		public function destroy(){
			button.removeEventListener(MouseEvent.CLICK, onMouseClick);
			razmerSignature.destroy();
		}
	}
	
}
