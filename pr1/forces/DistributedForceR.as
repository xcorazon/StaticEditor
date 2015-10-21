package  pr1.forces{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import pr1.Shapes.Segment;
	import pr1.windows.EditWindowQ;
	import pr1.windows.EditWindow;
	import pr1.Shapes.Designation;
	import pr1.ComConst;
	import flash.text.Font;
	
	
	public class DistributedForceR extends Sprite {
		
		public var angleValue:String;		// +90 или -90 градусов
		private var ownerSegmentOfForce:Segment;
		private var forceName1:String;
		private var forceValue1:String;
		private var dimension1:String;
		public var forceNumber1:int;
		public var forceNumber2:int;
		private var firstScreenCoord1:Point;
		private var secondScreenCoord1:Point;
		
		private var button:SimpleButton;
		private var dialogWnd:EditWindowQ;
		
		private var forceSignature:Designation = null;
		private var forceSignatureCoord:Point;
		private var parent1:*;
		private var timesFont:Font;
		
		public var mustBeDeleted:Boolean = false;
		
		public function DistributedForceR(parent:*, upState:DisplayObject = null,
							   overState:DisplayObject = null,
							   downState:DisplayObject = null,
							   hitTestState:DisplayObject = null,
							   forceName:String = null) {
			super();
			timesFont = new Times1();
			parent1 = parent;
			button = new SimpleButton(upState, overState, downState, hitTestState);
			addChild(button);
			this.forceName = forceName;
			firstScreenCoord = new Point(0,0);
			secondScreenCoord = new Point(0,0);
			
			button.addEventListener(MouseEvent.CLICK, onMouseClick);
			
		}
		
		private function onMouseClick(e:MouseEvent){
			dispatchEvent( new Event(ComConst.LOCK_ALL, true));
			forceSignatureCoord = new Point(forceSignature.x, forceSignature.y);
			
			dialogWnd = new EditWindowQ(forceValue1, forceName1);
			dialogWnd.dimension = dimension1;
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
			forceName = dialogWnd.force;
			forceValue = dialogWnd.value;
			dimension = dialogWnd.dimension;
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
		

		public function setCoordOfForceName(p:Point){
			forceSignature.x = p.x;
			forceSignature.y = p.y;
			forceSignatureCoord = p.clone();
		}
		
		public function set forceValue(value:String){
			forceValue1 = value;
		}
		
		public function get forceValue():String {
			return forceValue1;
		}
		
				
		public function set forceName(value:String){
			forceName1 = value;
			if(forceSignature == null){
				forceSignature = new Designation(forceName1, timesFont.fontName/*"Times New Roman"*/);
				addChild(forceSignature);
			} else {
				removeChild(forceSignature);
				forceSignature = new Designation(forceName1, timesFont.fontName/*"Times New Roman"*/);
				addChild(forceSignature);
				forceSignature.x = forceSignatureCoord.x;
				forceSignature.y = forceSignatureCoord.y;
			}
		}
		
		public function get forceName():String {
			return forceName1;
		}
		
		public function set segment(seg:Segment){
			ownerSegmentOfForce = seg;
		}
		
		public function get segment():Segment{
			return ownerSegmentOfForce;
		}
		
		public function set dimension(dim:String){
			dimension1 = dim;
		}
		
		public function get dimension():String{
			return dimension1;
		}
		
		public function set firstScreenCoord(p:Point){
			firstScreenCoord1 = p.clone();
		}
		
		public function get firstScreenCoord():Point{
			return firstScreenCoord1.clone();
		}

		public function set secondScreenCoord(p:Point){
			secondScreenCoord1 = p;
		}
		
		public function get secondScreenCoord():Point{
			return secondScreenCoord1.clone();
		}
		
		public function lock(){
			button.hitTestState = null;
			forceSignature.disable();
		}
		
		public function unlock(){
			button.hitTestState = button.upState;
			forceSignature.enable();
		}
		
		public function destroy(){
			button.removeEventListener(MouseEvent.CLICK, onMouseClick);
			forceSignature.destroy();
		}
		
	}
	
}
