package  pr1.Shapes
{
  import pr1.Shapes.TriangularArrowsArray;
  import pr1.forces.DistributedForceT;
  import pr1.Frame;
  import flash.display.Shape;

  
  public class DistributedForceTCreator extends DistributedForceRCreator
  {

    public function DistributedForceTCreator()
    {
      super();
      forceNumber1 = 4000 - 1;
      forceNumber2 = 4000;
    }
    
    override public function create()
    {
      super.create();
    }

    override protected function setImage(length:Number, height:Number, angle:Number)
    {
      elementImage = new TriangularArrowsArray(length, height, angle, 0);
      button_over = new TriangularArrowsArray(length, height, angle, 0xff);
      button_up = new TriangularArrowsArray(length, height, angle, 0);
      button_down = button_up;
      button_hit = button_up;
    }

    override protected function getImage(angle:Number):Shape
    {
      return new TriangularArrowsArray(10,20,angle,0);
    }
    
    override protected function getForce(forceName:String):*
    {
      return new DistributedForceT(Frame.Instance, button_up, button_over, button_down, button_hit, forceName);
    }
  }
}
