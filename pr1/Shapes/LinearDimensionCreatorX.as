package  pr1.Shapes
{
  import flash.display.SimpleButton;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import pr1.Shapes.LinearDimension;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindow4;
  import pr1.razmers.LinearDimensionXContainer;
  import pr1.Snap;
  import pr1.forces.*;
  import pr1.opora.*;
  import pr1.Frame;
  import pr1.events.DialogEvent;

  public class LinearDimensionCreatorX extends Creator
  {
    protected var firstCoordinate:Point;  // координаты первой точки размера на экране
    protected var secondCoordinate:Point;   // координаты второй точки размера на экране
    protected var razmerHeight:Number;
    protected var firstPointNumber:int;
    protected var secondPointNumber:int;

    protected var button_up:LinearDimension;
    protected var button_over:LinearDimension;
    protected var button_down:LinearDimension;
    protected var button_hit:LinearDimension;
    //cам элемент нагрузки в полном виде
    protected var razmer:* = null;

    protected var dimAngle:Number;


    public function LinearDimensionCreatorX(frame:Frame)
    {
      super(frame);

      this.elementImage = new LinearDimension(new Point(0,0), new Point(15,0), -20, 0, 0);
      parent1.addChild(elementImage);
      dimAngle = 0;

      initHandlers();
      initEvents();
    }

    private function initHandlers()
    {
      moveHandlers[0] = snapFirstPoint;
      moveHandlers[1] = snapSecondPoint;
      moveHandlers[2] = changeHeight;

      downHandlers[0] = selectFirstPoint;
      downHandlers[1] = selectSecondPoint;
      downHandlers[2] = fixHeight;
    }


    private function snapFirstPoint(e)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var p:Point = snap.doSnapToAnything(cursorPosition);
      elementImage.x = p.x;
      elementImage.y = p.y;
    }

    private function snapSecondPoint(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var p:Point = snap.doSnapToAnything(cursorPosition);
      parent1.removeChild(elementImage);
      elementImage = new LinearDimension(firstCoordinate, p, -20, dimAngle, 0);

      elementImage.x = firstCoordinate.x;
      elementImage.y = firstCoordinate.y;

      parent1.addChild(elementImage);
    }

    private function changeHeight(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      parent1.removeChild(elementImage);

      razmerHeight = getHeight(cursorPosition);

      elementImage = new LinearDimension(firstCoordinate, secondCoordinate, razmerHeight, dimAngle, 0);
      button_over = new LinearDimension(firstCoordinate, secondCoordinate, razmerHeight, dimAngle, 0xff);
      button_up = new LinearDimension(firstCoordinate, secondCoordinate, razmerHeight, dimAngle, 0);
      button_down = button_up;
      button_hit = button_up;

      elementImage.x = firstCoordinate.x;
      elementImage.y = firstCoordinate.y;
      parent1.addChild(elementImage);
    }

    protected function getHeight(cursorPosition:Point):Number
    {
      return firstCoordinate.y - cursorPosition.y;
    }


    private function selectFirstPoint(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var p:Point = snap.doSnapToAnything(cursorPosition);
      if(snap.lastSnappedObject is Segment)
      {
        if(p.equals(snap.lastSnappedObject.firstScreenCoord))
        {
           this.firstPointNumber = snap.lastSnappedObject.firstPointNumber;
           firstCoordinate = p;
           nextHandlers();
        }
        else if(p.equals(snap.lastSnappedObject.secondScreenCoord))
        {
           this.firstPointNumber = snap.lastSnappedObject.secondPointNumber;
           firstCoordinate = p;
           nextHandlers();
        }
      }

      if(snap.lastSnappedObject is ConcentratedForce)
      {
        this.firstPointNumber = snap.lastSnappedObject.forceNumber;
        firstCoordinate = p;
        nextHandlers();
      }

      if(snap.lastSnappedObject is DistributedForceR || snap.lastSnappedObject is DistributedForceT)
      {
        if(p.equals(snap.lastSnappedObject.firstScreenCoord))
        {
          this.firstPointNumber = snap.lastSnappedObject.forceNumber1;
          firstCoordinate = p;
          nextHandlers();
        }
        if(p.equals(snap.lastSnappedObject.secondScreenCoord))
        {
          this.firstPointNumber = snap.lastSnappedObject.forceNumber2;
          firstCoordinate = p;
          nextHandlers();
        }
      }
      if(snap.lastSnappedObject is MovableJointContainer || snap.lastSnappedObject is FixedJointContainer || snap.lastSnappedObject is SealingContainer)
      {
        if(p.x == snap.lastSnappedObject.x && p.y == snap.lastSnappedObject.y)
        {
          this.firstPointNumber = snap.lastSnappedObject.pointNumber;
          firstCoordinate = p;
          nextHandlers();
        }
      }

      elementImage.x = p.x;
      elementImage.y = p.y;
    }

    private function selectSecondPoint(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var p:Point = snap.doSnapToAnything(cursorPosition);

      if(p.equals(firstCoordinate))
        return;

      if(snap.lastSnappedObject is Segment)
      {
        if(p.equals(snap.lastSnappedObject.firstScreenCoord))
        {
           this.secondPointNumber = snap.lastSnappedObject.firstPointNumber;
           secondCoordinate = p;
           nextHandlers();
        }
        else if(p.equals(snap.lastSnappedObject.secondScreenCoord))
        {
           this.secondPointNumber = snap.lastSnappedObject.secondPointNumber;
           secondCoordinate = p;
           nextHandlers();
        }
      }

      if(snap.lastSnappedObject is ConcentratedForce)
      {
        this.secondPointNumber = snap.lastSnappedObject.forceNumber;
        secondCoordinate = p;
        nextHandlers();
      }

      if(snap.lastSnappedObject is DistributedForceR || snap.lastSnappedObject is DistributedForceT)
      {
        if(p.equals(snap.lastSnappedObject.firstScreenCoord))
        {
          this.secondPointNumber = snap.lastSnappedObject.forceNumber1;
          secondCoordinate = p;
          nextHandlers();
        }
        if(p.equals(snap.lastSnappedObject.secondScreenCoord))
        {
          this.secondPointNumber = snap.lastSnappedObject.forceNumber2;
          secondCoordinate = p;
          nextHandlers();
        }
      }
      if(snap.lastSnappedObject is MovableJointContainer || snap.lastSnappedObject is FixedJointContainer || snap.lastSnappedObject is SealingContainer)
      {
        if(p.x == snap.lastSnappedObject.x && p.y == snap.lastSnappedObject.y)
        {
          this.secondPointNumber = snap.lastSnappedObject.pointNumber;
          secondCoordinate = p;
          nextHandlers();
        }
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
      razmer = new LinearDimensionXContainer(frame, button_up, button_over, button_down, button_hit, data.name);
      setValues(razmer, data);

      super.createObject(data);
    }

    protected function setValues(razmer:*, data:Object)
    {
      razmer.units = data.units;
      razmer.razmerValue = data.value;
      razmer.razmerName = data.name;

      razmer.firstPointDecartCoord = CoordinateTransformation.screenToLocal(firstCoordinate, new Point(0,600),0);
      razmer.secondPointDecartCoord = CoordinateTransformation.screenToLocal(secondCoordinate, new Point(0,600),0);
      razmer.firstPointScreenCoord = firstCoordinate;
      razmer.secondPointScreenCoord = secondCoordinate;
      razmer.x = firstCoordinate.x;
      razmer.y = firstCoordinate.y;

      razmer.razmerHeight = razmerHeight;
      razmer.setCoordOfRazmerName();
    }

    public function get result():*
    {
      return razmer;
    }

  }

}
