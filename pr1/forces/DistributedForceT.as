package  pr1.forces
{
  import flash.display.DisplayObject;
  import pr1.Frame;

  public class DistributedForceT extends DistributedForceR
  {
    public function DistributedForceT(frame:Frame, up:DisplayObject = null, over:DisplayObject = null, down:DisplayObject = null,
                                      hitTest:DisplayObject = null, forceName:String = null)
    {
      super(frame, up, over, down, hitTest, forceName);
    }
  }
}