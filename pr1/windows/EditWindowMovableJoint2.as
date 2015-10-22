//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows
{

  import flash.display.*;
  import pr1.windows.EditWindow;
  import pr1.EditEvent1;
  import flash.events.*;
  import flash.text.*;

  public class EditWindowMovableJoint2 extends Sprite
  {
    public static const DELETE_OBJECT:String = "Delete object";
    //текстовые поля для ввода информации
    private var reaction1:TextField;

    // фоновое изображение окна
    internal var backgrnd:MovieClip;
    // окно с ошибкой
    private var errWindow:Sprite;

    //кнопки
    internal var okButton:SimpleButton;
    internal var cancelButton:SimpleButton;

    public function EditWindowMovableJoint2(reaction:String)
    {
      var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
      var txtFormat1:TextFormat = new TextFormat("Symbol", 12, 0x0, true);
      addBackground();
      reaction1 = new TextField();
      reaction1.x = 65;
      reaction1.y = -29.5;
      reaction1.width = 45;
      reaction1.height = 20;
      reaction1.border = true;
      reaction1.background = true;
      reaction1.type = TextFieldType.INPUT;
      reaction1.restrict = "A-Za-z0-9_";
      reaction1.multiline = false;
      reaction1.maxChars = 5;
      reaction1.defaultTextFormat = txtFormat;
      addChild(reaction1);
      if(reaction != null) reaction1.text = reaction;

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

      okButton.addEventListener(MouseEvent.CLICK, okListener);
      cancelButton.addEventListener(MouseEvent.CLICK, cancelListener);

      //error_ok_button.addEventListener(MouseEvent.CLICK, errorListener);
    }

    internal function addBackground():void
    {
      backgrnd = new MovableJointDialog2();
      backgrnd.stop();
      addChild(backgrnd);
    }

    public function okListener(e:MouseEvent)
    {
      cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
      okButton.removeEventListener(MouseEvent.CLICK, okListener);

      if(reaction.length == 0)
      {
        // вывести окно с повтором ввода
        errWindow.addEventListener("EndError", errorListener);
        addChild(errWindow);
      }
      else
      {
        // послать сообщение об окончании ввода
        dispatchEvent(new Event(EditWindow.END_EDIT));
      }
    }

    public function cancelListener(e:MouseEvent)
    {
      cancelButton.removeEventListener(MouseEvent.CLICK, cancelListener);
      okButton.removeEventListener(MouseEvent.CLICK, okListener);
      reaction1.text = "";

      dispatchEvent(new Event(EditWindow.CANCEL_EDIT));
    }

    public function errorListener(e:Event)
    {
      errWindow.removeEventListener("EndError", errorListener);
      okButton.addEventListener(MouseEvent.CLICK, okListener);
      cancelButton.addEventListener(MouseEvent.CLICK, cancelListener);
      removeChild(errWindow);
    }

    public function get reaction():String
    {
      return reaction1.text;
    }
  }
}