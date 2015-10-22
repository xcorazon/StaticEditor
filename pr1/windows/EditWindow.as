//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows
{
  import flash.display.*;
  import flash.events.*;
  import flash.text.*;
  import pr1.panels.ComBox;
  import pr1.events.DialogEvent;

  public class EditWindow extends Sprite
  {
    public static const DELETE_FORCE:String = "Delete force";
    public static const END_EDIT:String = "End Edit";
    public static const CANCEL_EDIT:String = "Cancel Edit";

    //текстовые поля для ввода информации
    internal var forceName:TextField;
    internal var forceValue:TextField;
    // фоновое изображение окна
    internal var backgrnd:MovieClip;
    // окно с ошибкой
    internal var errWindow:Sprite;
    //размерность нагрузки
    protected var _units:ComBox;

    //кнопки
    internal var okButton:SimpleButton;
    internal var cancelButton:SimpleButton;

    public function EditWindow(value:String, name:String)
    {
      var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
      addBackground();
      forceName = new TextField();
      forceName.x = 70;
      forceName.y = -60;
      forceName.width = 41;
      forceName.height = 20;
      forceName.border = true;
      forceName.background = true;
      forceName.type = TextFieldType.INPUT;
      forceName.restrict = "A-Za-z_0-9";
      forceName.multiline = false;
      forceName.maxChars = 6;
      forceName.defaultTextFormat = txtFormat;
      addChild(forceName);
      if(name != null) 
        forceName.text = name;


      forceValue = new TextField();
      forceValue.x = 70;
      forceValue.y = 0;
      forceValue.width = 72;
      forceValue.height = 20;
      forceValue.border = true;
      forceValue.background = true;
      forceValue.type = TextFieldType.INPUT;
      forceValue.defaultTextFormat = txtFormat;
      forceValue.restrict = "0-9.";
      forceValue.multiline = false;
      addChild(forceValue);
      if(value != "") 
        forceValue.text = value;

      errWindow = new ErrorDialog();
      errWindow.x = -65;
      errWindow.y = -35;

      okButton = new OkButton();
      okButton.x = 30;
      okButton.y = 50;
      okButton.width = 40;
      okButton.height = 29;
      addChild(okButton);

      cancelButton = new CancelButton();
      cancelButton.x = 100;
      cancelButton.y = 50;
      cancelButton.width = 62;
      cancelButton.height = 29;
      addChild(cancelButton);

      initEvents()
    }
    
    protected function initEvents()
    {
      okButton.addEventListener(MouseEvent.CLICK, onOk);
      cancelButton.addEventListener(MouseEvent.CLICK, onCancel);
    }
    
    protected function releaseEvents()
    {
      cancelButton.removeEventListener(MouseEvent.CLICK, onCancel);
      okButton.removeEventListener(MouseEvent.CLICK, onOk);
    }

    
    internal function addBackground():void
    {
      backgrnd = new Dialog1();
      backgrnd.stop();
      addChild(backgrnd);
    }

    
    public function onOk(e:MouseEvent)
    {
      releaseEvents();

      if(fieldsEmpty())
        showError();
      else
        endDialog();
    }
    
    
    protected function fieldsEmpty():Boolean
    {
      return forceName.length == 0 || forceValue.length == 0;
    }
    
    
    private function endDialog(isCanceled = false)
    {
      var event:DialogEvent = new DialogEvent(DialogEvent.END_DIALOG);
      if (!isCanceled)
      {
        event.eventData = setEventData();
      }
      else
        event.canceled = true;
        
      dispatchEvent(event);
      _units.destroy();
    }
    
    protected function setEventData():Object
    {
      var data:Object = new Object();
      data.forceName = forceName;
      data.forceValue = Number(forceValue);
      data.units = _units.textInBox;
      
      return data;
    }
    
    
    public function onCancel(e:MouseEvent)
    {
      releaseEvents();
      endDialog(true);
    }
    
    
    protected function showError()
    {
      errWindow.addEventListener("EndError", onError);
      addChild(errWindow);
    }

    
    public function onError(e:Event)
    {
      errWindow.removeEventListener("EndError", onError);
      removeChild(errWindow);
      initEvents();
    }
  }
}