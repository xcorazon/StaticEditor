package  pr1.razmers
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.windows.EditWindow4;
  import pr1.windows.EditWindow;
  import pr1.Shapes.Segment;
  import pr1.Shapes.Designation;
  import pr1.Shapes.LinearDimension;
  import pr1.ComConst;
  import pr1.CoordinateTransformation;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Matrix;
  import flash.text.Font;
  import pr1.Frame;
  import pr1.events.DialogEvent;
  import pr1.forces.Element;

  public class LinearDimensionYContainer extends Element
  {
    public static const FREE_DIMENSION:int = 0;
    public static const HORISONTAL_DIMENSION:int = 1;
    public static const VERTICAL_DIMENSION:int = 2;

    public var firstPointDecartCoord:Point;
    public var secondPointDecartCoord:Point;
    public var firstPointScreenCoord:Point;
    public var secondPointScreenCoord:Point;
    public var razmerHeight:Number;


    public function LinearDimensionYContainer(frame:Frame, upState:DisplayObject = null,
                 overState:DisplayObject = null,
                 downState:DisplayObject = null,
                 hitTestState:DisplayObject = null,
                 razmerName:String = null)
    {
      super(frame, upState, overState, downState, hitTestState);

      this.razmerName = razmerName;
      signatures.name.disable();
    }

    private function onMouseClick(e:MouseEvent)
    {
      sigPoses.name = new Point(signatures.name.x, signatures.name.y);

      dialogWnd = new EditWindow4(params.value, params.name);
      dialogWnd.units = params.units;
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      parent1.addChild(dialogWnd);
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }

    override protected function changeValues(data:Object)
    {
      razmerName  = data.name;
      razmerValue = data.value;
      units       = data.units;
    }

    public function setCoordOfRazmerName()
    {
      var angle = Math.PI/2;
      var width = secondPointDecartCoord.y - firstPointDecartCoord.y;
      var p1:Point = new Point();

      p1.x = (width - signatures.name.width)/2;
      p1.y = razmerHeight + (signatures.name.height - 5);
      p1 = CoordinateTransformation.localToScreen(p1, new Point(0,0), angle);
      signatures.name.rotation = -angle*180/Math.PI;
      
      signatures.name.x = p1.x;
      signatures.name.y = p1.y;
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
      var w:uint;
      var h:uint;
      var bmp1:BitmapData;

      var m:Matrix = new Matrix();
      m.scale(4, 4);

      params.name = value;
      if(signatures.name == null)
      {
        signatures.name = new Designation(params.name, timesFont.fontName/*"Times New Roman"*/);
      }
      else
      {
        removeChild(signatures.name);
        signatures.name = new Designation(params.name, timesFont.fontName/*"Times New Roman"*/);
      }

      addChild(signatures.name);

    }

    public function get razmerName():String
    {
      return params.name;
    }

    public function set units(dim:String)
    {
      params.units = dim;
    }

    public function get units():String
    {
      return params.units;
    }

    // горизонтальный, вертикальный, свободный размер
    public function get razmerType():int
    {
      return VERTICAL_DIMENSION;
    }

    override public function unlock()
    {
      button.hitTestState = button.upState;
      signatures.name.disable();
    }
  }
}
