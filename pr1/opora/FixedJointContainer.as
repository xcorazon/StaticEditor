package  pr1.opora {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	import pr1.windows.EditWindowFixedJoint;
	import pr1.windows.EditWindow;
	import pr1.Shapes.Designation;
	import pr1.Shapes.AngleDimension;
	import pr1.ComConst;
	import pr1.CoordinateTransformation;
	import pr1.Shapes.FixedJoint;
	import flash.display.Shape;
	import pr1.Shapes.Arrow;
	import pr1.Shapes.Segment;

	
	public class FixedJointContainer extends Sprite {
		
		private var angleOfFixedJoint:Number;
		public var pointNumber:int;
		private var horisontalReaction1:String;
		private var verticalReaction1:String;
				
		private var button:SimpleButton;
		private var dialogWnd:EditWindowFixedJoint;
		
		private var hReactionSignature:Designation = null;
		private var hSignatureCoord:Point = null;
		private var vReactionSignature:Designation = null;
		private var vSignatureCoord:Point = null;
		public var segment:Segment;
		private var parent1:*;
		
		public var mustBeDeleted:Boolean = false;
		
		public function FixedJointContainer(parent:*, angle) {
			super();
			parent1 = parent;
			var upState:FixedJoint = new FixedJoint();
			upState.rotation = angle;
			upState.scaleX = 0.8;
			upState.scaleY = 0.8;
			var overState:FixedJoint = new FixedJoint(0xff);
			overState.scaleX = 0.8;
			overState.scaleY = 0.8;
			overState.rotation = angle;
			button = new SimpleButton(upState, overState, upState, upState);
			addChild(button);
			
			var hArrow:Arrow = new Arrow(new Point(0,0), 0, new Point(5,0), false, 0xCC0000);
			var vArrow:Arrow = new Arrow(new Point(0,0), 0, new Point(0,-5), false, 0xCC0000);
			addChild(hArrow);
			addChild(vArrow);
			
			hSignatureCoord = new Point(50,0);
			vSignatureCoord = new Point(-0,-70);
						
			button.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent){
			hSignatureCoord = new Point(hReactionSignature.x, hReactionSignature.y);
			vSignatureCoord = new Point(vReactionSignature.x, vReactionSignature.y);
			
			dialogWnd = new EditWindowFixedJoint(horisontalReaction, verticalReaction);
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
			horisontalReaction = dialogWnd.horizontalReaction;
			verticalReaction = dialogWnd.verticalReaction;

			setCoordOfSignatures();
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
		
		
		public function setCoordOfSignatures(){
			hReactionSignature.x = hSignatureCoord.x;
			hReactionSignature.y = hSignatureCoord.y;
			vReactionSignature.x = vSignatureCoord.x;
			vReactionSignature.y = vSignatureCoord.y;
		}
				
		public function set horisontalReaction(value:String){
			horisontalReaction1 = value;
			if(hReactionSignature == null){
				hReactionSignature = new Designation(horisontalReaction1, "Times New Roman");
			} else {
				removeChild(hReactionSignature);
				hReactionSignature.destroy();
				hReactionSignature = new Designation(horisontalReaction1, "Times New Roman");
			}
			addChild(hReactionSignature);
		}
		
		public function get horisontalReaction():String {
			return horisontalReaction1;
		}
		
		public function set verticalReaction(value:String){
			verticalReaction1 = value;
			if(vReactionSignature == null){
				vReactionSignature = new Designation(verticalReaction1, "Times New Roman");
			} else {
				removeChild(vReactionSignature);
				vReactionSignature.destroy();
				vReactionSignature = new Designation(verticalReaction1, "Times New Roman");
			}
			addChild(vReactionSignature);
		}
		
		public function get verticalReaction():String {
			return verticalReaction1;
		}
		
		public function lock(){
			button.hitTestState = null;
			vReactionSignature.disable();
			hReactionSignature.disable();
		}
		
		public function unlock(){
			button.hitTestState = button.upState;
			vReactionSignature.enable();
			hReactionSignature.enable();
		}
		
		public function destroy(){
			button.removeEventListener(MouseEvent.CLICK, onMouseClick);
			vReactionSignature.destroy();
			hReactionSignature.destroy();
		}
	}
	
}
