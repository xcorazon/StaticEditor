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
  import pr1.Frame;
  import pr1.events.DialogEvent;

  public class ConcentratedForceCreator extends Creator
  {
    // события в объекте
    public static const CREATE_CANCEL:String = "Cancel creation of concentrated force";
    public static const CREATE_DONE:String = "Done creation of concentrated force";

    private var forceNumber:int;
    private var highlightedSegment:Segment;
    private var panel:ConcentratedForcePanel;

    private var isTail:Boolean;
    // выходные данные
    private var anglePoints:Array;
    private var arrowAngle:Number;
    private var arrowCoordinates:Point;   // координаты стрелки на экране
    private var angleValue:String;

    private var button_up:Arrow;
    private var button_over:Arrow;
    private var button_down:Arrow;
    private var button_hit:Arrow;
    //cам элемент нагрузки в полном виде
    private var force:ConcentratedForce = null;


    public function ConcentratedForceCreator()
    {
      super();
      forceNumber = 1000 - 1;
    }
    
    override public function create()
    {
      super.create();
      this.highlightedSegment = null;
      forceNumber++;
      isTail = false;

      initEvents();
      initHandlers();
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

    private function highlightSegment(e:MouseEvent)
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

    private function moveArrow(e:MouseEvent)
    {
      var p:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
      p = snap.doSnapToForce(p, highlightedSegment);
      this.elementImage.x = p.x;
      this.elementImage.y = p.y;
      arrowCoordinates = p;
    }

    private function rotateArrow(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      parent1.removeChild(elementImage);
      elementImage = new Arrow(arrowCoordinates, panel.angleOfAxis, cursorPosition, isTail, 0);
      button_over = new Arrow(arrowCoordinates, panel.angleOfAxis, cursorPosition, isTail, 0xff);
      button_up = new Arrow(arrowCoordinates, panel.angleOfAxis, cursorPosition, isTail, 0);;
      button_down = button_up;
      button_hit = button_up;

      elementImage.x = arrowCoordinates.x;
      elementImage.y = arrowCoordinates.y;
      parent1.addChild(elementImage);
    }

    private function onChangePanel(e:Event)
    {
      if( panel.pointsOfAngle[2] == ComConst.FORCE_FROM)
        this.isTail = false;
      else
        this.isTail = true;
    }

    private function selectSegment(e:MouseEvent)
    {
      var angle:Number;
      var p:Point;
      var positionOfArrow:Point;
      if( this.highlightedSegment != null)
      {
        p = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
        angle = CoordinateTransformation.decartToPolar(p).y;

        nextHandlers();

        highlightedSegment.setColor(0x0);
        positionOfArrow = snap.doSnapToSegment( new Point(e.stageX, e.stageY), highlightedSegment);
        elementImage = new Arrow(positionOfArrow, angle, new Point(e.stageX, e.stageY), false, 0);
        parent1.addChild(elementImage);
        elementImage.x = positionOfArrow.x;
        elementImage.y = positionOfArrow.y;
        arrowCoordinates = positionOfArrow;
      }
    }

    private function fixPosition(e:MouseEvent)
    {
      panel = new ConcentratedForcePanel();
      panel.x = 800 - 245;

      nextHandlers();

      panel.setSegmentPoints(highlightedSegment.firstPointNumber,
                   highlightedSegment.firstDecartCoord,
                   highlightedSegment.secondPointNumber,
                   highlightedSegment.secondDecartCoord);
      panel.addEventListener(ConcentratedForcePanel.CHANGE_STATE, onChangePanel);
      parent1.addChild(panel);
    }

    private function fixAngle(e:MouseEvent)
    {
      // убираем всех прослушивателей событий
      panel.removeEventListener(ConcentratedForcePanel.CHANGE_STATE, onChangePanel);

      releaseEvents();

      anglePoints = panel.pointsOfAngle;
      panel.destroy();
      parent1.removeChild(panel);

      anglePoints[1] = this.forceNumber;
      arrowAngle = elementImage.angleOfTipOrTail;

      angleValue = "";
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

      initDialog();
    }

    private function initDialog()
    {
      dialogWnd = new EditWindow3("","","",angleValue);
      parent1.addChild(dialogWnd);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }


    override protected function createObject(data:Object)
    {
      var p:Point;
      var angle:Number;
      force = new ConcentratedForce(Frame.Instance, button_up, button_over, button_down, button_hit, data.forceName, data.angleName);

      force.units = data.units;
      force.segment = highlightedSegment;
      force.forceNumber = forceNumber;
      force.angleValue = data.angleValue;
      force.forceValue = data.forceValue;
      force.angleSign = elementImage.angleSign;
      force.anglePoints = this.anglePoints;

      force.angleOfAxis = panel.angleOfAxis;
      force.arrowAngle = Math.abs(arrowAngle);

      force.x = arrowCoordinates.x;
      force.y = arrowCoordinates.y;
      force.setCoordOfSignatures();

      super.createObject(data);
    }

    override public function get result():*
    {
      return force;
    }
  }
}