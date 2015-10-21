package pr1{
	import flash.display.*;
	import flash.events.*;
	import pr1.panels.*;
	
	public class Test extends Sprite {
		
		private var panel:PPanel;
		private var box:ComBox;
		
		public function Test() {

			panel = new PPanel();
			addChild(panel);
			panel.addEventListener(Panel.DESTROY, deletePanel);
			box = new ComBox(50,20, new Array("fghdf","Hello!","GoodBye!"));
			box.x=100;
			box.y=100;
			addChild(box);
		}
		
		private function deletePanel(e:Event){
			removeChild(panel);
			panel = null;
		}
		
	}
}