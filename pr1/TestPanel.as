package  pr1{
	import flash.display.Sprite;
	import pr1.panels.ConcentratedForcePanel;
	import flash.geom.Point;
	import flash.events.Event;
	
	public class TestPanel extends Sprite {
		private var p:ConcentratedForcePanel;
		
		public function TestPanel() {
			// constructor code
			p = new ConcentratedForcePanel();
			p.setSegmentPoints(8, new Point(10, 15), 9, new Point(50,20));
			p.addEventListener(ConcentratedForcePanel.CHANGE_STATE, onChangeState);
			addChild(p);
			p.x = 40;
			p.y = 50;
		}

		private function onChangeState(e:Event):void {
			trace(p.angleOfAxis);
		}
	}
	
}
