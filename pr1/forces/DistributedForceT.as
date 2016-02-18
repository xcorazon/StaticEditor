package  pr1.forces
{
  import flash.geom.Point;
  import flash.display.DisplayObject;
  import pr1.CoordinateTransformation;
  import pr1.Frame;

  public class DistributedForceT extends DistributedForceR
  {
    public function DistributedForceT(frame:Frame, up:DisplayObject = null, over:DisplayObject = null, down:DisplayObject = null,
                                      hitTest:DisplayObject = null, forceName:String = null)
    {
      super(frame, up, over, down, hitTest, forceName);
    }
    
    override public function setCoordOfSignatures()
    {
      var sign = arrowsHeight >= 0 ? 1 : -1;
      var height = Math.max(Math.abs(arrowsHeight), 26) + 10;
      var p:Point = new Point(arrowsLength, sign * height);
      p = CoordinateTransformation.rotate(p, angleOfAxis);
      p.y *= -1;
      p.x = p.x - signatures.name.width/2;
      p.y = p.y - signatures.name.height/2;
      setCoordOfForceName(p);
    }
  }
}