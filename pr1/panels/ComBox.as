package pr1.panels{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.*;
	import flash.text.*;
	
	public class ComBox extends Sprite{
		
		private var txt:Array;
		public var num:int = 0;	// номер отображаемого элемента
		private var outText:TextField;
		private var popupWindow:Sprite;
		
		private var clicked:Boolean;
		private var w:Number;
		private var h:Number;
		
		public function ComBox( w:Number, h:Number, txt:Array){

			this.txt = txt;
			
			outText = new TextField();
			outText.x = 0;
			outText.y = 0;
			outText.width = w;
			outText.height = h;
			outText.text = txt[num];
			outText.border = true;
			outText.borderColor = 0x909090;
			outText.background = true;
			outText.backgroundColor = 0xffffff;
			addChild(outText);
			this.w = w;
			this.h = h;
			
			width = w;
			this.height = h;
			
			outText.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function destroy(){
			outText.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function set numberOfText(n:int){
			outText.text = txt[n];
		}
		
		public function get textInBox():String {
			return outText.text;
		}
		
		private function onMouseClick(e:MouseEvent){
			
			clicked = false;
			e.stopImmediatePropagation();
			
			popupWindow = new Sprite();
			
			
			var btn:SimpleButton;
			var shape:Shape = new Shape();
			var shape1:Shape = new Shape();
			var txt1:TextField;
			
			shape.graphics.beginFill(0x00ccff, 0.5);
			shape.graphics.lineStyle(1.0, 0xccff);
			shape.graphics.drawRect(1,1,this.w-2, this.h-2);
			shape.graphics.endFill();
			
			shape1.graphics.beginFill(0x00ccff, 0.2);
			shape1.graphics.drawRect(0,0,this.w, this.h);
			shape1.graphics.endFill();
			
			for(var i:int = 0; i< txt.length; i++){
				txt1 = new TextField();
				txt1.text = txt[i];
				txt1.width = this.w;
				txt1.height = this.h;
				txt1.x = 0;
				txt1.y = (i)*this.h;
				popupWindow.addChild(txt1);
				
				btn = new SimpleButton(null,shape,shape,shape1);
				btn.x = 0;
				btn.y = txt1.y;
				popupWindow.addChild(btn);
			}
			
			popupWindow.graphics.lineStyle(1.0, 0x909090);
			popupWindow.graphics.beginFill(0xffffff,0.8);
			popupWindow.graphics.drawRect(popupWindow.x, popupWindow.y, popupWindow.width, popupWindow.height);
			popupWindow.graphics.endFill();
			this.addChild(popupWindow);
			
			popupWindow.addEventListener(MouseEvent.CLICK, pWndListener);
			this.stage.addEventListener(MouseEvent.CLICK, clickListener);
			
			
			popupWindow.height = this.h * txt.length;
			popupWindow.width = this.w;
			popupWindow.x = 0;
			popupWindow.y = -popupWindow.height;
			outText.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function pWndListener(e:MouseEvent){
			
			var i:int = int(Math.floor(e.target.y / this.h));
			this.num = i;
			this.outText.text = txt[i];
			popupWindow.removeEventListener(MouseEvent.CLICK, pWndListener);
			this.stage.removeEventListener(MouseEvent.CLICK, clickListener);
			outText.addEventListener(MouseEvent.CLICK, onMouseClick);
			removeChild(popupWindow);
			clicked = true;
		}
		
		private function clickListener(e:MouseEvent){
			if(!clicked){
				popupWindow.removeEventListener(MouseEvent.CLICK, pWndListener);
				this.stage.removeEventListener(MouseEvent.CLICK, clickListener);
				removeChild(popupWindow);
				outText.addEventListener(MouseEvent.CLICK, onMouseClick);
				clicked = true;
			}
		}
		
	}
}