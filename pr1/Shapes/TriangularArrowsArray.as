package pr1.Shapes
{
  import flash.display.*;
  import flash.geom.Point;
  import pr1.CoordinateTransformation;

  public class TriangularArrowsArray extends Shape
  {

    private static const MAX_ARROWS_DISTANCE:int = 17;
    private static const ARROW_TIP_LENGTH:int = 10;

    private static var tipCoordsX:Array = [0,   2, 0, -2, 0];
    private static var tipCoordsY:Array = [0,  10, 7, 10, 0];

    private var h:Number;   // высота распределенной нагрузки
    private var color:uint;

    public function TriangularArrowsArray(length:Number, height:Number, localCoordSystemAngle:Number, color:uint = 0x0)
    {
      this.color = color;
      if( Math.abs(height) < 26 )
      {
        this.h = (height < 0) ? -26 : 26;
      }
      else
      {
        this.h = height;
      }
      drawAllArrows(length, h, localCoordSystemAngle);
      drawBar(length, h, localCoordSystemAngle);
    }

    private function drawAllArrows(length:Number, height:Number, localCoordSystemAngle:Number):void
    {

      var numArrows:int = getNumberOfArrows(length);
      var deltaX:Number = length/numArrows;
      var deltaY:Number = deltaX * h / length;
      var x:Number = 0;
      var currentHeight:Number = 0
      for (var i:int = 0; i<=numArrows; i++)
      {
        if(Math.abs(currentHeight) > ARROW_TIP_LENGTH)
        {
          drawArrow(x, currentHeight, localCoordSystemAngle);
        }
        else
        {
          drawVerticalLine(x, currentHeight, localCoordSystemAngle);
        }
        x += deltaX;
        currentHeight += deltaY;
      }
    }

    private function drawArrow(x:Number, height:Number, angle:Number)
    {
      var sign:Number = (height < 0) ? -1 : 1;
      var p:Point = new Point();
      var localCoordSystemPosition:Point = new Point(0,0);
      this.graphics.lineStyle(0.5, this.color,1.0,false,"normal",null,JointStyle.MITER);
      this.graphics.beginFill(this.color);
      for(var i:int = 0; i <= 4; i++)
      {
        p.x = tipCoordsX[i] + x;
        p.y = sign * tipCoordsY[i];
        p = CoordinateTransformation.localToScreen(p, localCoordSystemPosition, angle);
        if (i==0)
        {
          this.graphics.moveTo(p.x, p.y);
        }
        else
        {
          this.graphics.lineTo(p.x, p.y);
        }
      }
      this.graphics.endFill();
      // отрисовка конца стрелки
      p.x = x;
      p.y = sign*4;
      p = CoordinateTransformation.localToScreen(p, localCoordSystemPosition, angle);
      this.graphics.moveTo(p.x, p.y);
      p.x = x;
      p.y = height;
      p = CoordinateTransformation.localToScreen(p, localCoordSystemPosition, angle);
      this.graphics.lineTo(p.x, p.y);
    }

    private function drawVerticalLine(x:Number, height:Number, angle:Number):void
    {
      var p:Point = new Point(0,0);
      var localCoordSystemPosition:Point = new Point(0,0);
      p.x = x;
      p.y = 0;
      p = CoordinateTransformation.localToScreen(p, localCoordSystemPosition, angle);
      this.graphics.lineStyle(0.5, this.color,1.0,false,"normal",null,JointStyle.ROUND);
      this.graphics.moveTo(p.x, p.y);
      p.x = x;
      p.y = height;
      p = CoordinateTransformation.localToScreen(p, localCoordSystemPosition, angle);
      this.graphics.lineTo(p.x, p.y);
    }

    private function drawBar(length:Number, height:Number, localCoordSystemAngle:Number):void
    {
      var localCoordSystemPosition:Point = new Point(0,0);
      this.graphics.lineStyle(0.5, this.color,1.0,false,"normal",null,JointStyle.MITER);
      var p:Point = new Point(length, height);
      this.graphics.moveTo(0, 0);
      p = CoordinateTransformation.localToScreen(p, localCoordSystemPosition, localCoordSystemAngle);
      this.graphics.lineTo(p.x, p.y);
    }

    private function getNumberOfArrows(length:Number):int
    {
      var numArrows:int;
      var n:Number = Math.abs(length/MAX_ARROWS_DISTANCE);
      if(n < 2)
      {
        numArrows = 2;
      }
      else
      {
        numArrows = int(Math.ceil(n));   // округляем до ближайшего большего целого
      }
      return numArrows;
    }
  }
}