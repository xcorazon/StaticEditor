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


  public class SegmentCreator extends Sprite
  {
    public static const CANCEL:String = "Creation Cancel";
    public static const CREATE_DONE:String = "Creation Done";
    private static const GET_FIRST_POINT:int = 0;
    private static const GET_SECOND_POINT:int = 1;
    private static const SNAP_THRESHOLD:Number = 10;

    private var firstPointNumber:int;
    private var secondPointNumber:int;
    private var lastPointNumber:int;
    private var segments:Array;
    private var point1:Point;
    private var point2:Point;
    private var seg:Segment;
    private var segPresent:Boolean = false;
    private var doNow:int;
    private var spr:*;    // объект которому принадлежит этот объект
    private var circle:Shape;
    private var circlePresent:Boolean = false;
    private var snap:Snap;

    public function SegmentCreator(spr:*, segments:Array)
    {
      // constructor code
      super();
      this.spr = spr;
      this.segments = segments;
      circle = new Shape();
      circle.graphics.lineStyle(0.5, 0xff);
      circle.graphics.drawCircle(0,0,3);
      this.snap = spr.snap;
      this.spr.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      this.spr.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      this.addEventListener(CANCEL, onCancel);
      doNow = GET_FIRST_POINT;
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

    }

    public function get segment():Segment
    {
      return seg;
    }

    private function onMouseMove(e:MouseEvent)
    {
      switch (doNow)
      {
        case GET_FIRST_POINT:
          doMoveFirstPoint(e);
          break;
        case GET_SECOND_POINT:
          doMoveSecondPoint(e);
      }
    }

    private function doMoveFirstPoint(e:MouseEvent)
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
            this.spr.addChild(circle);
            circlePresent = true;
          }
        }
        else if(circlePresent)
        {
          circlePresent = false;
          this.spr.removeChild(circle);
        }
      }
    }

    private function doMoveSecondPoint(e:MouseEvent)
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
            this.spr.addChild(circle);
            circlePresent = true;
          }
        }
        else if(circlePresent)
        {
          circlePresent = false;
          this.spr.removeChild(circle);
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
        this.spr.removeChild(seg);
        seg = new Segment(firstPointNumber, secondPointNumber, point1, p);
        this.spr.addChild(seg);
      }
      else
      {
        seg = new Segment(firstPointNumber, secondPointNumber, point1, p);
        this.spr.addChild(seg);
        segPresent = true;
      }
    }

    private function onMouseDown(e:MouseEvent)
    {
      switch (doNow)
      {
        case GET_FIRST_POINT:
          doDownFirstPoint(e);
          break;
        case GET_SECOND_POINT:
          doDownSecondPoint(e);
      }
    }

    private function doDownFirstPoint(e:MouseEvent)
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
        this.spr.removeChild(circle);
        circlePresent = false;
      }
      doNow = GET_SECOND_POINT;
    }

    private function doDownSecondPoint(e:MouseEvent)
    {
      if(segPresent)
      {
        this.spr.removeChild(seg);
        segPresent = false;
      }
      if(circlePresent)
      {
        this.spr.removeChild(circle);
      }
      spr.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      spr.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      this.removeEventListener(CANCEL, onCancel);
      dispatchEvent( new Event(CREATE_DONE));
    }

    private function onCancel(e:Event)
    {
      spr.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      spr.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      this.removeEventListener(CANCEL, onCancel);

      if(segPresent)
      {
        this.spr.removeChild(seg);
        segPresent = false;
        seg = null;
      }
      if(circlePresent)
      {
        this.spr.removeChild(circle);
        circlePresent = false;
        circle = null;
      }
    }
  }
}