package  pr1.Shapes
{
  import pr1.Shapes.Sealing;
  import flash.geom.Point;

  public class FixedJoint extends Sealing
  {

    public function FixedJoint(color:uint = 0x0)
    {
      // constructor code
      super(color);
      this.graphics.clear();

      const WIDTH_OP = 45;
      const HEIGHT_OP = 30;

      super.fillShtrih( new Point(-WIDTH_OP/2, HEIGHT_OP),
            new Point(-WIDTH_OP/2, HEIGHT_OP + 10),
            new Point(WIDTH_OP/2, HEIGHT_OP + 10),
            new Point(WIDTH_OP/2, HEIGHT_OP));



      graphics.lineStyle(2, color, 1);
      graphics.moveTo(-WIDTH_OP/2,HEIGHT_OP);
      graphics.lineTo(WIDTH_OP/2, HEIGHT_OP);

      graphics.moveTo( -((HEIGHT_OP / 2 )/Math.cos(Math.PI/6)), HEIGHT_OP);
      graphics.lineTo(0, 0);

      graphics.moveTo( ((HEIGHT_OP / 2)/Math.cos(Math.PI/6)), HEIGHT_OP);
      graphics.lineTo(0, 0);

      graphics.drawCircle( ((HEIGHT_OP / 2)/Math.cos(Math.PI/6)), HEIGHT_OP, 4);

      graphics.drawCircle(-((HEIGHT_OP / 2)/Math.cos(Math.PI/6)), HEIGHT_OP, 4);

      graphics.drawCircle(0, 0, 4);

      graphics.beginFill(0xFFffFF);
      graphics.drawCircle( ((HEIGHT_OP / 2)/Math.cos(Math.PI/6)), HEIGHT_OP, 3.3);
      graphics.endFill();

      graphics.beginFill(0xFFffFF);
      graphics.drawCircle( -((HEIGHT_OP / 2)/Math.cos(Math.PI/6)), HEIGHT_OP, 3.3);
      graphics.endFill();

      graphics.beginFill(0xFFffFF);
      graphics.drawCircle(0, 0, 3.3);
      graphics.endFill();
    }
  }
}
