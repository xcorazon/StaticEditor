package  pr1.Shapes
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.panels.ConcentratedForcePanel;
  import pr1.Shapes.Arrow;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindow3;
  import pr1.windows.EditWindow;
  import pr1.forces.ConcentratedForce;
  import pr1.Snap;

  public class ConcentratedForceCreator extends Sprite
  {
    // события в объекте
    public static const CREATE_CANCEL:String = "Cancel creation of concentrated force";
    public static const CREATE_DONE:String = "Done creation of concentrated force";
    // константы для внутреннего использования
    private static const SELECT_SEGMENT:int = 0;
    private static const SELECT_POSITION:int = 1;
    private static const SELECT_ANGLE:int = 2;

    private var parent1:*;
    private var segments:Array;
    private var forceNumber:int;
    private var highlightedSegment:Segment;
    private var panel:ConcentratedForcePanel;
    private var snap:Snap;


    private var isTail:Boolean;
    // выходные данные
    private var anglePoints:Array;
    private var arrow:Arrow;
    private var arrowAngle:Number;
    private var arrowCoordinates:Point;   // координаты стрелки на экране
    private var forceName:String;
    private var forceValue:String;
    private var angleName:String;
    private var angleValue:String;
    private var dimension:String;

    private var button_up:Arrow;
    private var button_over:Arrow;
    private var button_down:Arrow;
    private var button_hit:Arrow;
    //cам элемент нагрузки в полном виде
    private var force:ConcentratedForce = null;


    private var dialogWnd:EditWindow3;

    private var doNow:int;

    public function ConcentratedForceCreator(parent, segments:Array, lastNonusedForceNumber:int)
    {
      this.parent1 = parent;
      this.segments = segments;
      this.doNow = SELECT_SEGMENT;
      this.highlightedSegment = null;
      this.forceNumber = lastNonusedForceNumber;

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
        case SELECT_ANGLE:
          doRotateArrow(e);
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
      this.arrow.x = p.x;
      this.arrow.y = p.y;
      arrowCoordinates = p;
    }

    private function doRotateArrow(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      parent1.removeChild(arrow);
      arrow = new Arrow(arrowCoordinates, panel.angleOfAxis, cursorPosition, isTail, 0);
      button_over = new Arrow(arrowCoordinates, panel.angleOfAxis, cursorPosition, isTail, 0xff);
      button_up = new Arrow(arrowCoordinates, panel.angleOfAxis, cursorPosition, isTail, 0);;
      button_down = button_up;
      button_hit = button_up;

      arrow.x = arrowCoordinates.x;
      arrow.y = arrowCoordinates.y;
      parent1.addChild(arrow);
    }

    private function onChangePanel(e:Event)
    {
      if( panel.pointsOfAngle[2] == ComConst.FORCE_FROM)
        this.isTail = false;
      else
        this.isTail = true;
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
        case SELECT_ANGLE:
          doSelectAngle();
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
        arrow = new Arrow(positionOfArrow, angle, new Point(e.stageX, e.stageY), false, 0);
        parent1.addChild(arrow);
        arrow.x = positionOfArrow.x;
        arrow.y = positionOfArrow.y;
        arrowCoordinates = positionOfArrow;
      }
    }

    private function doSelectPosition()
    {
      panel = new ConcentratedForcePanel();
      panel.x = 800 - 245;
      doNow = SELECT_ANGLE;
      panel.setSegmentPoints(highlightedSegment.firstPointNumber,
                   highlightedSegment.firstDecartCoord,
                   highlightedSegment.secondPointNumber,
                   highlightedSegment.secondDecartCoord);
      panel.addEventListener(ConcentratedForcePanel.CHANGE_STATE, onChangePanel);
      parent1.addChild(panel);
    }

    private function doSelectAngle()
    {
      // убираем всех прослушивателей событий
      panel.removeEventListener(ConcentratedForcePanel.CHANGE_STATE, onChangePanel);
      parent1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      anglePoints = panel.pointsOfAngle;
      panel.destroy();
      parent1.removeChild(panel);

      anglePoints[1] = this.forceNumber;
      arrowAngle = arrow.angleOfTipOrTail;

      var angleValue:String = "";
      if(Math.abs(this.arrowAngle) == Math.PI/2)
      {
        angleValue = "90";
      }
      else if(Math.abs(this.arrowAngle) == Math.PI)
      {
        angleValue = "180";
      }
      else if(Math.abs(this.arrowAngle) == 0)
      {
        angleValue = "0";
      }
      dialogWnd = new EditWindow3("","","",angleValue);
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
      parent1.removeChild(arrow);

      forceName = dialogWnd.force;
      forceValue = dialogWnd.value;
      angleName = dialogWnd.angleName;
      angleValue = dialogWnd.angle;
      dimension = dialogWnd.dimension;
      dialogWnd = null;
      doCreateConcentratedForce();
      dispatchEvent(new Event(ConcentratedForceCreator.CREATE_DONE));
    }

    private function doCreateConcentratedForce()
    {
      var p:Point;
      var angle:Number;
      force = new ConcentratedForce(parent1, button_up, button_over, button_down, button_hit, forceName, angleName);

      force.dimension = dimension;
      force.segment = highlightedSegment;
      force.forceNumber = forceNumber;
      force.angleValue = angleValue;
      force.forceValue = forceValue;
      force.angleSign = arrow.angleSign;
      force.anglePoints = this.anglePoints;

      angle = panel.angleOfAxis;
      angle += arrowAngle;
      p = Point.polar(70, angle);
      p.y = -p.y;  // преобразуем из дкартовой системы координат в оконную
      force.setCoordOfForceName(p);
      angle = angle - arrowAngle/2;
      p = Point.polar(30, angle);
      p.y = -p.y; // преобразуем из дкартовой системы координат в оконную
      force.setCoordOfAngleName(p);
      force.x = arrowCoordinates.x;
      force.y = arrowCoordinates.y;
    }

    private function onCancelEditInDialogWindow(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

      parent1.removeChild(dialogWnd);
      parent1.removeChild(arrow);

      dialogWnd = null;
      dispatchEvent(new Event(ConcentratedForceCreator.CREATE_CANCEL));
    }

    public function get result():ConcentratedForce
    {
      return force;
    }
  }
}