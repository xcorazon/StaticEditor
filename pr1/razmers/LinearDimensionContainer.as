﻿package  pr1.razmers
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

  public class LinearDimensionContainer extends Sprite
  {
    public static const FREE_DIMENSION:int = 0;
    public static const HORISONTAL_DIMENSION:int = 1;
    public static const VERTICAL_DIMENSION:int = 2;

    private var razmerName1:String;
    private var razmerValue1:String;
    private var dimension1:String;
    public var firstPointDecartCoord:Point;
    public var secondPointDecartCoord:Point;
    public var firstPointScreenCoord:Point;
    public var secondPointScreenCoord:Point;
    public var razmerHeight:Number;
    //public var firstPointNumber:int;
    //public var secondPointNumber:int;

    private var button:SimpleButton;
    private var dialogWnd:EditWindow4;

    private var razmerSignature:Designation = null;
    private var razmerSignatureCoord:Point;
    private var razmerSignatureAngle:Number;
    private var parent1:*;

    public var mustBeDeleted:Boolean = false;

    public function LinearDimensionContainer(parent:*,upState:DisplayObject = null,
                 overState:DisplayObject = null,
                 downState:DisplayObject = null,
                 hitTestState:DisplayObject = null,
                 razmerName:String = null)
    {
      super();
      parent1 = parent;
      button = new SimpleButton(upState, overState, downState, hitTestState);
      addChild(button);
      this.razmerName = razmerName;
      razmerSignature.disable();

      button.addEventListener(MouseEvent.CLICK, onMouseClick);
    }

    private function onMouseClick(e:MouseEvent)
    {
      razmerSignatureCoord = new Point(razmerSignature.x, razmerSignature.y);

      dialogWnd = new EditWindow4(razmerValue1, razmerName1);
      dialogWnd.dimension = dimension1;
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      parent1.addChild(dialogWnd);
      dialogWnd.addEventListener(EditWindow.END_EDIT, onEndDialog);
      dialogWnd.addEventListener(EditWindow.CANCEL_EDIT, onCancelDialog);
    }

    private function onEndDialog(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndDialog);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelDialog);

      parent1.removeChild(dialogWnd);
      razmerName = dialogWnd.razmer;
      razmerValue = dialogWnd.value;
      dimension = dialogWnd.dimension;
      setCoordOfRazmerName();
      dialogWnd = null;
      dispatchEvent(new Event(ComConst.CHANGE_ELEMENT, true));
    }

    private function onCancelDialog(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndDialog);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelDialog);

      parent1.removeChild(dialogWnd);
      dialogWnd = null;
      mustBeDeleted = true;
      dispatchEvent(new Event(ComConst.DELETE_ELEMENT, true));
    }


    public function setCoordOfRazmerName()
    {
      var width:Number = Point.distance(secondPointDecartCoord, firstPointDecartCoord);
      var p:Point = secondPointDecartCoord.subtract(firstPointDecartCoord);
      var angle = CoordinateTransformation.decartToPolar(p).y;
      var sign:int = 1;
      var p1:Point = new Point();


      if(angle > -Math.PI/2 && angle <= Math.PI/2)
      {
        p1.x = (width - razmerSignature.width)/2;
        p1.y = razmerHeight + (razmerSignature.height - 5);
        p1 = CoordinateTransformation.localToScreen(p1, new Point(0,0), angle);
        razmerSignature.rotation = -angle*180/Math.PI;
      }
      else if(angle > Math.PI/2 || angle <= -Math.PI/2)
      {
        p1.x = (width + razmerSignature.width)/2;
        p1.y = razmerHeight - (razmerSignature.height - 5);
        p1 = CoordinateTransformation.localToScreen(p1, new Point(0,0), angle);
        razmerSignature.rotation = 180 - angle*180/Math.PI;
      }
      razmerSignature.x = p1.x;
      razmerSignature.y = p1.y;
    }

    public function set razmerValue(value:String)
    {
      razmerValue1 = value;
    }

    public function get razmerValue():String
    {
      return razmerValue1;
    }


    public function set razmerName(value:String)
    {
      var w:uint;
      var h:uint;
      var bmp1:BitmapData;

      var m:Matrix = new Matrix();
      m.scale(4, 4);

      razmerName1 = value;
      if(razmerSignature == null)
      {
        razmerSignature = new Designation(razmerName1, "Times New Roman");
      }
      else
      {
        removeChild(razmerSignature);
        razmerSignature = new Designation(razmerName1, "Times New Roman");
      }

      addChild(razmerSignature);
      razmerSignature.disable();
    }

    public function get razmerName():String
    {
      return razmerName1;
    }


    public function set dimension(dim:String)
    {
      dimension1 = dim;
    }

    public function get dimension():String
    {
      return dimension1;
    }

    // горизонтальный, вертикальный, свободный размер
    public function get razmerType():int
    {
      var p:Point = secondPointDecartCoord.subtract(firstPointDecartCoord);
      var angle = CoordinateTransformation.decartToPolar(p).y;

      if(angle == Math.PI/2 || angle == -Math.PI/2)
      {
        return VERTICAL_DIMENSION;
      }
      if(angle == Math.PI || angle == -Math.PI || angle == 0)
      {
        return HORISONTAL_DIMENSION;
      }
      return FREE_DIMENSION;
    }

    public function lock()
    {
      button.hitTestState = null;
      razmerSignature.disable();
    }

    public function unlock()
    {
      button.hitTestState = button.upState;
      razmerSignature.disable();
    }

    public function destroy()
    {
      button.removeEventListener(MouseEvent.CLICK, onMouseClick);
      razmerSignature.destroy();
    }
  }
}
