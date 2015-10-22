package pr1.windows
{
  import flash.display.MovieClip;
  import pr1.EditEvent;
  import pr1.windows.CheckButton;
  import pr1.panels.ComBox;
  import flash.events.*;
  import flash.text.*;

  public class EditWindowQ extends EditWindow
  {
    private var checkButton:CheckButton;

    public function EditWindowQ(forceValue:String, forceName:String)
    {
      super(forceValue, forceName);

      okButton.y = 80;
      cancelButton.y = 80;

      dimension1 = new ComBox(45, 20, new Array("Н/м", "Н/см", "Н/мм", "кН/м", "кН/см", "кН/мм"));
      dimension1.x = 70;
      dimension1.y = -10;
      addChild(dimension1);

      this.forceName.y = -40;
      this.forceValue.y = 20;
    }


    override internal function addBackground():void
    {
      backgrnd = new Dialog2();
      backgrnd.stop();
      addChild(backgrnd);
    }

    public function get dimension():String
    {
      return dimension1.textInBox;
    }

    public function set dimension(s:String)
    {
      switch(s){
        case "H/м":
          dimension1.numberOfText = 0;
          break;
        case "Н/см":
          dimension1.numberOfText = 1;
          break;
        case "Н/мм":
          dimension1.numberOfText = 2;
          break;
        case "кН/м":
          dimension1.numberOfText = 3;
          break;
        case "кН/см":
          dimension1.numberOfText = 4;
          break;
        case "кН/мм":
          dimension1.numberOfText = 5;
      }
    }
  }
}