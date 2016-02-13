package pr1.buttons {
  public interface IBehavior
  {
    function isAllowDown():Boolean;
    function isAllowUp():Boolean;
    function isAllowInactive():Boolean;
  }
}