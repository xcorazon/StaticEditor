package pr1.Shapes
{
  import pr1.CoordinateTransformation;
  import flash.display.*;
  import flash.display.JointStyle;
  import flash.geom.Point;

  public class ArcArrow extends Shape
  {

    private static const RADIUS:Number = 40;  // радиус дуги

    private static var tipCoordsX:Array = [0, -20, -15, -20, 0];
    private static var tipCoordsY:Array = [0,   4,   0,  -4, 0];
    private var localPositionOfTip:Point;

    public function ArcArrow(localCoordSystemPosition:Point,
                   globalPositionOfArrowTip:Point = null,
                   isClockwise:Boolean = false,
                   color:uint = 0x0)
    {
      localPositionOfTip = CoordinateTransformation.screenToLocal(globalPositionOfArrowTip, localCoordSystemPosition, /*angle=0*/0);
      drawArrowTip(localPositionOfTip, isClockwise, color);
      drawArc(localPositionOfTip, isClockwise, color);
    }


    // функция отрисовки стрелки
    private function drawArrowTip(localTipPosition:Point, isClockwise:Boolean, color:uint)
    {
      var points:Array;
      var localCoordSystemPosition:Point = new Point(0,0);
      points = getTipTransformedPoints(localTipPosition, isClockwise);
      this.graphics.lineStyle(1, color, 1.0, false, "normal",null,JointStyle.MITER);
      this.graphics.beginFill(color);
      for (var i in points)
      {
        points[i] = CoordinateTransformation.localToScreen(points[i], localCoordSystemPosition, 0);
        if(i == 0)
        {
          this.graphics.moveTo(points[i].x, points[i].y);
        }
        else
        {
          this.graphics.lineTo(points[i].x, points[i].y);
        }
      }
      this.graphics.endFill();
    }

    // функция отрисовки дуги
    private function drawArc(localTipPosition:Point, isClockwise:Boolean, color:uint)
    {
      var points:Array;
      var localCoordSystemPosition:Point = new Point(0,0);
      points = getArcPoints(localTipPosition, isClockwise);
      this.graphics.lineStyle(1, color, 1.0, false, "normal",null,JointStyle.ROUND);
      for (var i in points)
      {
        points[i] = CoordinateTransformation.localToScreen(points[i], localCoordSystemPosition, 0);
        if(i == 0)
        {
          this.graphics.moveTo(points[i].x, points[i].y);
        }
        else
        {
          this.graphics.lineTo(points[i].x, points[i].y);
        }
      }
    }

    // получаем координаты точек дуги стрелки и отрезка соединяющего дугу с началом координат
    private function getArcPoints(localTipPosition:Point, isClockwise:Boolean):Array
    {
      var tipPosAngle:Number = CoordinateTransformation.decartToPolar(localTipPosition).y;
      var endAngle:Number = (-180-45) * Math.PI/180;
      var startAngle:Number = -5 * Math.PI/180;
      var step:Number = -7 * Math.PI/180;
      var p:Point;
      var arc:Array = new Array();

      if(isClockwise)
      {
        endAngle = -endAngle;
        startAngle = -startAngle;
        step = -step;
      }
      var lastPoint:Point = CoordinateTransformation.rotate(new Point(RADIUS,0), endAngle + tipPosAngle);
      var currentAngle = startAngle;
      while(Math.abs(currentAngle) < Math.abs(endAngle))
      {
        p = CoordinateTransformation.rotate(new Point(RADIUS,0), currentAngle + tipPosAngle);
        arc.push(p);
        currentAngle += step;
      }
      arc.push(lastPoint);
      arc.push(new Point(0,0));
      return arc;
    }

    // функция устанавливает положение кончика стрелки соответственно положению курсора
    // в локальной декартовой системе координат (НЕ ЭКРАННОЙ!!!)
    private function getTipTransformedPoints(localTipPosition:Point, isClockwise:Boolean):Array
    {
      var angle:Number = CoordinateTransformation.decartToPolar(localTipPosition).y;
      var tip_angle:Number = 78/90 * Math.PI/2;
      var point:Point;
      var tipCoords:Array = new Array();

      if (isClockwise)
      {
        tip_angle = -tip_angle;
      }
      // преобразуем координаты
      for( var i = 0; i<=4; i++)
      {
        point = new Point(tipCoordsX[i], tipCoordsY[i]);
        point = CoordinateTransformation.rotate(point,tip_angle);
        point.x += RADIUS;
        point = CoordinateTransformation.rotate(point,angle);
        tipCoords.push(point);
      }
      return tipCoords;
    }

    public function get angleSign():Number
    {
      var angle = this.angleOfTip;
      if (angle >=0)
      {
        return 1;
      }
      else
      {
        return -1;
      }
    }

    public function get angleOfTip():Number
    {
      return CoordinateTransformation.decartToPolar(localPositionOfTip).y;
    }

  }
}