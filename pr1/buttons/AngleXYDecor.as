package pr1.buttons {
  import pr1.Frame;
  import pr1.Shapes.Segment;
  
  public class AngleXYDecor extends BtnDecor
  {
    override public function isAllowUp():Boolean
    {
      for each (var seg in Frame.Instance.segments)
        if(seg.specialDirection != Segment.HORISONTAL && seg.specialDirection != Segment.VERTICAL)
          return true;
          
      return false;
    }
  }
}