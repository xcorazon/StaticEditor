package pr1.Shapes
{
  import flash.display.Sprite;
  import flash.display.Shape;
  import flash.events.MouseEvent;
  import flash.events.Event;
  import flash.geom.Point;
  import pr1.CoordinateTransformation;
  import pr1.Shapes.Segment;
  import pr1.Snap;
  import pr1.Frame;


  public class SegmentCreator extends Creator
  {
    private static const SNAP_THRESHOLD:Number = 10;

    private var firstPointNumber:int;
    private var secondPointNumber:int;
    private var lastPointNumber:int;
    private var point1:Point;
    private var point2:Point;
    private var seg:Segment;
    private var segPresent:Boolean = false;

    private var circle:Shape;
    private var circlePresent:Boolean = false;

    public function SegmentCreator(frame:Frame)
    {
      super(frame);
      circle = new Shape();
      circle.graphics.lineStyle(0.5, 0xff);
      circle.graphics.drawCircle(0,0,3);
    }
    
    override public function create()
    {
      super.create();
      firstPointNumber = 6;
      secondPointNumber = 7;
      for each ( var s in segments)
      {
        if (secondPointNumber <= s.firstPointNumber)
        {
          secondPointNumber = s.firstPointNumber + 1;
        }
        if (secondPointNumber <= s.secondPointNumber)
        {
          secondPointNumber = s.secondPointNumber + 1;
        }
      }
      lastPointNumber = secondPointNumber;
      
      this.addEventListener(Creator.CREATE_CANCEL, onCancel);
      
      initEvents();
      initHandlers();
    }

    private function initHandlers()
    {
      moveHandlers[0] = moveFirstPoint;
      moveHandlers[1] = moveSecondPoint;

      downHandlers[0] = setFirstPoint;
      downHandlers[1] = setSecondPoint;
    }

    private function moveFirstPoint(e:MouseEvent)
    {
      var p:Point = new Point(e.stageX, e.stageY);
      // делаем привязку к уже существующим отрезкам
      if (segments.length != 0)
      {
        for each ( var s in segments)
        {
          if (Point.distance(p, s.firstScreenCoord) <= SNAP_THRESHOLD)
          {
            p = s.firstScreenCoord;
            break;
          }
          if (Point.distance(p, s.secondScreenCoord) <= SNAP_THRESHOLD)
          {
            p = s.secondScreenCoord;
            break;
          }
        }
        // обозначим привязку на экране
        if(p.x != e.stageX || p.y != e.stageY)
        {
          circle.x = p.x;
          circle.y = p.y;
          if(!circlePresent)
          {
            this.parent1.addChild(circle);
            circlePresent = true;
          }
        }
        else if(circlePresent)
        {
          circlePresent = false;
          this.parent1.removeChild(circle);
        }
      }
    }

    private function moveSecondPoint(e:MouseEvent)
    {
      var p:Point = new Point(e.stageX, e.stageY);

      // делаем привязку к уже существующим отрезкам
      if (segments.length != 0)
      {
        for each ( var s in segments)
        {
          if (Point.distance(p, s.firstScreenCoord) <= SNAP_THRESHOLD && firstPointNumber != s.firstPointNumber)
          {
            p = s.firstScreenCoord;
            secondPointNumber = s.firstPointNumber;
            break;
          }
          if (Point.distance(p, s.secondScreenCoord) <= SNAP_THRESHOLD && firstPointNumber != s.secondPointNumber)
          {
            p = s.secondScreenCoord;
            secondPointNumber = s.firstPointNumber;
            break;
          }
          secondPointNumber = lastPointNumber;
        }
        // обозначим привязку на экране
        if(p.x != e.stageX || p.y != e.stageY)
        {
          circle.x = p.x;
          circle.y = p.y;
          if(!circlePresent)
          {
            parent1.addChild(circle);
            circlePresent = true;
          }
        }
        else if(circlePresent)
        {
          circlePresent = false;
          parent1.removeChild(circle);
        }
      }
      if( !circlePresent)
      {
        // выполняем привязку по осям координат
        if(Math.abs(point1.x - p.x) <= SNAP_THRESHOLD)
        {
          p.x = point1.x;
        }
        if(Math.abs(point1.y - p.y) <= SNAP_THRESHOLD)
        {
          p.y = point1.y;
        }
      }
      // делаем привязку по вертикали и горизонтали
      p = snap.alignX(p);
      p = snap.alignY(p);

      if(segPresent)
      {
        parent1.removeChild(seg);
        seg = new Segment(firstPointNumber, secondPointNumber, point1, p);
        this.parent1.addChild(seg);
      }
      else
      {
        seg = new Segment(firstPointNumber, secondPointNumber, point1, p);
        parent1.addChild(seg);
        segPresent = true;
      }
    }

    private function setFirstPoint(e:MouseEvent)
    {
      var p:Point = new Point(e.stageX, e.stageY);
      // делаем привязку к уже существующим отрезкам
      if (segments.length != 0)
      {
        for each ( var s in segments)
        {
          if (Point.distance(p, s.firstScreenCoord) <= SNAP_THRESHOLD)
          {
            p = s.firstScreenCoord;
            firstPointNumber = s.firstPointNumber
            break;
          }
          if (Point.distance(p, s.secondScreenCoord) <= SNAP_THRESHOLD)
          {
            p = s.secondScreenCoord;
            firstPointNumber = s.secondPointNumber;
            break;
          }
        }
        if(p.x == e.stageX && p.y == e.stageY)
        {
          return;
        }
      }
      this.point1 = p;
      if(circlePresent)
      {
        parent1.removeChild(circle);
        circlePresent = false;
      }
      nextHandlers();
    }

    private function setSecondPoint(e:MouseEvent)
    {
      if(segPresent)
      {
        parent1.removeChild(seg);
        segPresent = false;
      }
      if(circlePresent)
      {
        parent1.removeChild(circle);
      }
      this.removeEventListener(Creator.CREATE_CANCEL, onCancel);
      releaseEvents();
      dispatchEvent( new Event(Creator.CREATE_DONE));
    }

    private function onCancel(e:Event)
    {
      this.removeEventListener(Creator.CREATE_CANCEL, onCancel);
      releaseEvents();
      if(segPresent)
      {
        this.parent1.removeChild(seg);
        segPresent = false;
        seg = null;
      }
      if(circlePresent)
      {
        this.parent1.removeChild(circle);
        circlePresent = false;
        circle = null;
      }
    }

    override public function get result():*
    {
      return seg;
    }
  }
}