package pr1.windows
{
  import flash.display.MovieClip;
  import pr1.EditEvent;
  import pr1.windows.CheckButton;
  import pr1.panels.ComBox;
  import flash.events.*;
  import flash.text.*;

  public class EditWindowMoment extends EditWindow
  {

    private var checkButton:CheckButton;

    public function EditWindowMoment(forceValue:String, forceName:String)
    {
      super(forceValue, forceName);

      okButton.y = 80;
      cancelButton.y = 80;

      units = new ComBox(45, 20, new Array("Н*м", "Н*см", "Н*мм", "кН*м", "кН*см", "кН*мм"));
      units.x = 70;
      units.y = -10;
      addChild(units);

      this.forceName.y = -40;
      this.forceValue.y = 20;
    }


    override internal function addBackground():void
    {
      backgrnd = new Dialog2();
      backgrnd.stop();
      addChild(backgrnd);
    }

    public function set dimension(s:String)
    {
      switch(s)
      {
        case "H*м":
          units.numberOfText = 0;
          break;
        case "Н*см":
          units.numberOfText = 1;
          break;
        case "Н*мм":
          units.numberOfText = 2;
          break;
        case "кН*м":
          units.numberOfText = 3;
          break;
        case "кН*см":
          units.numberOfText = 4;
          break;
        case "кН*мм":
          units.numberOfText = 5;
      }
    }
  }
}