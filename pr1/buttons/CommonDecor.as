package pr1.buttons {
  import pr1.Frame;
  
  public class CommonDecor extends BtnDecor
  {
    override public function isAllowUp():Boolean
    {
      if(Frame.Instance.segments.length == 0)
        return false;
        
      return true;
    }
  }
}