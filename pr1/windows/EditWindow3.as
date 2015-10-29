package pr1.windows
{
  import flash.display.MovieClip;
  import pr1.EditEvent;
  import pr1.panels.ComBox;
  import flash.events.*;
  import flash.text.*;

  public class EditWindow3 extends EditWindow
  {

    private var angleNameField:TextField; // поле для ввода обозначения угла
    private var angleField:TextField;   // поле для ввода значения угла в градусах

    public function EditWindow3(forceValue:String, forceName:String, angleName:String, angle:String)
    {
      super(forceValue, forceName);

      okButton.y = 100;
      cancelButton.y = 100;

      var txtFormat:TextFormat = new TextFormat("Symbol1", 16, 0x0, true);
      var angleNameField:TextField = new TextField();
      with(angleNameField)
      {
        x = 70;
        y = 30;
        width = 41;
        height = 20;
        border = true;
        embedFonts = true;
        background = true;
        type = TextFieldType.INPUT;
        restrict = "a-z_0-9";
        multiline = false;
        maxChars = 6;
        defaultTextFormat = txtFormat;
        if(angleName != null)
          text = angleName;
      }
      _children.angleName = angleNameField;
      addChild(angleNameField);

      _units = new ComBox(35, 20, new Array("Н","кН"));
      _units.x = 70;
      _units.y = -30;
      addChild(_units);

      txtFormat.font = "Arial";
      txtFormat.size = 12;
      var angleField:TextField = new TextField();
      with(angleField)
      {
        x = 70;
        y = 60;
        width = 72;
        height = 20;
        border = true;
        background = true;
        type = TextFieldType.INPUT;
        restrict = "0-9.";
        multiline = false;
        defaultTextFormat = txtFormat;
        if(angle != "")
          text = angle;
      }
      _children.angleValue = angleField;
      addChild(angleField);
      if((angle == "0" || angle == "90" || angle == "180") && angleName == "")
      {
        angleField.type = TextFieldType.DYNAMIC;
        angleNameField.type = TextFieldType.DYNAMIC;
      }

    }
    
    override protected function fieldsEmpty():Boolean
    {
      return super.fieldsEmpty() || (angleName.length == 0 && !(angle == "0" || angle == "90" || angle == "180"));
    }
    
    override protected function setEventData():Object
    {
      var data:Object = super.setEventData();
      
      data.angleName = angleName;
      data.angleValue = Number(angle);
      
      return data;
    }

    override protected function addBackground():void
    {
      backgrnd = new Dialog3();
      backgrnd.stop();
      addChild(backgrnd);
    }

    public function get angleName():String
    {
      return _children.angleName.text;
    }

    public function get angle():String
    {
      return _children.angleValue.text;
    }


    override public function set units(s:String)
    {
      if( s == "Н")
      {
        _units.numberOfText = 0;
      }
      if( s == "кН")
      {
        _units.numberOfText = 1;
      }
    }
  }
}