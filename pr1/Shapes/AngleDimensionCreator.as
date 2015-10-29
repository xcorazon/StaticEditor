package  pr1.Shapes
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.CoordinateTransformation;
  import pr1.windows.EditWindowAngle;
  import pr1.razmers.AngleDimensionContainer;
  import pr1.panels.AnglePanel;
  import pr1.Frame;
  import pr1.events.DialogEvent;

  public class AngleDimensionCreator extends Creator
  {
    private var firstHighlightedSegment:Segment;
    private var secondHighlightedSegment:Segment;
    private var panel:AnglePanel;

    // выходные данные
    private var razmerScreenPosition:Point;
    private var firstSegmentAngle:Number;
    private var pointOfSecondSegment:Point;

    private var firstPointNumber:int;
    private var secondPointNumber:int;
    private var thirdPointNumber:int;
    private var firstPointScreenCoord:Point;
    private var secondPointScreenCoord:Point;
    private var thirdPointScreenCoord:Point;
    private var radius:Number;

    private var isInnerAngle:Boolean;

    private var button_up:AngleDimension;
    private var button_over:AngleDimension;
    private var button_down:AngleDimension;
    private var button_hit:AngleDimension;
    //cам элемент нагрузки в полном виде
    private var razmer:AngleDimensionContainer = null;


    public function AngleDimensionCreator(frame:Frame)
    {
      super(frame);
      this.firstHighlightedSegment = null;
      this.secondHighlightedSegment = null;

      initEvents();
      initHandlers();
    }

    private function initHandlers()
    {
      moveHandlers[0] = highlightFirstSegment;
      moveHandlers[1] = highlightSecondSegment;
      moveHandlers[2] = selectRadius;

      downHandlers[0] = selectFirstSegment;
      downHandlers[1] = selectSecondSegment;
      downHandlers[2] = fixRadius;
    }


    private function highlightFirstSegment(e)
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

      if( isAnySegmentNear(tempSegment))
      {
        if(firstHighlightedSegment != null)
        {
          if(tempSegment == null)
          {
            firstHighlightedSegment.setColor(0x0);
            firstHighlightedSegment = null;
            return;
          }
          else
          {
            firstHighlightedSegment.setColor(0x0);
            firstHighlightedSegment = tempSegment;
            firstHighlightedSegment.setColor(0xff);
            return;
          }
        }
        else
        {
          if(tempSegment != null)
          {
            firstHighlightedSegment = tempSegment;
            firstHighlightedSegment.setColor(0xff);
            return;
          }
        }
      }
    }

    private function highlightSecondSegment(e)
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

      if(tempSegment == firstHighlightedSegment)
        return;

      if(tempSegment != null)
      {
        if(firstHighlightedSegment.specialDirection != -1 && tempSegment.specialDirection != -1)
        {
          return;
        }
      }

      if(secondHighlightedSegment != null)
      {
        if(tempSegment == null)
        {
          secondHighlightedSegment.setColor(0x0);
          secondHighlightedSegment = null;
          return;
        }
        else
        {
          secondHighlightedSegment.setColor(0x0);
          secondHighlightedSegment = tempSegment;
          secondHighlightedSegment.setColor(0xff);
          return;
        }
      }
      else
      {
        if(tempSegment != null)
        {
          secondHighlightedSegment = tempSegment;
          secondHighlightedSegment.setColor(0xff);
          return;
        }
      }
    }

    private function selectRadius(e:MouseEvent)
    {
      var p:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var angle:Number = firstSegmentAngle;
      this.isInnerAngle = panel.isInnerAngle;
      if(!panel.isInnerAngle)
      {
        angle += Math.PI;
        if(angle >= Math.PI*2)
          angle = angle - 2 * Math.PI;
      }
      this.parent1.removeChild(elementImage);

      elementImage = new AngleDimension(razmerScreenPosition, angle, this.pointOfSecondSegment, cursorPosition, 0);
      button_over = new AngleDimension(razmerScreenPosition, angle, this.pointOfSecondSegment, cursorPosition, 0xff);
      button_up = new AngleDimension(razmerScreenPosition, angle, this.pointOfSecondSegment, cursorPosition, 0);
      button_down = button_up;
      button_hit = button_up;

      this.radius = elementImage.radius;

      elementImage.x = razmerScreenPosition.x;
      elementImage.y = razmerScreenPosition.y;
      this.parent1.addChild(elementImage);
    }


    private function selectFirstSegment(e:MouseEvent)
    {
      if( this.firstHighlightedSegment != null)
        nextHandlers();
    }

    private function selectSecondSegment(e:MouseEvent)
    {
      var vector:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      if( this.secondHighlightedSegment != null)
      {
        if(firstHighlightedSegment.firstScreenCoord.equals(secondHighlightedSegment.firstScreenCoord)
           || firstHighlightedSegment.firstScreenCoord.equals(secondHighlightedSegment.secondScreenCoord))
        {
          razmerScreenPosition = firstHighlightedSegment.firstScreenCoord;
          //угол отрезка относительно выбранной точки
          vector = firstHighlightedSegment.secondDecartCoord.subtract(firstHighlightedSegment.firstDecartCoord);
          this.firstSegmentAngle = CoordinateTransformation.decartToPolar(vector).y;
          // запоминаем точки данного отрезка
          this.firstPointNumber = firstHighlightedSegment.secondPointNumber;
          this.firstPointScreenCoord = firstHighlightedSegment.secondScreenCoord;
          this.secondPointNumber = firstHighlightedSegment.firstPointNumber;
          this.secondPointScreenCoord = firstHighlightedSegment.firstScreenCoord;
          // вторая опорная точка для построения угла
          if(secondHighlightedSegment.firstScreenCoord.equals(firstHighlightedSegment.firstScreenCoord))
          {
            this.pointOfSecondSegment = secondHighlightedSegment.secondScreenCoord;
            this.thirdPointNumber = secondHighlightedSegment.secondPointNumber;
            this.thirdPointScreenCoord = secondHighlightedSegment.secondScreenCoord;
          }
          else
          {
            this.pointOfSecondSegment = secondHighlightedSegment.firstScreenCoord;
            this.thirdPointNumber = secondHighlightedSegment.firstPointNumber;
            this.thirdPointScreenCoord = secondHighlightedSegment.firstScreenCoord;
          }
        }
        else
        {
          razmerScreenPosition = firstHighlightedSegment.secondScreenCoord
          //угол отрезка относительно выбранной точки
          vector = firstHighlightedSegment.firstDecartCoord.subtract(firstHighlightedSegment.secondDecartCoord);
          this.firstSegmentAngle = CoordinateTransformation.decartToPolar(vector).y;
          // запоминаем точки данного отрезка
          this.firstPointNumber = firstHighlightedSegment.firstPointNumber;
          this.firstPointScreenCoord = firstHighlightedSegment.firstScreenCoord;
          this.secondPointNumber = firstHighlightedSegment.secondPointNumber;
          this.secondPointScreenCoord = firstHighlightedSegment.secondScreenCoord;
          // вторая опорная точка для построения угла
          if(secondHighlightedSegment.firstScreenCoord.equals(firstHighlightedSegment.secondScreenCoord))
          {
            this.pointOfSecondSegment = secondHighlightedSegment.secondScreenCoord;
            this.thirdPointNumber = secondHighlightedSegment.secondPointNumber;
            this.thirdPointScreenCoord = secondHighlightedSegment.secondScreenCoord;
          }
          else
          {
            this.pointOfSecondSegment = secondHighlightedSegment.firstScreenCoord;
            this.thirdPointNumber = secondHighlightedSegment.firstPointNumber;
            this.thirdPointScreenCoord = secondHighlightedSegment.firstScreenCoord;
          }
        }
        firstHighlightedSegment.setColor(0x0);
        secondHighlightedSegment.setColor(0x0);

        elementImage = new AngleDimension(razmerScreenPosition, firstSegmentAngle, this.pointOfSecondSegment, cursorPosition, 0);
        this.parent1.addChild(elementImage);
        elementImage.x = razmerScreenPosition.x;
        elementImage.y = razmerScreenPosition.y;

        panel = new AnglePanel();
        panel.x = 800-135;
        parent1.addChild(panel);
        nextHandlers();
      }
    }

    private function fixRadius(e:MouseEvent)
    {
      // убираем всех прослушивателей событий
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


    private function isAnySegmentNear(seg:Segment):Boolean
    {
      var nearSegments:Array = new Array();
      if(seg == null)
        return true;

      for each (var s:Segment in segments)
      {
        if((s.firstPointNumber == seg.firstPointNumber || s.firstPointNumber == seg.secondPointNumber ||
           s.secondPointNumber == seg.firstPointNumber || s.secondPointNumber == seg.secondPointNumber) && s != seg){
             nearSegments.push(s);
           }
      }
      if(seg.specialDirection == Segment.HORISONTAL || seg.specialDirection == Segment.VERTICAL)
      {
        for each (s in nearSegments)
        {
          if( s.specialDirection == -1)
          {
            return true;
          }
        }
      }
      else if(nearSegments.length != 0)
        return true;

      return false;
    }

    public function get result():AngleDimensionContainer
    {
      return razmer;
    }
  }
}