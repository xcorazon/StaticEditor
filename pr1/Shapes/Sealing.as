package  pr1.Shapes
{
  import flash.display.Shape;
  import flash.geom.Point;

  public class Sealing extends Shape
  {

    private var angle_s:Number = -45; // угол штриховки
    private var step:Number = 4;    // шаг штриховки
    private var color:uint;

    public function Sealing(color:uint = 0x0)
    {
      // constructor code

      const HEIGHT_OP = 80;

      this.color = color;
      fillShtrih( new Point(-10, -HEIGHT_OP/2),
              new Point(-10, HEIGHT_OP/2),
              new Point(0, HEIGHT_OP/2),
              new Point(0, -HEIGHT_OP/2));
      graphics.lineStyle(2, color, 1);
      graphics.moveTo(0, HEIGHT_OP/2);
      graphics.lineTo(0, -HEIGHT_OP/2);
    }

    // функция для штриховки 4-х угольного контура
    protected function fillShtrih(p1:Point, p2:Point, p3:Point, p4:Point):void
    {

      var x1, a, b:Point;
      var s:Boolean = true;

      var p0:Point = p1.clone();
      // устанавливаем стиль линии
      graphics.lineStyle(1,this.color, 1);

      while(s)
      {
        // начинаем штриховку
        s = false;
        p0.x += this.step;
        p0.y += this.step;


        x1 = crossLines(p1, p2, p0, Math.PI / 180 * this.angle_s);
        if(s = isOnTheLine(p1, p2, x1))
        {
          a = x1;
        }

        x1 = crossLines(p2, p3, p0, Math.PI / 180 * this.angle_s);
        if(isOnTheLine(p2, p3, x1))
        {
          if(s)
            b = x1;
          else
          {
            a = x1;
            s = true;
          }
        }

        x1 = crossLines(p3, p4, p0, Math.PI / 180 * this.angle_s);
        if(isOnTheLine(p3, p4, x1))
        {
          if(s)
            b = x1;
          else
          {
            a = x1;
            s = true;
          }
        }

        x1 = crossLines(p4, p1, p0, Math.PI / 180 * this.angle_s);
        if(isOnTheLine(p4, p1, x1))
        {
          if(s)
            b = x1;
          else
          {
            a = x1;
            s = true;
          }
        }

        if(s)
        {
          // если координаты получены, - добавляем линию
          graphics.moveTo(a.x, a.y);
          graphics.lineTo(b.x, b.y);
        }
      }
    }

    private function crossLines(p1:Point, p2:Point, p0:Point, angle):Point
    {
      // функция определяет точку пересечения двух прямых
      var p:Point = new Point();

      var a1 = p2.x - p1.x;
      var b1 = p2.y - p1.y;
      var c1 = p1.x * b1 - p1.y * a1;
      var a0 = Math.tan(angle);
      var b0 = p0.y - p0.x * a0;
      p.x = (c1 + a1 * b0)/(b1 - a1 * a0);
      p.y = a0 * p.x + b0;

      return p;
    }


    private function isOnTheLine(p1:Point, p2:Point, x1:Point):Boolean
    {
      // функция определяет принадлежит ли точка пересечения заданному отрезку
      // подразумевается что точка лежит на прямой, которая содержит в себе заданный отрезок
      var temp1:Point;
      var temp2:Point;
      var dotProduct:Number;

      temp1 = p1.subtract(x1);
      temp2 = p2.subtract(x1);

      dotProduct = temp1.x * temp2.x + temp1.y * temp2.y;

      return (dotProduct <=0);
    }
  }
}
