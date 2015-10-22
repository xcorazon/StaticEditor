package  pr1.Shapes
{
  import flash.display.Shape;
  import flash.display.JointStyle;
  import pr1.CoordinateTransformation;
  import flash.geom.Point;

  public class LinearDimension extends Shape
  {

    private static var a_x:Array = [2, 17, 12, 17, 2];
    private static var a_y:Array = [0,  3,  0, -3, 0];

    private var secondPointInLocal:Point;

    private var angle1:Number;
    private var height1:Number;
    private var width1:Number;
    private var color1:uint;

    public function LinearDimension(firstPoint:Point, secondPoint:Point, h:Number, angle:Number, color:uint = 0x0)
    {
      this.angle1 = angle;
      secondPointInLocal = getSecondPointInLocal(firstPoint, secondPoint, angle);
      this.width1 = getWidth();
      this.height1 = h;
      this.color1 = color;

      drawDimension();
      drawFirstBar();
      drawSecondBar();
    }

    private function drawFirstBar()
    {
      var p:Point;
      var h:Number;
      if(this.height1 >= 0) h = this.height1 + 4;
      else h = this.height1 - 4;

      this.graphics.lineStyle(1, color1 ,1.0,false,"normal",null,JointStyle.MITER);
      this.graphics.moveTo(0,0);
      p = CoordinateTransformation.localToScreen(new Point(0, h),new Point(0,0), this.angle1);
      this.graphics.lineTo(p.x, p.y);
    }

    private function drawSecondBar()
    {
      var p:Point;
      var h:Number;

      if(this.height1 - secondPointInLocal.y >= 0) h = this.height1 + 4;
      else h = this.height1 - 4;

      this.graphics.lineStyle(1, color1, 1.0, false, "normal", null, JointStyle.MITER);
      p = CoordinateTransformation.localToScreen(secondPointInLocal, new Point(0,0), this.angle1);
      this.graphics.moveTo(p.x, p.y);
      p = CoordinateTransformation.localToScreen( new Point(width1, h), new Point(0,0), this.angle1);
      this.graphics.lineTo(p.x, p.y);
    }

    private function drawDimension()
    {
      var points:Array;
      var localCoordSys:Point = new Point(0,0);
      points = getDimensionPoints();
      this.graphics.lineStyle(1, color1, 1.0, false, "normal", null, JointStyle.MITER);
      this.graphics.beginFill(color1);

      for ( var i in points)
      {
        points[i].y += height1;
        points[i] = CoordinateTransformation.localToScreen(points[i], localCoordSys, angle1);
        if (i == 0 || i == 5 || i == 10)
        {
          this.graphics.moveTo(points[i].x,points[i].y);
        }
        else
        {
          this.graphics.lineTo(points[i].x, points[i].y);
        }
      }

      this.graphics.endFill();
    }

    // получение координат каждой точки размера
    private function getDimensionPoints():Array
    {
      var retArray = new Array();
      var p:Point;
      var sign:int;

      if(width1 >= 0) sign = 1;
      else sign = -1;
      if(Math.abs(this.width1) >= 35)
      {
        for( var i = 0; i<=4; i++)
        {
          p = new Point( sign * a_x[i], a_y[i]);
          retArray.push(p);
        }
        for( i = 0; i<=4; i++)
        {
          p = new Point( sign * a_x[i], a_y[i]);
          p.x = -p.x + this.width1;
          retArray.push(p);
        }
        p = new Point(sign * 2, 0);
        retArray.push(p);
        p = new Point(this.width1 - sign * 2, 0);
        retArray.push(p);
      }
      else
      {
        for( i = 0; i<=4; i++)
        {
          p = new Point( sign * a_x[i], a_y[i]);
          p.x = -p.x;
          retArray.push(p);
        }
        for( i = 0; i<=4; i++)
        {
          p = new Point( sign * a_x[i], a_y[i]);
          p.x += this.width1;
          retArray.push(p);
        }
        p = new Point(-sign * 20, 0);
        retArray.push(p);
        p = new Point(this.width1 + sign * 20, 0);
        retArray.push(p);
      }

      return retArray;
    }

    private function getSecondPointInLocal(firstPoint:Point, secondPoint:Point, angle:Number):Point
    {
      var localCoordSys:Point = new Point(0,0);
      var p:Point = secondPoint.subtract(firstPoint);
      p = CoordinateTransformation.screenToLocal(p, localCoordSys, angle);
      return p;
    }

    private function getWidth():Number
    {
      return secondPointInLocal.x;
    }
  }
}
