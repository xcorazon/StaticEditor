package  pr1.Shapes
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.Shapes.Arrow;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindowSealing;
  import pr1.windows.EditWindow;
  import pr1.forces.ConcentratedForce;
  import pr1.Snap;
  import pr1.opora.SealingContainer;

  public class SealingCreator extends Sprite
  {
    // события в объекте
    public static const CREATE_CANCEL:String = "Cancel creation of sealing";
    public static const CREATE_DONE:String = "Done creation of sealing";
    // константы для внутреннего использования
    private static const SELECT_POINT:int = 0;

    private var parent1:*;
    private var selectedSegment:Segment;
    private var segments:Array;
    private var snapPoints:Array;
    private var secondSnapPoint:Point = null;
    private var snap:Snap;
    private var sealing:Sealing;

    // выходные данные
    private var angleOfSealing:Number;
    private var sealingPosition:Point;
    private var horisontalReaction:String;
    private var verticalReaction:String;
    private var moment:String;

    //cам элемент защемления в полном виде
    private var sealingContainer:SealingContainer = null;


    private var dialogWnd:EditWindowSealing;

    private var doNow:int;

    public function SealingCreator(parent, segments:Array)
    {
      this.parent1 = parent;
      this.segments = segments;
      this.doNow = SELECT_POINT;

      snapPoints = new Array();
      getSnapPoints();
      sealing = new Sealing();
      parent1.addChild(sealing);

      this.snap = parent1.snap;
      parent1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }

    private function getSnapPoints()
    {
      var seg1:Segment;
      var seg2:Segment;
      var p1:Point;
      var p2:Point = null;

      if(segments.length == 1)
      {
        snapPoints.push(segments[0].firstScreenCoord);
        snapPoints.push(segments[0].secondScreenCoord);
        return;
      }
      // ищем несовпадающие точки
      // именно к ним и будет производиться привязка

      for each (seg1 in segments)
      {
        p1 = seg1.firstScreenCoord;
        var copyPresent:Boolean = false;
        for each (seg2 in segments)
        {
          if(seg1 != seg2)
          {
            if(p1.equals(seg2.firstScreenCoord))
            {
              copyPresent = true;
              break;
            }
            if(p1.equals(seg2.secondScreenCoord))
            {
              copyPresent = true;
              break;
            }
          }
        }
        if(!copyPresent) snapPoints.push(p1);

        p2 = seg1.secondScreenCoord;
        copyPresent = false;
        for each (seg2 in segments)
        {
          if(seg1 != seg2){
            if(p2.equals(seg2.firstScreenCoord))
            {
              copyPresent = true;
              break;
            }
            if(p2.equals(seg2.secondScreenCoord))
            {
              copyPresent = true;
              break;
            }
          }
        }
        if(!copyPresent) snapPoints.push(p2);
      }
    }

    private function onMouseMove(e:MouseEvent)
    {
      doMoveSealing(e);
    }

    private function doMoveSealing(e)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var thres:Number = 8;
      var angle:Number;
      for each (var p1:Point in snapPoints){
        if(Point.distance(cursorPosition, p1) <= thres)
        {
          angle = getAngle(p1);
          sealing.rotation = angle;
          angleOfSealing = angle;
          sealing.x = p1.x;
          sealing.y = p1.y;
          break;
        }
        else
        {
          sealing.rotation = 0;
          angleOfSealing = 0;
          sealing.x = cursorPosition.x;
          sealing.y = cursorPosition.y;
        }
      }
    }

    private function onMouseDown(e:MouseEvent)
    {
      doSelectPosition(e);
    }


    private function doSelectPosition(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var thres:Number = 8;
      var angle:Number;
      for each (var p1:Point in snapPoints)
      {
        if(Point.distance(cursorPosition, p1) <= thres)
        {
          angle = getAngle(p1);
          sealing.rotation = angle;
          angleOfSealing = angle;
          sealing.x = p1.x;
          sealing.y = p1.y;
          sealingPosition = p1;
          this.selectedSegment = getSegment(p1);
          // убираем всех прослушивателей событий
          parent1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
          parent1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

          dialogWnd = new EditWindowSealing("","","");
          parent1.addChild(dialogWnd);
          dialogWnd.x = 400;
          dialogWnd.y = 300;
          dialogWnd.addEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
          dialogWnd.addEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);
          break;
        }
        else
        {
          sealing.rotation = 0;
          angleOfSealing = 0;
          sealing.x = cursorPosition.x;
          sealing.y = cursorPosition.y;
        }
      }
    }

    private function onEndEditInDialogWindow(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

      parent1.removeChild(dialogWnd);
      parent1.removeChild(sealing);

      horisontalReaction = dialogWnd.horizontalReaction;
      verticalReaction = dialogWnd.verticalReaction;
      moment = dialogWnd.moment;

      dialogWnd = null;
      doCreateSealing();
      dispatchEvent(new Event(SealingCreator.CREATE_DONE));
    }

    private function doCreateSealing()
    {
      var p:Point;
      var angle:Number;
      sealingContainer = new SealingContainer(parent1, this.angleOfSealing);
      sealingContainer.x = this.sealingPosition.x;
      sealingContainer.y = this.sealingPosition.y;
      sealingContainer.horisontalReaction = horisontalReaction;
      sealingContainer.verticalReaction = verticalReaction;
      sealingContainer.moment = moment;
      sealingContainer.segment = selectedSegment;
      sealingContainer.pointNumber = getPointNumber(sealingPosition);
      sealingContainer.setCoordOfSignatures();

    }

    private function getAngle(pointOnSegment:Point):Number
    {
      var seg:Segment;
      var p:Point;
      var angle:Number;
      for each (seg in segments)
      {
        if(pointOnSegment.equals(seg.firstScreenCoord))
        {
          p = seg.secondDecartCoord.subtract(seg.firstDecartCoord);
          break;
        }
        if(pointOnSegment.equals(seg.secondScreenCoord))
        {
          p = seg.firstDecartCoord.subtract(seg.secondDecartCoord);
          break;
        }
      }
      angle = CoordinateTransformation.decartToPolar(p).y;
      angle = angle * 180/Math.PI;
      return -angle;
    }

    private function getSegment(pointOnSegment:Point):Segment
    {
      var seg:Segment;
      for each (seg in segments)
      {
        if(pointOnSegment.equals(seg.firstScreenCoord))
        {
          return seg;
        }
        if(pointOnSegment.equals(seg.secondScreenCoord))
        {
          return seg;
        }
      }
      return null;
    }

    private function getPointNumber(pointOnSegment:Point):int
    {
      var seg:Segment;
      var pointNumber:int = 0;
      for each (seg in segments)
      {
        if(pointOnSegment.equals(seg.firstScreenCoord))
        {
           pointNumber = seg.firstPointNumber;
           break;
        }
        if(pointOnSegment.equals(seg.secondScreenCoord))
        {
           pointNumber = seg.secondPointNumber;
           break;
        }
      }
      return pointNumber;
    }

    private function onCancelEditInDialogWindow(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

      parent1.removeChild(dialogWnd);
      parent1.removeChild(sealing);

      dialogWnd = null;
      dispatchEvent(new Event(SealingCreator.CREATE_CANCEL));
    }

    public function get result():SealingContainer
    {
      return sealingContainer;
    }
  }
}