package pr1.buttons {
  import pr1.Frame;
  
  public class AngleDecor extends BtnDecor
  {
    override public function isAllowUp():Boolean
    {
      return Frame.Instance.segments.length > 1;
    }
  }
}