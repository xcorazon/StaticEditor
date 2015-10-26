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
    protected var backgrnd:MovieClip;
    // окно с ошибкой
    protected var errWindow:Sprite;
    //размерность нагрузки
    protected var _units:ComBox;
    
    protected var _children:Object;

    //кнопки
    protected var okButton:SimpleButton;
    protected var cancelButton:SimpleButton;

    public function EditWindow(value:String = "", name:String = "")
    {
      var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
      addBackground();
      var forceName:TextField = new TextField();
      with(forceName)
      {
        x = 70;
        y = -60;
        width = 41;
        height = 20;
        border = true;
        background = true;
        type = TextFieldType.INPUT;
        restrict = "A-Za-z_0-9";
        multiline = false;
        maxChars = 6;
        defaultTextFormat = txtFormat;
      }
      _children.forceName = forceName;
      addChild(forceName);
      if(name != null) 
        forceName.text = name;

      var forceValue:TextField = new TextField();
      with(forceValue)
      {
        x = 70;
        y = 0;
        width = 72;
        height = 20;
        border = true;
        background = true;
        type = TextFieldType.INPUT;
        defaultTextFormat = txtFormat;
        restrict = "0-9.";
        multiline = false;
      }
      _children.forceValue = forceValue;
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
    
    private function initEvents()
    {
      okButton.addEventListener(MouseEvent.CLICK, onOk);
      cancelButton.addEventListener(MouseEvent.CLICK, onCancel);
    }
    
    private function releaseEvents()
    {
      cancelButton.removeEventListener(MouseEvent.CLICK, onCancel);
      okButton.removeEventListener(MouseEvent.CLICK, onOk);
    }

    
    protected function addBackground():void
    {
      backgrnd = new Dialog1();
      backgrnd.stop();
      addChild(backgrnd);
    }

    
    protected function fieldsEmpty():Boolean
    {
      return _children.forceName.length == 0 || _children.forceValue.length == 0;
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
      data.forceName = _children.forceName.text;
      data.forceValue = Number(_children.forceValue.text);
      data.units = units;
      
      return data;
    }
    
    private function onOk(e:MouseEvent)
    {
      releaseEvents();

      if(fieldsEmpty())
        showError();
      else
        endDialog();
    }
    
    
    private function onCancel(e:MouseEvent)
    {
      releaseEvents();
      endDialog(true);
    }
    
    
    protected function showError()
    {
      errWindow.addEventListener("EndError", onError);
      addChild(errWindow);
    }

    
    protected function onError(e:Event)
    {
      errWindow.removeEventListener("EndError", onError);
      removeChild(errWindow);
      initEvents();
    }
    
    public function get units():String
    {
      return _units.textInBox;
    }
  }
}