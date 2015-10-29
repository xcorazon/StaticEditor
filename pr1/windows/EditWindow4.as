//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows
{
  import flash.display.*;
  import pr1.windows.EditWindow;
  import pr1.panels.ComBox;
  import flash.events.*;
  import flash.text.*;

  public class EditWindow4 extends EditWindow
  {

    public function EditWindow4(value:String, name:String)
    {
      super();
      removeChild(_children.forceValue);
      removeChild(_children.forceName);
      delete _children["forceValue"];
      delete _children["forceName"];
    
      var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
      var razmerName:TextField = new TextField();
      razmerName.x = 70;
      razmerName.y = -60;
      razmerName.width = 41;
      razmerName.height = 20;
      razmerName.border = true;
      razmerName.background = true;
      razmerName.type = TextFieldType.INPUT;
      razmerName.restrict = "A-Za-z0-9_";
      razmerName.multiline = false;
      razmerName.maxChars = 5;
      razmerName.defaultTextFormat = txtFormat;
      addChild(razmerName);
      _children.name = razmerName;
      if(name != null)
        razmerName.text = name;

      var razmerValue:TextField = new TextField();
      razmerValue.x = 70;
      razmerValue.y = 0;
      razmerValue.width = 72;
      razmerValue.height = 20;
      razmerValue.border = true;
      razmerValue.background = true;
      razmerValue.type = TextFieldType.INPUT;
      razmerValue.defaultTextFormat = txtFormat;
      razmerValue.restrict = "0-9.";
      razmerValue.multiline = false;
      addChild(razmerValue);
      _children.value = razmerValue;
      if(value != "")
        razmerValue.text = String(value);

      _units = new ComBox(35, 20, new Array("м","см","мм"));
      _units.x = 70;
      _units.y = -30;
      addChild(_units);
    }

    override protected function addBackground():void
    {
      backgrnd = new Dialog4();
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
      data.units = units;
      
      return data;
    }
    
    override public function set units(s:String)
    {
      if( s == "м")
      {
        _units.numberOfText = 0;
      }
      if( s == "см")
      {
        _units.numberOfText = 1;
      }
      if( s == "мм")
      {
        _units.numberOfText = 2;
      }
    }
  }
}