package  pr1.Shapes
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.panels.MomentPanel;
  import pr1.Shapes.RectangularArrowsArray;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindowQ;
  import pr1.windows.EditWindow;
  import pr1.forces.DistributedForceR;
  import pr1.Snap;
  import pr1.Frame;

  public class DistributedForceRCreator extends Creator
  {
    private var forceNumber1:int;
    private var forceNumber2:int;
    private var highlightedSegment:Segment;

    private var arrowsHeight:Number;
    private var arrowsLength:Number;
    private var arrowsCoordinate1:Point;  // координаты стрелок на экране
    private var arrowsCoordinate2:Point;  // координаты стрелок на экране
    
    private var angleValue:String;

    private var button_up:RectangularArrowsArray;
    private var button_over:RectangularArrowsArray;
    private var button_down:RectangularArrowsArray;
    private var button_hit:RectangularArrowsArray;
    //cам элемент нагрузки в полном виде
    private var distributedForce:* = null;


    public function DistributedForceRCreator(frame:Frame)
    {
      super(frame);

      this.segments = segments;
      this.highlightedSegment = null;
      this.forceNumber1 = lastNonusedForceNumber;
      this.forceNumber2 = lastNonusedForceNumber + 1;

      initHandlers();
      initEvents();
    }
    
    private function initHandlers()
    {
      moveHandlers[0] = highlightSegment;
      moveHandlers[1] = moveArrow;
      moveHandlers[2] = moveSecondPoint;

      downHandlers[0] = selectSegment;
      downHandlers[1] = fixPosition;
      downHandlers[2] = fixLength;
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

    private function moveArrow(e:MouseEvent)
    {
      var p:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
      p = snap.doSnapToForce(p, highlightedSegment);
      this.elementImage.x = p.x;
      this.elementImage.y = p.y;
      arrowsCoordinate1 = p;
    }

    private function moveSecondPoint(e:MouseEvent)
    {
      var length:Number;
      var height:Number;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var localCoordSysPosition:Point = arrowsCoordinate1;
      var positionOfsecondPointOnSegment:Point;
      var p:Point;
      var angle:Number;
      parent1.removeChild(elementImage);

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

      elementImage = new RectangularArrowsArray(length, height, angle, 0);
      button_over = new RectangularArrowsArray(length, height, angle, 0xff);
      button_up = new RectangularArrowsArray(length, height, angle, 0);
      button_down = button_up;
      button_hit = button_up;

      elementImage.x = arrowsCoordinate1.x;
      elementImage.y = arrowsCoordinate1.y;
      parent1.addChild(elementImage);
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
        elementImage = new RectangularArrowsArray(10,20,angle,0);
        parent1.addChild(elementImage);
        elementImage.x = positionOfArrow.x;
        elementImage.y = positionOfArrow.y;
        arrowsCoordinate1 = positionOfArrow;
      }
    }

    private function fixPosition(){
      nextHandlers();
    }

    private function fixLength(e:MouseEvent)
    {
      if(arrowsCoordinate2.equals(arrowsCoordinate1))
        return;

      releaseEvents();
      initDialog();
    }
    
    protected function initDialog()
    {
      dialogWnd = new EditWindowQ("","");
      parent1.addChild(dialogWnd);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }
    
    override protected function createObject(data:Object)
    {
    
      var p:Point;
      var angle:Number;
      distributedForceR = new DistributedForceR(parent1, button_up, button_over, button_down, button_hit, data.forceName);

      distributedForceR.forceValue = data.forceValue;
      distributedForceR.units = data.units;
      distributedForceR.segment = highlightedSegment;
      
      distributedForceR.firstScreenCoord = arrowsCoordinate1;
      distributedForceR.secondScreenCoord = arrowsCoordinate2;
      distributedForceR.forceNumber1 = this.forceNumber1;
      distributedForceR.forceNumber2 = this.forceNumber2;
      distributedForceR.angleValue = this.angleValue;

      p = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
      angle = CoordinateTransformation.decartToPolar(p).y;
      p = new Point(arrowsLength/2, arrowsHeight);
      p = CoordinateTransformation.rotate(p, angle);

      p.y = -p.y;  // преобразуем из дкартовой системы координат в оконную
      distributedForceR.setCoordOfForceName(p);
      distributedForceR.x = arrowsCoordinate1.x;
      distributedForceR.y = arrowsCoordinate1.y;
    
      super.createObject(data);

      //dispatchEvent(new Event(ConcentratedForceCreator.CREATE_DONE));
    }

    public function get result():DistributedForceR
    {
      return distributedForceR;
    }
  }
}