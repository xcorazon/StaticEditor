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
  import pr1.windows.EditWindowAngle;
  import pr1.windows.EditWindow;
  import pr1.razmers.AngleDimensionContainer;
  import pr1.Snap;
  import pr1.panels.AnglePanel;

  public class AngleDimensionCreatorY extends Sprite
  {
    // события в объекте
    public static const CREATE_CANCEL:String = "Cancel creation of angle";
    public static const CREATE_DONE:String = "Done creation of angle";
    // константы для внутреннего использования
    private static const SELECT_SEGMENT:int = 0;
    private static const SELECT_RADIUS:int = 1;

    private var parent1:*;
    private var segments:Array;
    private var highlightedSegment:Segment;
    private var snap:Snap;
    private var angleDimensionF:AngleDimension;
    private var panel:AnglePanel;

    // выходные данные
    private var razmerScreenPosition:Point;
    private var segmentAngle:Number;
    private var secondPointOfSegment:Point;
    private var razmerRadius:Number;
    private var firstPointNumber:int;
    private var secondPointNumber:int;
    private var thirdPointNumber:int;
    private var firstPointScreenCoord:Point;
    private var secondPointScreenCoord:Point;
    private var thirdPointScreenCoord:Point;
    private var radius:Number;

    private var isInnerAngle:Boolean;
    private var razmerName:String;
    private var razmerValue:String;
    private var razmerSign:int;

    private var button_up:AngleDimension;
    private var button_over:AngleDimension;
    private var button_down:AngleDimension;
    private var button_hit:AngleDimension;
    //cам элемент нагрузки в полном виде
    private var razmer:AngleDimensionContainer = null;

    private var dialogWnd:EditWindowAngle;

    private var doNow:int;

    public function AngleDimensionCreatorY(parent:*, segments:Array)
    {
      // constructor code
      this.parent1 = parent;
      this.segments = segments;
      this.doNow = SELECT_SEGMENT;
      this.highlightedSegment = null;

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
        case SELECT_RADIUS:
          doMoveRadius(e);
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

    private function doMoveRadius(e:MouseEvent)
    {
      var p:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var angle:Number = Math.PI/2;
      this.isInnerAngle = panel.isInnerAngle;

      if(!panel.isInnerAngle)
      {
        angle -= Math.PI;
      }
      this.parent1.removeChild(angleDimensionF);

      angleDimensionF = new AngleDimension(razmerScreenPosition, angle, this.secondPointOfSegment, cursorPosition, 0);
      button_over = new AngleDimension(razmerScreenPosition, angle, this.secondPointOfSegment, cursorPosition, 0xff);
      button_up = new AngleDimension(razmerScreenPosition, angle, this.secondPointOfSegment, cursorPosition, 0);
      button_down = button_up;
      button_hit = button_up;

      this.radius = angleDimensionF.radius;

      angleDimensionF.x = razmerScreenPosition.x;
      angleDimensionF.y = razmerScreenPosition.y;
      this.parent1.addChild(angleDimensionF);
    }

    private function onMouseDown(e:MouseEvent)
    {
      switch(doNow)
      {
        case SELECT_SEGMENT:
          doSelectSegment(e);
          break;
        case SELECT_RADIUS:
          doSelectRadius(e);
      }
    }

    private function doSelectSegment(e:MouseEvent)
    {
      var vector:Point;
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      if( this.highlightedSegment != null)
      {
        razmerScreenPosition = highlightedSegment.firstScreenCoord;
        // запоминаем точки данного отрезка
        this.firstPointNumber = 2;
        this.firstPointScreenCoord = razmerScreenPosition.clone();
        this.firstPointScreenCoord.y -= 20;
        this.secondPointNumber = highlightedSegment.firstPointNumber;
        this.secondPointScreenCoord = highlightedSegment.firstScreenCoord;
        this.thirdPointNumber = highlightedSegment.secondPointNumber;
        this.thirdPointScreenCoord = highlightedSegment.secondScreenCoord;
        this.secondPointOfSegment = highlightedSegment.secondScreenCoord;

        highlightedSegment.setColor(0x0);

        angleDimensionF = new AngleDimension(razmerScreenPosition, 0, this.secondPointOfSegment, cursorPosition, 0);
        this.parent1.addChild(angleDimensionF);
        angleDimensionF.x = razmerScreenPosition.x;
        angleDimensionF.y = razmerScreenPosition.y;

        panel = new AnglePanel();
        panel.x = 800-135;
        parent1.addChild(panel);
        doNow = SELECT_RADIUS;
      }
    }

    private function doSelectRadius(e:MouseEvent)
    {
      // убираем всех прослушивателей событий
      parent1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      parent1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      parent1.removeChild(panel);
      panel.destroy();
      panel = null;

      dialogWnd = new EditWindowAngle("","");
      parent1.addChild(dialogWnd);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.addEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.addEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);
      /*trace("Номер первой точки: ", this.firstPointNumber);
      trace("Номер второй точки: ", this.secondPointNumber);
      trace("Номер третьей точки: ", this.thirdPointNumber);

      trace("Координата первой точки: ", this.firstPointScreenCoord.toString());
      trace("Координата второй точки: ", this.secondPointScreenCoord.toString());
      trace("Координата третьей точки: ", this.thirdPointScreenCoord.toString());
      */
    }

    private function onEndEditInDialogWindow(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

      parent1.removeChild(dialogWnd);
      parent1.removeChild(angleDimensionF);

      razmerName = dialogWnd.razmer;
      razmerValue = dialogWnd.value;
      dialogWnd = null;
      doCreateAngleDimension();
      dispatchEvent(new Event(AngleDimensionCreator.CREATE_DONE));
    }

    private function doCreateAngleDimension()
    {
      var p:Point;
      var angle:Number;
      razmer = new AngleDimensionContainer(parent1, button_up, button_over, button_down, button_hit, razmerName);

      razmer.razmerValue = razmerValue;
      razmer.razmerName = razmerName;
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
    }

    private function onCancelEditInDialogWindow(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

      parent1.removeChild(dialogWnd);
      parent1.removeChild(angleDimensionF);

      dialogWnd = null;
      dispatchEvent(new Event(LinearDimensionCreator.CREATE_CANCEL));
    }


    public function get result():AngleDimensionContainer
    {
      return razmer;
    }
  }
}