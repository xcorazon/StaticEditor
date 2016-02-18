package  pr1.Shapes
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import flash.display.Shape;
  import pr1.Shapes.RectangularArrowsArray;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindowQ;
  import pr1.forces.DistributedForceR;
  import pr1.Frame;
  import pr1.events.DialogEvent;

  public class DistributedForceRCreator extends Creator
  {
    protected var forceNumber1:int;
    protected var forceNumber2:int;
    private var highlightedSegment:Segment;

    private var arrowsHeight:Number;
    private var arrowsLength:Number;
    private var arrowsCoordinate1:Point;  // координаты стрелок на экране
    private var arrowsCoordinate2:Point;  // координаты стрелок на экране

    private var angleValue:String;

    protected var button_up:*;
    protected var button_over:*;
    protected var button_down:*;
    protected var button_hit:*;
    //cам элемент нагрузки в полном виде
    protected var distributedForce:* = null;


    public function DistributedForceRCreator()
    {
      super();
      this.segments = Frame.Instance.segments;
      forceNumber1 = 3000 - 1;
      forceNumber2 = 3000;
    }
    
    override public function create()
    {
      super.create();
      
      this.highlightedSegment = null;
      forceNumber1 += 2;
      forceNumber2 += 2;

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

      setImage(length, height, angle);

      elementImage.x = arrowsCoordinate1.x;
      elementImage.y = arrowsCoordinate1.y;
      parent1.addChild(elementImage);
    }

    protected function setImage(length:Number, height:Number, angle:Number)
    {
      elementImage = new RectangularArrowsArray(length, height, angle, 0);
      button_over = new RectangularArrowsArray(length, height, angle, 0xff);
      button_up = new RectangularArrowsArray(length, height, angle, 0);
      button_down = button_up;
      button_hit = button_up;
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
        elementImage = getImage(angle);
        parent1.addChild(elementImage);
        elementImage.x = positionOfArrow.x;
        elementImage.y = positionOfArrow.y;
        arrowsCoordinate1 = positionOfArrow;
      }
    }

    protected function getImage(angle:Number):Shape
    {
      return new RectangularArrowsArray(10,20,angle,0);
    }

    private function fixPosition(e:MouseEvent){
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
      distributedForce = getForce(data.forceName);

      distributedForce.forceValue = data.forceValue;
      distributedForce.units = data.units;
      distributedForce.segment = highlightedSegment;

      distributedForce.firstScreenCoord = arrowsCoordinate1;
      distributedForce.secondScreenCoord = arrowsCoordinate2;
      distributedForce.forceNumber1 = this.forceNumber1;
      distributedForce.forceNumber2 = this.forceNumber2;
      distributedForce.angleValue = this.angleValue;
      
      p = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
      angle = CoordinateTransformation.decartToPolar(p).y;
      
      distributedForce.angleOfAxis = angle;
      distributedForce.arrowsHeight = arrowsHeight;
      distributedForce.arrowsLength = arrowsLength;
      
      distributedForce.setCoordOfSignatures();
     
      distributedForce.x = arrowsCoordinate1.x;
      distributedForce.y = arrowsCoordinate1.y;
      
      super.createObject(data);
    }

    protected function getForce(forceName:String):*
    {
      return new DistributedForceR(Frame.Instance, button_up, button_over, button_down, button_hit, forceName);
    }

    override public function get result():*
    {
      return distributedForce;
    }
  }
}