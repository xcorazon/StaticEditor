package pr1.buttons {
  import pr1.Frame;
  
  public class MovableJointDecor extends BtnDecor
  {
    override public function isAllowUp():Boolean
    {
      var opora1 = Frame.Instance.opora1;
      var opora2 = Frame.Instance.opora2;
      var opora3 = Frame.Instance.opora3;
      
      if(Frame.Instance.segments.length == 0)
        return false;
        
      var count = opora1.length;
      if (opora2 != null)
        count += 2;
      if (opora3 != null)
        count += 3;
        
      if (count >=3)
        return false;
        
      return true;
    }
  }
}