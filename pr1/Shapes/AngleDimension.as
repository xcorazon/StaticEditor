package  pr1.Shapes
{
  import flash.display.Shape;
  import flash.display.JointStyle;
  import pr1.CoordinateTransformation;
  import flash.geom.Point;

  public class AngleDimension extends Shape
  {
    private static const MIN_RADIUS:Number = 20;

    private static var a_x:Array = [2, 17, 12, 17, 2];
    private static var a_y:Array = [0,  3,  0, -3, 0];

    private var secondPointInLocal:Point;
    private var localCoordSystemAngle:Number;

    private var angleBetweenSegments:Number;

    private var radius1:Number;

    private var color1:uint;

    public function AngleDimension(localCoordSystemPosition:Point,
                       localCoordSystemAngle:Number,
                     pointOfSecondSegment:Point,
                     cursorPosition:Point, color:uint = 0x0)
    {

      secondPointInLocal = CoordinateTransformation.screenToLocal(pointOfSecondSegment,
                                        localCoordSystemPosition,
                                        localCoordSystemAngle);
      this.localCoordSystemAngle = localCoordSystemAngle;

      this.radius1 = getRadius(localCoordSystemPosition, localCoordSystemAngle, cursorPosition);
      this.angleBetweenSegments = CoordinateTransformation.decartToPolar(secondPointInLocal).y;

      this.color1 = color;

      drawArrows();
      drawArc();
      drawAdditionalArcs();
      drawFirstBar();
      drawSecondBar();
    }

    private function drawFirstBar()
    {
      var p:Point;
      var h:Number;
      var r:Number;
      if(radius > 0) r = radius + 4;
      else r = radius - 4;

      this.graphics.lineStyle(1, color1,1.0,false,"normal",null,JointStyle.MITER);
      this.graphics.moveTo(0,0);
      p = CoordinateTransformation.rotate(new Point(r, 0), this.angleBetweenSegments);
      p = CoordinateTransformation.localToScreen( p, new Point(0,0), this.localCoordSystemAngle);
      this.graphics.lineTo(p.x, p.y);
    }

    private function drawSecondBar()
    {
      var p:Point;
      var r:Number;
      if(radius > 0) r = radius + 4;
      else r = radius - 4;

      this.graphics.lineStyle(1, color1, 1.0, false, "normal", null, JointStyle.MITER);
      this.graphics.moveTo(0, 0);
      p = CoordinateTransformation.localToScreen( new Point(r, 0), new Point(0,0), this.localCoordSystemAngle);
      this.graphics.lineTo(p.x, p.y);
    }

    private function drawArrows()
    {
      var points:Array;
      var localCoordSys:Point = new Point(0,0);
      points = firstArrowPoints.concat(secondArrowPoints);
      this.graphics.lineStyle(1, color1, 1.0, false, "normal", null, JointStyle.MITER);
      this.graphics.beginFill(color1);
        for ( var i in points)
        {
          points[i] = CoordinateTransformation.localToScreen(points[i], localCoordSys, localCoordSystemAngle);
          if (i == 0 || i == 5 )
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

    private function drawArc()
    {
      var points:Array;
      var localCoordSystemPosition:Point = new Point(0,0);
      points = arcPoints;
      this.graphics.lineStyle(1, color1);
      for (var i in points)
      {
        points[i] = CoordinateTransformation.localToScreen(points[i], localCoordSystemPosition, localCoordSystemAngle);
        if (i == 0)
        {
          this.graphics.moveTo(points[i].x,points[i].y);
        }
        else
        {
          this.graphics.lineTo(points[i].x,points[i].y);
        }
      }
    }

    private function drawAdditionalArcs()
    {
      var points:Array;
      var localCoordSystemPosition:Point = new Point(0,0);
      points = additionalArcPoints;
      if(!isArrowsBetweenBars)
      {
        this.graphics.lineStyle(1, color1);
        for (var i in points)
        {
          points[i] = CoordinateTransformation.localToScreen(points[i], localCoordSystemPosition, localCoordSystemAngle);
          if (i == 0 || i ==3)
          {
            this.graphics.moveTo(points[i].x,points[i].y);
          }
          else
          {
            this.graphics.lineTo(points[i].x,points[i].y);
          }
        }
      }
    }

    private function get additionalArcPoints()
    {
      var step:Number = correctionArcAngle/2;
      var p:Point = new Point(Math.abs(radius), 0);
      var arc:Array = new Array();

      var currentAngle = -correctionArcAngle;
      p = CoordinateTransformation.rotate(p, currentAngle);
      for(var i = 0;i<=2;i++)
      {
        arc.push(p);
        p = CoordinateTransformation.rotate(p, -step);
      }

      p = new Point(Math.abs(radius), 0);
      currentAngle = Math.abs(angleBetweenSegments) + correctionArcAngle;
      p = CoordinateTransformation.rotate(p, currentAngle);
      for( i = 0;i<=2;i++)
      {
        arc.push(p);
        p = CoordinateTransformation.rotate(p, step);
      }

      if(radius < 0)
      {
        for each (var pt:Point in arc)
        {
          pt.x = -pt.x;
          pt.y = -pt.y;
        }
      }
      if(angleBetweenSegments < 0)
      {
        for each (pt in arc)
        {
          pt.y = -pt.y;
        }
      }
      return arc;
    }

    private function get arcPoints()
    {
      var step:Number = Math.min(5*Math.PI/180, correctionArcAngle);
      var arc:Array = new Array();
      var p:Point = new Point(Math.abs(radius), 0);
      var endAngle:Number;

      if(isArrowsBetweenBars)
      {
        var currentAngle = correctionArcAngle;
        endAngle = Math.abs(angleBetweenSegments) - correctionArcAngle;
      }
      else
      {
        currentAngle = 0;
        endAngle = Math.abs(angleBetweenSegments);
      }
      var lastPoint = CoordinateTransformation.rotate(p,endAngle);
      p = CoordinateTransformation.rotate(p,currentAngle);
      while (Math.abs(currentAngle) < Math.abs(endAngle))
      {
        arc.push(p);
        p = CoordinateTransformation.rotate(p, step);
        currentAngle += step;
      }
      arc.push(lastPoint);

      if(radius < 0)
      {
        for each (var pt:Point in arc)
        {
          pt.x = -pt.x;
          pt.y = -pt.y;
        }
      }
      if(angleBetweenSegments < 0)
      {
        for each (pt in arc)
        {
          pt.y = -pt.y;
        }
      }
      return arc;
    }

    // получение координат каждой точки размера
    private function get firstArrowPoints():Array
    {
      var retArray = new Array();
      var p:Point;
      var angle:Number;

      if(isArrowsBetweenBars)
      {
        angle = Math.PI/2 + correctionAngle;
      }
      else
      {
        angle = -Math.PI/2 - correctionAngle;
      }

      for(var i = 0; i<=4; i++)
      {
        p = new Point(a_x[i], a_y[i]);
        p = CoordinateTransformation.rotate(p, angle);
        p.x = p.x + Math.abs(radius);
        retArray.push(p);
      }
      if(radius < 0)
      {
        for each (var pt:Point in retArray)
        {
          pt.x = -pt.x;
          pt.y = -pt.y;
        }
      }
      if(angleBetweenSegments < 0)
      {
        for each (pt in retArray)
        {
          pt.y = -pt.y;
        }
      }
      return retArray;
    }

    private function get secondArrowPoints():Array
    {
      var retArray = new Array();
      var p:Point;
      var angle:Number;

      if(isArrowsBetweenBars)
      {
        angle = -Math.PI/2 - correctionAngle;
      }
      else
      {
        angle = Math.PI/2 + correctionAngle;
      }

      for(var i = 0; i<=4; i++)
      {
        p = new Point(a_x[i], a_y[i]);
        p = CoordinateTransformation.rotate(p, angle);
        p.x = p.x + Math.abs(radius);
        p = CoordinateTransformation.rotate(p, Math.abs(this.angleBetweenSegments));
        retArray.push(p);
      }
      if(radius < 0)
      {
        for each (var pt:Point in retArray)
        {
          pt.x = -pt.x;
          pt.y = -pt.y;
        }
      }
      if(angleBetweenSegments < 0)
      {
        for each (pt in retArray)
        {
          pt.y = -pt.y;
        }
      }
      return retArray;
    }

    private function getRadius(localCoordSystemPosition:Point, localCoordSystemAngle:Number, cursorPosition:Point):Number
    {
      var r:Number;
      var x:Number;
      r = Point.distance(localCoordSystemPosition, cursorPosition);
      x = CoordinateTransformation.screenToLocal(cursorPosition, localCoordSystemPosition, localCoordSystemAngle).x;

      if(x<0)
        r = -r;

      if(Math.abs(r) < MIN_RADIUS)
      {
        if(r >= 0){
          r = MIN_RADIUS;
        }
        else
        {
          r = -MIN_RADIUS;
        }
      }
      return r;
    }

    private function get correctionAngle():Number
    {
      var d:Number = a_x[2];
      var r:Number = Math.abs(radius);
      var alpha:Number = 2*Math.asin(d/(2*r));
      var beta:Number = Math.acos( r * Math.sin(alpha)/d);

      return beta;
    }

    private function get isArrowsBetweenBars():Boolean
    {
      var d:Number = a_x[1];
      var r:Number = Math.abs(radius);
      var teta:Number = 2*Math.asin(d/(2*r));

      if(2*teta < Math.abs(angleBetweenSegments))
      {
        return true;
      }
      else
      {
        return false;
      }
    }

    private function get correctionArcAngle():Number
    {
      var d:Number = a_x[2];
      var r:Number = Math.abs(radius);
      var alpha:Number = 2*Math.asin(d/(2*r));

      return alpha;
    }

    public function get radius():Number
    {
      return radius1;
    }
  }
}