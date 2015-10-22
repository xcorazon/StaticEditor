package  pr1.Shapes
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.panels.MomentPanel;
  import pr1.Shapes.TriangularArrowsArray;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindowQ;
  import pr1.windows.EditWindow;
  import pr1.forces.DistributedForceT;
  import pr1.Snap;

  public class DistributedForceTCreator extends Sprite
  {
    // события в объекте
    public static const CREATE_CANCEL:String = "Cancel creation of distributed force";
    public static const CREATE_DONE:String = "Done creation of distributed force";
    // константы для внутреннего использования
    private static const SELECT_SEGMENT:int = 0;
    private static const SELECT_POSITION:int = 1;
    private static const SELECT_LENGTH_HEIGHT:int = 2;

    private var parent1:*;
    private var segments:Array;
    private var forceNumber1:int;
    private var forceNumber2:int;
    private var highlightedSegment:Segment;
    private var snap:Snap;

    // выходные данные
    private var arrows:TriangularArrowsArray;
    private var arrowsHeight:Number;
    private var arrowsLength:Number;
    private var arrowsCoordinate1:Point;  // координаты стрелок на экране
    private var arrowsCoordinate2:Point;  // координаты стрелок на экране
    private var forceName:String;
    private var forceValue:String;
    private var dimension:String;
    private var angleValue:String;

    private var button_up:TriangularArrowsArray;
    private var button_over:TriangularArrowsArray;
    private var button_down:TriangularArrowsArray;
    private var button_hit:TriangularArrowsArray;
    //cам элемент нагрузки в полном виде
    private var distributedForceT:DistributedForceT = null;

    private var dialogWnd:EditWindowQ;

    private var doNow:int;

    public function DistributedForceTCreator(parent:*, segments:Array, lastNonusedForceNumber:int)
    {
      // constructor code
      this.parent1 = parent;
      this.segments = segments;
      this.doNow = SELECT_SEGMENT;
      this.highlightedSegment = null;
      this.forceNumber1 = lastNonusedForceNumber;
      this.forceNumber2 = lastNonusedForceNumber + 1;

      this.snap = parent1.snap;
      parent1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }

    private function onMouseMove(e:MouseEvent)
    {
      switch(doNow)
      {
        case SELECT_SEGMENT:
          doHighlightSegment(e);
          break;
        case SELECT_POSITION:
          doMoveArrow(e);
          break;
        case SELECT_LENGTH_HEIGHT:
          doMoveSecondPoint(e);
      }
    }

    private function doHighlightSegment(e)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var thres:Number = 8;
      var tempSegment:Segment = null;
      var tempThres:Number;

      for each (var seg in this.segments)
      {
        tempThres = snap.distance(cursorPosition, seg);
        if( tempThres <= thres)
        {
          tempSegment = seg;
          thres = tempThres;
        }
      }

      if(highlightedSegment != null)
      {
        if(tempSegment == null)
        {
          highlightedSegment.setColor(0x0);
          highlightedSegment = null;
          return;
        }
        else
        {
          highlightedSegment.setColor(0x0);
          highlightedSegment = tempSegment;
          highlightedSegment.setColor(0xff);
          return;
        }
      }
      else
      {
        if(tempSegment != null)
        {
          highlightedSegment = tempSegment;
          highlightedSegment.setColor(0xff);
          return;
        }
      }
    }

    private function doMoveArrow(e:MouseEvent)
    {
      var p:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
      p = snap.doSnapToForce(p, highlightedSegment);
      this.arrows.x = p.x;
      this.arrows.y = p.y;
      arrowsCoordinate1 = p;
    }

    private function doMoveSecondPoint(e:MouseEvent)
    {
      var length:Number;
      var height:Number;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var localCoordSysPosition:Point = arrowsCoordinate1;
      var positionOfsecondPointOnSegment:Point;
      var p:Point;
      var angle:Number;
      parent1.removeChild(arrows);

      //находим высоту
      p = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
      angle = CoordinateTransformation.decartToPolar(p).y;
      p = CoordinateTransformation.screenToLocal(cursorPosition,localCoordSysPosition, angle);
      height = p.y;

      //находим длину
      p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
      p = snap.doSnapToForce(p, highlightedSegment);
      this.arrowsCoordinate2 = p;
      p = CoordinateTransformation.screenToLocal(p,localCoordSysPosition, angle);
      length = p.x;

      this.arrowsHeight = height;
      this.arrowsLength = length;
      if(height >= 0)
      {
        this.angleValue = "-90";
      }
      else
      {
        this.angleValue = "90";
      }
      trace(height);

      arrows = new TriangularArrowsArray(length, height, angle, 0);
      button_over = new TriangularArrowsArray(length, height, angle, 0xff);
      button_up = new TriangularArrowsArray(length, height, angle, 0);
      button_down = button_up;
      button_hit = button_up;

      arrows.x = arrowsCoordinate1.x;
      arrows.y = arrowsCoordinate1.y;
      parent1.addChild(arrows);
    }

    private function onMouseDown(e:MouseEvent)
    {
      switch(doNow)
      {
        case SELECT_SEGMENT:
          doSelectSegment(e);
          break;
        case SELECT_POSITION:
          doSelectPosition();
          break;
        case SELECT_LENGTH_HEIGHT:
          doSelectSecondPointPosition(e);
      }
    }

    private function doSelectSegment(e:MouseEvent)
    {
      var angle:Number;
      var p:Point;
      var positionOfArrow:Point;
      if( this.highlightedSegment != null)
      {
        p = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
        angle = CoordinateTransformation.decartToPolar(p).y;
        doNow = SELECT_POSITION;
        highlightedSegment.setColor(0x0);
        positionOfArrow = snap.doSnapToSegment( new Point(e.stageX, e.stageY), highlightedSegment);
        arrows = new TriangularArrowsArray(10,20,angle,0);
        parent1.addChild(arrows);
        arrows.x = positionOfArrow.x;
        arrows.y = positionOfArrow.y;
        arrowsCoordinate1 = positionOfArrow;
      }
    }

    private function doSelectPosition()
    {
      doNow = SELECT_LENGTH_HEIGHT;
    }

    private function doSelectSecondPointPosition(e:MouseEvent)
    {
      if(arrowsCoordinate2.equals(arrowsCoordinate1))
        return;

      // убираем всех прослушивателей событий
      parent1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

      dialogWnd = new EditWindowQ("","");
      parent1.addChild(dialogWnd);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.addEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.addEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);
    }

    private function onEndEditInDialogWindow(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

      parent1.removeChild(dialogWnd);
      parent1.removeChild(arrows);

      forceName = dialogWnd.force;
      forceValue = dialogWnd.value;
      dimension = dialogWnd.dimension;
      dialogWnd = null;
      doCreateDistributedForce();
      dispatchEvent(new Event(DistributedForceTCreator.CREATE_DONE));
    }

    private function doCreateDistributedForce()
    {
      var p:Point;
      var angle:Number;
      distributedForceT = new DistributedForceT(parent1,button_up, button_over, button_down, button_hit,
                      forceName);
      distributedForceT.dimension = dimension;
      distributedForceT.segment = highlightedSegment;
      distributedForceT.forceValue = forceValue;
      distributedForceT.firstScreenCoord = arrowsCoordinate1;
      distributedForceT.secondScreenCoord = arrowsCoordinate2;
      distributedForceT.forceNumber1 = this.forceNumber1;
      distributedForceT.forceNumber2 = this.forceNumber2;
      distributedForceT.angleValue = this.angleValue;

      p = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
      angle = CoordinateTransformation.decartToPolar(p).y;
      p = new Point(arrowsLength, arrowsHeight);
      p = CoordinateTransformation.rotate(p, angle);

      p.y = -p.y;  // преобразуем из дкартовой системы координат в оконную
      distributedForceT.setCoordOfForceName(p);
      distributedForceT.x = arrowsCoordinate1.x;
      distributedForceT.y = arrowsCoordinate1.y;
    }

    private function onCancelEditInDialogWindow(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

      parent1.removeChild(dialogWnd);
      parent1.removeChild(arrows);

      dialogWnd = null;
      dispatchEvent(new Event(DistributedForceTCreator.CREATE_CANCEL));
    }

    public function get result():DistributedForceT
    {
      return distributedForceT;
    }
  }
}
