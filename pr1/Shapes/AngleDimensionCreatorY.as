package  pr1.Shapes
{
  import pr1.ComConst;
  import pr1.Frame;

  public class AngleDimensionCreatorY extends AngleDimensionCreatorX
  {

    public function AngleDimensionCreatorY(frame:Frame)
    {
      super(frame);
      FIRST_POINT_NUM = ComConst.OY_PLUS;
    }


    override protected function getAngle():Number
    {
      var angle:Number = Math.PI/2;
      this.isInnerAngle = panel.isInnerAngle;

      if(!panel.isInnerAngle)
        angle -= Math.PI;

      return angle;
    }


    override protected function changeFirstPointCoord()
    {
      this.firstPointScreenCoord.y -= 20;
    }
  }
}