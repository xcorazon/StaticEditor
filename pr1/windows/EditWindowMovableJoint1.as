//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows
{
  import flash.display.*;
  import pr1.windows.EditWindow;
  import pr1.EditEvent1;
  import flash.events.*;
  import flash.text.*;

  public class EditWindowMovableJoint1 extends EditWindow
  {
    public static const DELETE_OBJECT:String = "Delete object";

    public function EditWindowMovableJoint1(reaction_name:String, angle:String, angle_value:String)
    {
      var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
      var txtFormat1:TextFormat = new TextFormat("Symbol1", 14, 0x0, true);
      removeChild(_children.forceName);
      removeChild(_children.forceValue);
      var reaction = new TextField();
      with(reaction)
      {
        x = 160;
        y = -68.5;
        width = 45;
        height = 20;
        border = true;
        background = true;
        type = TextFieldType.INPUT;
        restrict = "A-Za-z0-9_";
        multiline = false;
        maxChars = 5;
        defaultTextFormat = txtFormat;
      }
      _children.reaction = reaction;
      addChild(reaction);
      if(reaction_name != null)
        reaction.text = reaction_name;

      var angleName = new TextField();
      with(angleName)
      {
        x = 160;
        y = -32.8;
        width = 45;
        height = 20;
        border = true;
        background = true;
        embedFonts = true;
        type = TextFieldType.INPUT;
        defaultTextFormat = txtFormat1;
        restrict = "A-Za-z0-9_";
        multiline = false;
      }
      _children.angle = angleName;
      addChild(angleName);
      if(angle != "")
        angleName.text = String(angle);

      var angleValue = new TextField();
      with (angleValue)
      {
        x = 160;
        y = 1.70;
        width = 45;
        height = 20;
        border = true;
        background = true;
        type = TextFieldType.INPUT;
        defaultTextFormat = txtFormat;
        restrict = "0-9.";
        multiline = false;
      }
      _children.angleValue = angleValue;
      addChild(angleValue);
      if(angleValue != "")
        angleValue.text = angle_value;

      okButton.x = 30;
      okButton.y = 50;

      cancelButton.x = 100;
      cancelButton.y = 50;
    }

    override protected function addBackground():void
    {
      backgrnd = new MovableJointDialog1();
      backgrnd.stop();
      addChild(backgrnd);
    }

    override protected function fieldsEmpty():Boolean
    {
      return _children.reaction.length == 0 || _children.angleValue.length == 0 || _children.angle.length == 0;
    }
    
    override protected function setEventData():Object
    {
      var data:Object = new Object();
      data.reaction = _children.reaction.text;
      data.angle = _children.angle.text;
      data.angleValue = Number(_children.angleValue.text);
      
      return data;
    }
  }
}