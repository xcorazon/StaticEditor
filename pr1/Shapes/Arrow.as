package pr1.Shapes
{
  import pr1.CoordinateTransformation;
  import flash.display.Shape;
  import flash.display.JointStyle;
  import flash.geom.Point;

  public class Arrow extends Shape
  {

    private static var arrowXCoord:Array = [3, 20, 15, 20, 3, 10, 70];
    private static var arrowYCoord:Array = [0,  4,  0, -4, 0,  0,  0];
    private var localPositionOfTipOrTail:Point;

    public function Arrow(localCoordSystemPosition:Point,
                localCoordSystemAngle:Number,
                globalPositionOfArrowTipOrTail:Point,
                isTail:Boolean = true,
                color:uint = 0x0)
    {

      localPositionOfTipOrTail = CoordinateTransformation.screenToLocal(globalPositionOfArrowTipOrTail,
                                        localCoordSystemPosition,
                                        localCoordSystemAngle);
      // выполнение привязки по перпендикулярным направлениям
      if ( Math.abs(localPositionOfTipOrTail.x) <= 10)
        localPositionOfTipOrTail.x = 0;
      else
      {
        if ( Math.abs(localPositionOfTipOrTail.y) <= 10)
          localPositionOfTipOrTail.y = 0;
      }

      drawArrow(localCoordSystemAngle, isTail, color);
      // если одно из ортогональных направлений, то не отрисовываем дугу и полку
      if (localPositionOfTipOrTail.x != 0 && localPositionOfTipOrTail.y != 0)
      {
        drawArc(localCoordSystemAngle, color);
        drawAngleSide(localCoordSystemAngle, color);
      }

    }

    private function drawArrow(localCoordSystemAngle:Number, isTail:Boolean, color:uint)
    {
      var points:Array;
      var localCoordSystemPosition:Point = new Point(0,0);
      if (isTail)
      {
        points = getArrowTailPointsCoordinates(localPositionOfTipOrTail);
      }
      else
      {
        points = getArrowTipPointsCoordinates(localPositionOfTipOrTail);
      }
      this.graphics.lineStyle(1.45, color,1.0,false,"normal",null,JointStyle.MITER);
      this.graphics.beginFill(color);
        for ( var i in points)
        {
          points[i] = CoordinateTransformation.localToScreen(points[i], localCoordSystemPosition, localCoordSystemAngle);
          if (i == 0 || i == 5)
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

    private function drawArc(localCoordSystemAngle:Number, color:uint)
    {
      var points:Array;
      var localCoordSystemPosition:Point = new Point(0,0);
      points = getArcCoordinates(localPositionOfTipOrTail);
      this.graphics.lineStyle(1, color);
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

    private function drawAngleSide(localCoordSystemAngle:Number, color:uint)
    {
      var localCoordSystemPosition:Point = new Point(0,0);
      var firstPoint:Point = new Point(0,0);
      var secondPoint:Point = new Point(45,0);
      this.graphics.lineStyle(1, color);
      firstPoint = CoordinateTransformation.localToScreen(firstPoint, localCoordSystemPosition, localCoordSystemAngle);
      this.graphics.moveTo(firstPoint.x, firstPoint.y);
      secondPoint = CoordinateTransformation.localToScreen(secondPoint, localCoordSystemPosition, localCoordSystemAngle);
      this.graphics.lineTo(secondPoint.x, secondPoint.y);
    }

    // получаем координаты точек дуги между стрелкой и осью ох
    private function getArcCoordinates(arrowTailCoord:Point):Array
    {
      var step:Number;
      var arc:Array = new Array();
      var R = 30; // радиус дуги
      var p:Point = new Point(R, 0);
      var i:int;
      var angle:Number = CoordinateTransformation.decartToPolar(arrowTailCoord).y;
      if (angle > 0)
      {
        step = 5 * Math.PI / 180;
      }
      else
      {
        step = -5 * Math.PI / 180;
      }
      var lastPoint = CoordinateTransformation.rotate(p,angle);
      var currentAngle = 0;
      while (Math.abs(currentAngle) < Math.abs(angle))
      {
        arc.push(p);
        p = CoordinateTransformation.rotate(p, step);
        currentAngle += step;
      }
      arc.push(lastPoint);

      return arc;
    }

    // функция получения координат стрелки по координате её кончика
    // координата хвоста стрелки равна (0,0)
    // система координат - декартовая
    private function getArrowTipPointsCoordinates(arrowTipCoord:Point):Array
    {
      // arrowTip - кончик стрелки
      var angle:Number;
      var retArray:Array;
      var p:Point = new Point(0,0);
      var x:Number, y:Number;

      retArray = new Array();
      angle = CoordinateTransformation.decartToPolar(arrowTipCoord).y;

      //преобразовываем координаты каждой точки стрелки
      for( var i = 0; i <= 6; i++)
      {
        // отображаем стрелку симметрично относительно оси х и сдвигаем вправо на её длину
        x = -arrowXCoord[i] + 70; // 60 - длина стрелки
        y = arrowYCoord[i];
        p = CoordinateTransformation.rotate( new Point(x, y), angle);
        retArray.push(p);
      }

      return retArray;
    }
    // функция получения координат стрелки по координате её хвоста
    // координата конца стрелки равна (0,0)
    // система координат - декартовая
    private function getArrowTailPointsCoordinates(arrowTailCoord:Point):Array
    {
      // arrowTail - хвост стрелки

      var angle:Number;
      var retArray:Array;
      var p:Point = new Point(0,0);

      retArray = new Array();
      angle = CoordinateTransformation.decartToPolar(arrowTailCoord).y;

      //преобразовываем координаты каждой точки стрелки
      for( var i = 0; i <= 6; i++)
      {
        p = CoordinateTransformation.rotate( new Point(arrowXCoord[i], arrowYCoord[i]), angle);
        retArray.push(p);
      }

      return retArray;
    }

    public function get angleSign():int
    {
      var angle = this.angleOfTipOrTail;
      if (angle >=0)
      {
        return 1;
      }
      else
      {
        return -1;
      }
    }

    public function get angleOfTipOrTail():Number
    {
      return CoordinateTransformation.decartToPolar(localPositionOfTipOrTail).y;
    }

  }
}