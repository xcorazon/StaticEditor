package  pr1.razmers
{
  import flash.geom.Point;

  public class LinearDimensionContainer extends LinearDimensionYContainer
  {
    override public function setCoordOfRazmerName()
    {
      var width:Number = Point.distance(secondPointDecartCoord, firstPointDecartCoord);
      var p:Point = secondPointDecartCoord.subtract(firstPointDecartCoord);
      var angle = CoordinateTransformation.decartToPolar(p).y;
      var sign:int = 1;
      var p1:Point = new Point();


      if(angle > -Math.PI/2 && angle <= Math.PI/2)
      {
        p1.x = (width - signatures.name.width)/2;
        p1.y = razmerHeight + (signatures.name.height - 5);
        p1 = CoordinateTransformation.localToScreen(p1, new Point(0,0), angle);
        signatures.name.rotation = -angle*180/Math.PI;
      }
      else if(angle > Math.PI/2 || angle <= -Math.PI/2)
      {
        p1.x = (width + signatures.name.width)/2;
        p1.y = razmerHeight - (signatures.name.height - 5);
        p1 = CoordinateTransformation.localToScreen(p1, new Point(0,0), angle);
        signatures.name.rotation = 180 - angle*180/Math.PI;
      }
      signatures.name.x = p1.x;
      signatures.name.y = p1.y;
    }


    override public function set razmerName(value:String)
    {
      params.name = value;
      if(signatures.name == null)
      {
        signatures.name = new Designation(params.name, "Times New Roman");
      }
      else
      {
        removeChild(signatures.name);
        signatures.name = new Designation(params.name, "Times New Roman");
      }

      addChild(signatures.name);
      signatures.name.disable();
    }

    // горизонтальный, вертикальный, свободный размер
    override public function get razmerType():int
    {
      var p:Point = secondPointDecartCoord.subtract(firstPointDecartCoord);
      var angle = CoordinateTransformation.decartToPolar(p).y;

      if(angle == Math.PI/2 || angle == -Math.PI/2)
      {
        return VERTICAL_DIMENSION;
      }
      if(angle == Math.PI || angle == -Math.PI || angle == 0)
      {
        return HORISONTAL_DIMENSION;
      }
      return FREE_DIMENSION;
    }
  }
}
