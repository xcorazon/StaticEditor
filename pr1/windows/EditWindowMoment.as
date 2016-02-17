package pr1.windows
{
  import flash.display.MovieClip;
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

      _units = new ComBox(45, 20, new Array("Н*м", "Н*см", "Н*мм", "кН*м", "кН*см", "кН*мм"));
      _units.x = 70;
      _units.y = -10;
      addChild(_units);

      _children.forceName.y = -40;
      _children.forceValue.y = 20;
    }


    override protected function addBackground():void
    {
      backgrnd = new Dialog2();
      backgrnd.stop();
      addChild(backgrnd);
    }


    public override function set units(s:String)
    {
      switch(s)
      {
        case "H*м":
          _units.numberOfText = 0;
          break;
        case "Н*см":
          _units.numberOfText = 1;
          break;
        case "Н*мм":
          _units.numberOfText = 2;
          break;
        case "кН*м":
          _units.numberOfText = 3;
          break;
        case "кН*см":
          _units.numberOfText = 4;
          break;
        case "кН*мм":
          _units.numberOfText = 5;
      }
    }
  }
}