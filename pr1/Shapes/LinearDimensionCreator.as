package  pr1.Shapes
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.Shapes.LinearDimension;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindow4;
  import pr1.windows.EditWindow;
  import pr1.razmers.LinearDimensionContainer;
  import pr1.Snap;
  import pr1.Frame;
  import pr1.events.DialogEvent;

  public class LinearDimensionCreator extends Creator
  {
    private var highlightedSegment:Segment;

    // выходные данные
    private var firstCoordinate:Point;  // координаты первой точки размера на экране
    private var secondCoordinate:Point;   // координаты второй точки размера на экране
    private var razmerHeight:Number;
    private var angle1:Number;

    private var button_up:LinearDimension;
    private var button_over:LinearDimension;
    private var button_down:LinearDimension;
    private var button_hit:LinearDimension;
    //cам элемент нагрузки в полном виде
    private var razmer:LinearDimensionContainer = null;

    public function LinearDimensionCreator(frame:Frame)
    {
      super(frame);
    }
    
    override public function create()
    {
      super.create();
      this.highlightedSegment = null;

      initHandlers();
      initEvents();
    }


    private function initHandlers()
    {
      moveHandlers[0] = highlightSegment;
      moveHandlers[1] = snapFirstPoint;
      moveHandlers[2] = snapSecondPoint;
      moveHandlers[3] = changeHeight;

      downHandlers[0] = selectSegment;
      downHandlers[1] = selectFirstPoint;
      downHandlers[2] = selectSecondPoint;
      downHandlers[3] = fixHeight;
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

    private function snapFirstPoint(e:MouseEvent)
    {
      var p:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
      p = snap.doSnapToForce(p, highlightedSegment);
      this.elementImage.x = p.x;
      this.elementImage.y = p.y;
      firstCoordinate = p;
    }

    private function snapSecondPoint(e:MouseEvent)
    {
      var p:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
      p = snap.doSnapToForce(p, highlightedSegment);
      parent1.removeChild(elementImage);
      elementImage = new LinearDimension(firstCoordinate, p, 20, this.angle1, 0x0);
      parent1.addChild(elementImage);
      this.elementImage.x = firstCoordinate.x;
      this.elementImage.y = firstCoordinate.y;
      secondCoordinate = p;
    }

    private function changeHeight(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var localCoordSysPosition:Point = firstCoordinate;
      parent1.removeChild(elementImage);

      //находим высоту
      var p = CoordinateTransformation.screenToLocal(cursorPosition,localCoordSysPosition, this.angle1);
      razmerHeight = p.y;

      elementImage = new LinearDimension(firstCoordinate, secondCoordinate, razmerHeight, this.angle1, 0);
      button_over = new LinearDimension(firstCoordinate, secondCoordinate, razmerHeight, this.angle1, 0xff);
      button_up = new LinearDimension(firstCoordinate, secondCoordinate, razmerHeight, this.angle1, 0);
      button_down = button_up;
      button_hit = button_up;

      elementImage.x = firstCoordinate.x;
      elementImage.y = firstCoordinate.y;
      parent1.addChild(elementImage);
    }


    private function selectSegment(e:MouseEvent)
    {
      var p:Point;
      var positionOfFirstPoint:Point;
      var positionOfSecondPoint:Point;
      if( this.highlightedSegment != null)
      {
        p = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
        this.angle1 = CoordinateTransformation.decartToPolar(p).y;

        nextHandlers()

        highlightedSegment.setColor(0x0);
        positionOfFirstPoint = snap.doSnapToSegment( new Point(e.stageX, e.stageY), highlightedSegment);
        positionOfSecondPoint = CoordinateTransformation.localToScreen(new Point(15,0),positionOfFirstPoint, this.angle1);
        elementImage = new LinearDimension(positionOfFirstPoint, positionOfSecondPoint, 10, this.angle1, 0x0);
        parent1.addChild(elementImage);
        elementImage.x = positionOfFirstPoint.x;
        elementImage.y = positionOfFirstPoint.y;
        firstCoordinate = positionOfFirstPoint;
      }
    }

    private function selectFirstPoint(e:MouseEvent)
    {
      var p:Point;
      var p1:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
      p1 = snap.doSnapToForce(p, highlightedSegment);
      if( !p.equals(p1) || p1.equals(highlightedSegment.firstScreenCoord) || p1.equals(highlightedSegment.secondScreenCoord))
      {
        this.elementImage.x = p1.x;
        this.elementImage.y = p1.y;
        firstCoordinate = p1;

        nextHandlers();
      }
    }

    private function selectSecondPoint(e:MouseEvent)
    {
      var p:Point;
      var p1:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);

      p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
      p1 = snap.doSnapToForce(p, highlightedSegment);

      if(p1.equals(firstCoordinate))
        return;

      if(p1.equals(highlightedSegment.firstScreenCoord) || p1.equals(highlightedSegment.secondScreenCoord) || !p1.equals(p))
      {
        secondCoordinate = p1;
        nextHandlers();
      }
    }

    private function fixHeight(e:MouseEvent)
    {
      releaseEvents();
      initDialog();
    }

    private function initDialog()
    {
      dialogWnd = new EditWindow4("","");
      parent1.addChild(dialogWnd);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }


    override protected function createObject(data:Object)
    {
      razmer = new LinearDimensionContainer(frame, button_up, button_over, button_down, button_hit, data.name);
      setValues(razmer, data);

      super.createObject(data);
    }

    protected function setValues(razmer:*, data:Object)
    {
      var p:Point;
      var angle:Number;
      razmer.units = data.units;
      razmer.razmerValue = data.value;
      razmer.razmerName = data.name;

      razmer.firstPointDecartCoord = CoordinateTransformation.screenToLocal(firstCoordinate, new Point(0,600),0);
      razmer.secondPointDecartCoord = CoordinateTransformation.screenToLocal(secondCoordinate, new Point(0,600),0);
      razmer.firstPointScreenCoord = firstCoordinate;
      razmer.secondPointScreenCoord = secondCoordinate;

      razmer.x = firstCoordinate.x;
      razmer.y = firstCoordinate.y;

      p = razmer.secondPointDecartCoord.subtract(razmer.firstPointDecartCoord);
      angle = CoordinateTransformation.decartToPolar(p).y;
      if(Math.abs(angle1 - angle) >= 0.0001 )
      {
        razmerHeight = - razmerHeight;
      }

      razmer.razmerHeight = razmerHeight;
      razmer.setCoordOfRazmerName();
    }

    override public function get result():*
    {
      return razmer;
    }
  }
}
