﻿package  pr1.Shapes
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  
  import flash.geom.Point;
  import flash.events.Event;
  
  import pr1.events.DialogEvent;
  
  import pr1.panels.MomentPanel;
  import pr1.Shapes.ArcArrow;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindowMoment;
  import pr1.windows.EditWindow;
  import pr1.forces.Moment;
  import pr1.Snap;
  import pr1.Frame;
  

  public class MomentCreator extends Creator
  {
    // события в объекте
    public static const CREATE_CANCEL:String = "Cancel creation of moment";
    public static const CREATE_DONE:String = "Done creation of moment";

    private var segments:Array;
    private var momentNumber:int;
    private var highlightedSegment:Segment;
    private var panel:MomentPanel;
    private var snap:Snap;

    // выходные данные
    private var arrow:ArcArrow;
    private var arrowAngle:Number;
    private var arrowCoordinates:Point;   // координаты стрелки на экране
    private var isClockWise:Boolean;

    private var button_up:ArcArrow;
    private var button_over:ArcArrow;
    private var button_down:ArcArrow;
    private var button_hit:ArcArrow;
    //cам элемент нагрузки в полном виде
    private var moment:Moment = null;


    public function MomentCreator(frame:Frame)
    {
      super(frame);
      this.segments = frame.Segments;
      this.highlightedSegment = null;
      this.momentNumber = frame.lastNonUsedMoment;
      snap = parent1.snap;

      initHandlers();
      initEvents();
      
    }

    private function initHandlers()
    {
      moveHandlers[0] = highlightSegment;
      moveHandlers[1] = moveArrow;
      moveHandlers[2] = rotateArrow;

      downHandlers[0] = selectSegment;
      downHandlers[1] = fixPosition;
      downHandlers[2] = fixAngle;
    }


    private function highlightSegment(e)
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

    private function moveArrow(e:MouseEvent){
      var p:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
      p = snap.doSnapToForce(p, highlightedSegment);
      this.arrow.x = p.x;
      this.arrow.y = p.y;
      arrowCoordinates = p;
    }

    private function rotateArrow(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      parent1.removeChild(arrow);
      arrow = new ArcArrow(arrowCoordinates, cursorPosition, panel.isMomentClockWise, 0);
      button_over = new ArcArrow(arrowCoordinates, cursorPosition, panel.isMomentClockWise, 0xff);
      button_up = new ArcArrow(arrowCoordinates, cursorPosition, panel.isMomentClockWise, 0);
      button_down = button_up;
      button_hit = button_up;

      arrow.x = arrowCoordinates.x;
      arrow.y = arrowCoordinates.y;
      parent1.addChild(arrow);
    }


    private function selectSegment(e:MouseEvent)
    {
      var angle:Number;
      var p:Point;
      var positionOfArrow:Point;
      if( this.highlightedSegment != null)
      {
        nextHandlers();

        highlightedSegment.setColor(0x0);
        positionOfArrow = snap.doSnapToSegment( new Point(e.stageX, e.stageY), highlightedSegment);
        positionOfArrow = snap.doSnapToForce( positionOfArrow, highlightedSegment);
        arrow = new ArcArrow(positionOfArrow, new Point(e.stageX, e.stageY), true, 0);
        parent1.addChild(arrow);
        arrow.x = positionOfArrow.x;
        arrow.y = positionOfArrow.y;
        arrowCoordinates = positionOfArrow;
      }
    }

    private function fixPosition(e:MouseEvent)
    {
      panel = new MomentPanel();
      panel.x = 800-135;

      nextHandlers();

      parent1.addChild(panel);
    }

    private function fixAngle(e:MouseEvent)
    {
      // убираем всех прослушивателей событий
      releaseEvents();

      this.isClockWise = panel.isMomentClockWise;
      panel.destroy();
      parent1.removeChild(panel);

      arrowAngle = arrow.angleOfTip;

      initDialog();
    }
    
    private function initDialog()
    {
      dialogWnd = new EditWindowMoment("","");
      parent1.addChild(dialogWnd);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }
    
    private function releaseDialog()
    {
      dialogWnd.removeEventListener(DialogEvent.END_DIALOG, onEndDialog);
      
      parent1.removeChild(dialogWnd);
      parent1.removeChild(arrow);
      dialogWnd = null;
    }

    
    private function onEndDialog(e:DialogEvent)
    {
      releaseDialog();
      
      if(e.canceled)
        creationCancel();
      else
        createMoment(e.eventData);
    }

    private function createMoment(data:Object)
    {
      var p:Point;
      var angle:Number;
      moment = new Moment(parent1, button_up, button_over, button_down, button_hit, data.forceName);

      moment.units = data.units;
      moment.momentValue = data.forceValue;
      
      moment.segment = highlightedSegment;
      moment.momentNumber = momentNumber;
      moment.isClockWise = this.isClockWise;
      p = Point.polar(40, arrowAngle);
      p.y = -p.y;  // преобразуем из дкартовой системы координат в оконную
      moment.setCoordOfMomentName(p);
      moment.x = arrowCoordinates.x;
      moment.y = arrowCoordinates.y;
      
      dispatchEvent(new Event(ConcentratedForceCreator.CREATE_DONE));
    }

    private function creationCancel()
    {
      dispatchEvent(new Event(ConcentratedForceCreator.CREATE_CANCEL));
    }

    public function get result():Moment
    {
      return moment;
    }
  }
}
