package  pr1.Shapes
{
  import flash.display.SimpleButton;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindowAngle;
  import pr1.razmers.AngleDimensionContainer;
  import pr1.panels.AnglePanel;
  import pr1.Frame;
  import pr1.events.DialogEvent;

  public class AngleDimensionCreatorX extends Creator
  {
    private var highlightedSegment:Segment;
    protected var panel:AnglePanel;

    // выходные данные
    private var razmerScreenPosition:Point;
    private var secondPointOfSegment:Point;
    private var firstPointNumber:int;
    private var secondPointNumber:int;
    private var thirdPointNumber:int;
    protected var firstPointScreenCoord:Point;
    protected var secondPointScreenCoord:Point;
    protected var thirdPointScreenCoord:Point;
    private var radius:Number;

    protected var isInnerAngle:Boolean;

    private var button_up:AngleDimension;
    private var button_over:AngleDimension;
    private var button_down:AngleDimension;
    private var button_hit:AngleDimension;
    //cам элемент нагрузки в полном виде
    private var razmer:AngleDimensionContainer = null;

    protected var FIRST_POINT_NUM:int;


    public function AngleDimensionCreatorX(frame:Frame)
    {
      super(frame);
      this.highlightedSegment = null;

      FIRST_POINT_NUM = ComConst.OX_PLUS;

      initEvents();
      initHandlers();
    }


    private function initHandlers()
    {
      moveHandlers[0] = highlightSegment;
      moveHandlers[1] = selectRadius;

      downHandlers[0] = selectSegment;
      downHandlers[1] = fixRadius;
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
        if( tempThres <= thres && (seg.specialDirection != Segment.HORISONTAL) && (seg.specialDirection != Segment.VERTICAL))
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

    protected function getAngle():Number
    {
      var angle:Number = 0;
      this.isInnerAngle = panel.isInnerAngle;
      if(!panel.isInnerAngle)
      {
        angle += Math.PI;
        if(angle >= Math.PI*2)
          angle = angle - 2 * Math.PI;
      }

      return angle;
    }

    private function selectRadius(e:MouseEvent)
    {
      var p:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);

      var angle:Number = getAngle();

      this.parent1.removeChild(elementImage);

      elementImage = new AngleDimension(razmerScreenPosition, angle, this.secondPointOfSegment, cursorPosition, 0);
      button_over = new AngleDimension(razmerScreenPosition, angle, this.secondPointOfSegment, cursorPosition, 0xff);
      button_up = new AngleDimension(razmerScreenPosition, angle, this.secondPointOfSegment, cursorPosition, 0);
      button_down = button_up;
      button_hit = button_up;

      this.radius = elementImage.radius;

      elementImage.x = razmerScreenPosition.x;
      elementImage.y = razmerScreenPosition.y;
      this.parent1.addChild(elementImage);
    }


    private function selectSegment(e:MouseEvent)
    {
      var vector:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      if( this.highlightedSegment != null)
      {
        razmerScreenPosition = highlightedSegment.firstScreenCoord;
        // запоминаем точки данного отрезка
        this.firstPointNumber = FIRST_POINT_NUM;
        this.firstPointScreenCoord = razmerScreenPosition.clone();
        changeFirstPointCoord();
        this.secondPointNumber = highlightedSegment.firstPointNumber;
        this.secondPointScreenCoord = highlightedSegment.firstScreenCoord;
        this.thirdPointNumber = highlightedSegment.secondPointNumber;
        this.thirdPointScreenCoord = highlightedSegment.secondScreenCoord;
        this.secondPointOfSegment = highlightedSegment.secondScreenCoord;

        highlightedSegment.setColor(0x0);

        elementImage = new AngleDimension(razmerScreenPosition, 0, this.secondPointOfSegment, cursorPosition, 0);
        this.parent1.addChild(elementImage);
        elementImage.x = razmerScreenPosition.x;
        elementImage.y = razmerScreenPosition.y;

        panel = new AnglePanel();
        panel.x = 800-135;
        parent1.addChild(panel);
        nextHandlers();
      }
    }

    protected function changeFirstPointCoord()
    {
      this.firstPointScreenCoord.x += 20;
    }

    private function fixRadius(e:MouseEvent)
    {
      releaseEvents();
      parent1.removeChild(panel);
      panel.destroy();
      panel = null;

      initDialog();
    }


    private function initDialog()
    {
      dialogWnd = new EditWindowAngle("","");
      parent1.addChild(dialogWnd);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }


    override protected function createObject(data:Object)
    {
      var p:Point;
      var angle:Number;
      razmer = new AngleDimensionContainer(frame, button_up, button_over, button_down, button_hit, data.name);

      razmer.razmerValue = data.value;
      razmer.razmerName = data.name;

      razmer.firstPointNumber = this.firstPointNumber;
      razmer.secondPointNumber = this.secondPointNumber;
      razmer.thirdPointNumber = this.thirdPointNumber;
      razmer.firstPointScreenCoord = this.firstPointScreenCoord;
      razmer.secondPointScreenCoord = this.secondPointScreenCoord;
      razmer.thirdPointScreenCoord = this.thirdPointScreenCoord;
      razmer.radius = this.radius;
      razmer.isInnerAngle = this.isInnerAngle;

      razmer.x = razmerScreenPosition.x;
      razmer.y = razmerScreenPosition.y;

      razmer.setCoordOfRazmerName();

      super.createObject(data);
    }


    public function get result():AngleDimensionContainer
    {
      return razmer;
    }
  }
}