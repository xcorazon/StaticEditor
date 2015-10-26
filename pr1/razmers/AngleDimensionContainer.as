package  pr1.razmers
{
  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.windows.EditWindowAngle;
  import pr1.Shapes.Designation;
  import pr1.CoordinateTransformation;
  import pr1.Frame;
  import pr1.events.DialogEvent;
  import pr1.forces.Element;


  public class AngleDimensionContainer extends Element
  {
    public var firstPointNumber:int;
    public var secondPointNumber:int;
    public var thirdPointNumber:int;
    public var firstPointScreenCoord:Point;
    public var secondPointScreenCoord:Point;
    public var thirdPointScreenCoord:Point;
    public var radius:Number;
    public var isInnerAngle:Boolean;
    public var razmerSign:int;

    public function AngleDimensionContainer(frame:Frame, upState:DisplayObject = null,
                 overState:DisplayObject = null,
                 downState:DisplayObject = null,
                 hitTestState:DisplayObject = null,
                 razmerName:String = null)
    {
      super(frame, upState, overState, upState, hitTestState);

      params.name = razmerName;
      this.razmerName = razmerName;
      signatures.name.disable();
    }

    private function onMouseClick(e:MouseEvent)
    {
      sigPoses.name = new Point(signatures.name.x, signatures.name.y);

      dialogWnd = new EditWindowAngle(params.value, params.name);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      parent1.addChild(dialogWnd);
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }

    override protected function changeValues(data:Object)
    {
      razmerName  = data.name;
      razmerValue = data.value;
    }
    
    public function setCoordOfRazmerName()
    {
      var startAngle:Number;
      var endAngle:Number;
      var R:Number = this.radius + Math.abs(this.radius)/this.radius * 10;
      var p1:Point = CoordinateTransformation.screenToLocal(this.firstPointScreenCoord, new Point(0,600), 0);
      var p2:Point = CoordinateTransformation.screenToLocal(this.secondPointScreenCoord, new Point(0,600), 0);
      var p3:Point = CoordinateTransformation.screenToLocal(this.thirdPointScreenCoord, new Point(0,600), 0);
      var vector1:Point = p1.subtract(p2);
      var vector2:Point = p3.subtract(p2);
      startAngle = CoordinateTransformation.decartToPolar(vector1).y;
      endAngle = CoordinateTransformation.decartToPolar(vector2).y;

      if(!this.isInnerAngle)
      {
        if(startAngle > endAngle) R = -R;
        startAngle += Math.PI;
      }

      /*trace("Начальный угол: ", startAngle * 180/Math.PI);
      trace("Конечный угол: ", endAngle * 180/Math.PI);
      trace("Радиус: ", R);*/
      var positionOfSignature:Point = CoordinateTransformation.rotate( new Point(R,0), (startAngle + endAngle)/2);
      positionOfSignature.x = positionOfSignature.x - signatures.name.width/2;
      positionOfSignature.y = positionOfSignature.y + signatures.name.height/2;
      positionOfSignature = CoordinateTransformation.localToScreen(positionOfSignature, new Point(0,0), 0);

      signatures.name.x = positionOfSignature.x;
      signatures.name.y = positionOfSignature.y;
    }

    public function set razmerValue(value:String)
    {
      params.value = value;
    }

    public function get razmerValue():String
    {
      return params.value;
    }


    public function set razmerName(value:String)
    {
      params.name = value;
      if(signatures.name == null)
      {
        signatures.name = new Designation(params.name, "Symbol1");
      }
      else
      {
        removeChild(signatures.name);
        signatures.name.destroy();
        signatures.name = new Designation(params.name, "Symbol1");
      }
      addChild(signatures.name);
    }

    public function get razmerName():String
    {
      return params.name;
    }

    override public function unlock()
    {
      button.hitTestState = button.upState;
      signatures.name.disable();
    }

  }
}
