//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows
{

  import flash.display.*;
  import pr1.windows.EditWindow;
  import pr1.EditEvent1;
  import flash.events.*;
  import flash.text.*;

  public class EditWindowMovableJoint2 extends EditWindow
  {
    //public static const DELETE_OBJECT:String = "Delete object";

    public function EditWindowMovableJoint2(reaction_name:String)
    {
      var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
      var txtFormat1:TextFormat = new TextFormat("Symbol", 12, 0x0, true);
      addBackground();
      var reaction = new TextField();
      with(reaction)
      {
        x = 65;
        y = -29.5;
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
      _children.reaction = reaction
      addChild(reaction);
      if(reaction_name != null)
        reaction.text = reaction_name;

      okButton = new OkButton();
      okButton.x = 15;
      okButton.y = 25;
      okButton.width = 40;
      okButton.height = 29;
      addChild(okButton);

      cancelButton = new CancelButton();
      cancelButton.x = 100;
      cancelButton.y = 25;
      cancelButton.width = 62;
      cancelButton.height = 29;
      addChild(cancelButton);

      errWindow = new ErrorDialog();
      errWindow.x = -65;
      errWindow.y = -35;

      initEvents();
    }

    override protected function addBackground():void
    {
      backgrnd = new MovableJointDialog2();
      backgrnd.stop();
      addChild(backgrnd);
    }
    
    override protected function fieldsEmpty():Boolean
    {
      return _children.reaction.length == 0;
    }
    
    override protected function setEventData():Object
    {
      var data:Object = new Object();
      data.reaction = _children.reaction.text;
      data.angle = "";
      data.angleValue = 0;
      
      return data;
    }
  }
}