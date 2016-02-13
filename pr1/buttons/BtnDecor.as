package pr1.buttons {

  public class BtnDecor implements IBehavior
  {
  
    public function isAllowDown():Boolean
    {
      return true;
    }
    
    public function isAllowUp():Boolean
    {
      return true;
    }
    
    public function isAllowInactive():Boolean
    {
      return true;
    }
  }
}