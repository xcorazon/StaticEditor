package  pr1.Shapes
{
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.events.MouseEvent;
  import flash.display.Sprite;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  import flash.display.Shape;
  import flash.text.Font;

  public class Designation extends Sprite
  {

    private var text1:TextField;
    private var lowIndex:TextField;
    private var isEnableDrag:Boolean = false;

    public function Designation(txt:String, font:String)
    {
      // constructor code
      var myFont:Font  = new Times1();
      var txtFormat1:TextFormat = new TextFormat(font, 18, 0x0, true);
      var txtFormat2:TextFormat = new TextFormat(myFont.fontName/*"Times New Roman"*/, 10,0x0,true);
      var pos:int;
      var naim:String;
      var index1:String;
      super();
      pos = txt.search("_");
      naim = " " + txt.slice(0, pos) + " ";

      if(pos != -1)
        index1 = txt.slice(pos + 1) + " ";
      else
      {
        index1 = "";
        naim = txt + " ";
      }
      txtFormat1.italic = true;

      text1 = new TextField();
      //text1.embedFonts = true;
      text1.defaultTextFormat = txtFormat1;
      text1.embedFonts = true;
      text1.antiAliasType = flash.text.AntiAliasType.ADVANCED;
      text1.text = naim;
      text1.multiline = false;
      text1.height = text1.textHeight + 5;
      text1.width = text1.textWidth + 3;
      addChild(text1);
      text1.x = 0;
      text1.y = 0;

      var lowIndex = new TextField();
      txtFormat2.italic = true;
      lowIndex.defaultTextFormat = txtFormat2;
      lowIndex.text = index1;
      lowIndex.embedFonts = true;
      text1.antiAliasType = flash.text.AntiAliasType.ADVANCED;
      lowIndex.height = lowIndex.textHeight + 5;
      lowIndex.width = lowIndex.textWidth + 8;
      lowIndex.multiline = false;

      lowIndex.x = text1.x + text1.width -8;
      lowIndex.y = text1.y + 12;
      addChild(lowIndex);

      enable();
    }

    private function onMouseDown(e:MouseEvent)
    {
      this.startDrag();
    }

    private function onMouseUp(e:MouseEvent)
    {
      this.stopDrag();
    }

    private function onMouseOver(e:MouseEvent)
    {
      Mouse.cursor = MouseCursor.HAND;
    }

    private function onMouseOut(e:MouseEvent)
    {
      Mouse.cursor = MouseCursor.AUTO;
    }

    public function enable()
    {
      if(!isEnableDrag)
      {
        isEnableDrag = true;
        this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      }
    }

    public function disable()
    {
      if(isEnableDrag)
      {
        isEnableDrag = false;
        this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      }
    }

    public function destroy()
    {
      disable();
    }
  }
}