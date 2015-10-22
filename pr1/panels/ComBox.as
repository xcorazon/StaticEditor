package pr1.panels
{
  import flash.display.Sprite;
  import flash.display.Shape;
  import flash.display.SimpleButton;
  import flash.events.*;
  import flash.text.*;
  
  public class ComBox extends Sprite
  {
    
    private var strings:Array;
    public var num:int = 0; // номер отображаемого элемента
    private var defaultText:TextField;
    private var popupWindow:Sprite;
    
    private var isPopupClose:Boolean;
    private var w:Number;
    private var h:Number;
    
    public function ComBox( w:Number, h:Number, strings:Array)
    {

      this.strings = strings;
      
      defaultText = new TextField();
      defaultText.x = 0;
      defaultText.y = 0;
      defaultText.width = w;
      defaultText.height = h;
      defaultText.text = strings[num];
      defaultText.border = true;
      defaultText.borderColor = 0x909090;
      defaultText.background = true;
      defaultText.backgroundColor = 0xffffff;
      addChild(defaultText);
      this.w = w;
      this.h = h;
      
      width = w;
      this.height = h;
      
      defaultText.addEventListener(MouseEvent.CLICK, onDefaultTextClick);
    }
    
    public function destroy()
    {
      defaultText.removeEventListener(MouseEvent.CLICK, onDefaultTextClick);
    }
    
    public function set numberOfText(n:int)
    {
      defaultText.text = strings[n];
    }
    
    public function get textInBox():String
    {
      return defaultText.text;
    }
    
    private function onDefaultTextClick(e:MouseEvent)
    {
      
      isPopupClose = false;
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
      
      for(var i:int = 0; i< strings.length; i++)
      {
        txt1 = new TextField();
        txt1.text = strings[i];
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
      
      popupWindow.addEventListener(MouseEvent.CLICK, onPopupClick);
      this.stage.addEventListener(MouseEvent.CLICK, onClickOut);
      
      
      popupWindow.height = this.h * strings.length;
      popupWindow.width = this.w;
      popupWindow.x = 0;
      popupWindow.y = -popupWindow.height;
      defaultText.removeEventListener(MouseEvent.CLICK, onDefaultTextClick);
    }
    
    private function onPopupClick(e:MouseEvent)
    {
      var i:int = int(Math.floor(e.target.y / this.h));
      this.num = i;
      this.defaultText.text = strings[i];
      
      popupWindow.removeEventListener(MouseEvent.CLICK, onPopupClick);
      this.stage.removeEventListener(MouseEvent.CLICK, onClickOut);
      defaultText.addEventListener(MouseEvent.CLICK, onDefaultTextClick);
      removeChild(popupWindow);
      isPopupClose = true;
    }
    
    private function onClickOut(e:MouseEvent)
    {
      if(!isPopupClose)
      {
        popupWindow.removeEventListener(MouseEvent.CLICK, onPopupClick);
        this.stage.removeEventListener(MouseEvent.CLICK, onClickOut);
        removeChild(popupWindow);
        defaultText.addEventListener(MouseEvent.CLICK, onDefaultTextClick);
        isPopupClose = true;
      }
    }
  }
}