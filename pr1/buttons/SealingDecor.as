package pr1.buttons {
  import pr1.Frame;
  
  public class SealingDecor extends BtnDecor
  {
    override public function isAllowUp():Boolean
    {
      var opora1 = Frame.Instance.opora1;
      var opora2 = Frame.Instance.opora2;
      var opora3 = Frame.Instance.opora3;
      
      if(Frame.Instance.segments.length == 0)
        return false;
        
      if (opora1.length >= 1 || opora3 != null || opora2 != null)
        return false;
        
      return true;
    }
  }
}