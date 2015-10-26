//ВНИМАНИЕ!!! часть кода написана на временной шкале EditWindow

package pr1.windows
{
  import flash.display.*;
  import pr1.windows.EditWindow;
  import pr1.panels.ComBox;
  import pr1.EditEvent1;
  import flash.events.*;
  import flash.text.*;
  
  public class EditWindowSealing extends EditWindow
  {
    
    public function EditWindowSealing(horisontalReaction:String, verticalReaction:String, moment:String)
    {
      super();
      removeChild(_children.forceValue);
      removeChild(_children.forceName);
      delete _children["forceValue"];
      delete _children["forceName"];
      
      var txtFormat:TextFormat = new TextFormat("Arial", 12, 0x0, true);
      var hReaction:TextField = new TextField();
      hReaction.x = 160;
      hReaction.y = -60;
      hReaction.width = 45;
      hReaction.height = 20;
      hReaction.border = true;
      hReaction.background = true;
      hReaction.type = TextFieldType.INPUT;
      hReaction.restrict = "A-Za-z0-9_";
      hReaction.multiline = false;
      hReaction.maxChars = 5;
      hReaction.defaultTextFormat = txtFormat;
      addChild(hReaction);
      _children.hReaction = hReaction;
      if(horisontalReaction != null)
        hReaction.text = horisontalReaction; 
      
      var vReaction:TextField = new TextField();
      vReaction.x = 160;
      vReaction.y = -30;
      vReaction.width = 45;
      vReaction.height = 20;
      vReaction.border = true;
      vReaction.background = true;
      vReaction.type = TextFieldType.INPUT;
      vReaction.defaultTextFormat = txtFormat;
      vReaction.restrict = "A-Za-z0-9_";
      vReaction.multiline = false;
      addChild(vReaction);
      _children.vReaction = vReaction;
      if(verticalReaction != "")
        vReaction.text = String(verticalReaction);
      
      var moment1:TextField = new TextField();
      moment1.x = 160;
      moment1.y = 0;
      moment1.width = 45;
      moment1.height = 20;
      moment1.border = true;
      moment1.background = true;
      moment1.type = TextFieldType.INPUT;
      moment1.defaultTextFormat = txtFormat;
      moment1.restrict = "A-Za-z0-9_";
      moment1.multiline = false;
      addChild(moment1);
      _children.moment = moment1;
      if(moment != "")
        moment1.text = String(moment);
      
    }
    
    override protected function addBackground():void
    {
      backgrnd = new SealingDialog();
      backgrnd.stop();
      addChild(backgrnd);
    }
    
    override protected function fieldsEmpty():Boolean
    {
      return _children.hReaction.length == 0 || _children.vReaction.length == 0 || _children.moment.length == 0;
    }
    
    override protected function setEventData():Object
    {
      var data:Object = new Object();
      data.hReaction = _children.hReaction.text;
      data.cReaction = _children.vReaction.text;
      data.moment = _children.moment.text;
      
      return data;
    }
  }
}