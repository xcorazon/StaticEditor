//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows
{
  import flash.display.*;
  import pr1.windows.EditWindow;
  import pr1.panels.ComBox;
  import flash.events.*;
  import flash.text.*;

  public class EditWindowAngle extends EditWindow
  {
    public function EditWindowAngle(value:String, name:String)
    {
      super();
      removeChild(_children.forceValue);
      removeChild(_children.forceName);
      delete _children["forceValue"];
      delete _children["forceName"];
      
      var txtFormat:TextFormat = new TextFormat("Symbol1"/*myFont.fontName*/, 14, 0x0, true);
      var txtFormat1:TextFormat = new TextFormat("Arial", 12, 0x0, true);
      addBackground();
      var razmerName:TextField = new TextField();
      razmerName.x = 67;
      razmerName.y = -60;
      razmerName.width = 45;
      razmerName.height = 20;
      razmerName.border = true;
      razmerName.background = true;
      razmerName.type = TextFieldType.INPUT;
      razmerName.embedFonts = true;
      razmerName.restrict = "A-Za-z0-9_";
      razmerName.multiline = false;
      razmerName.maxChars = 5;
      razmerName.defaultTextFormat = txtFormat;
      addChild(razmerName);
      _children.name = razmerName;
      if(name != null)
        razmerName.text = name;

      var razmerValue:TextField = new TextField();
      razmerValue.x = 67;
      razmerValue.y = 0;
      razmerValue.width = 72;
      razmerValue.height = 20;
      razmerValue.border = true;
      razmerValue.background = true;
      razmerValue.type = TextFieldType.INPUT;
      razmerValue.defaultTextFormat = txtFormat1;
      razmerValue.restrict = "0-9.";
      razmerValue.multiline = false;
      addChild(razmerValue);
      _children.value = razmerValue;
      if(value != "")
        razmerValue.text = String(value);
    }

    override protected function addBackground():void
    {
      backgrnd = new Dialog6();
      backgrnd.stop();
      addChild(backgrnd);
    }
    
    override protected function fieldsEmpty():Boolean
    {
      return _children.name.length == 0 || _children.value.length == 0;
    }
    
    override protected function setEventData():Object
    {
      var data:Object = new Object();
      data.name = _children.name.text;
      data.value = Number(_children.value.text);
      
      return data;
    }
  }
}