package  pr1.forces
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.windows.EditWindow3;
  import pr1.windows.EditWindow;
  import pr1.Shapes.Segment;
  import pr1.Shapes.Designation;
  import pr1.ComConst;
  import flash.text.Font;


  public class ConcentratedForce extends Sprite
  {

    public var anglePoints:Array;
    private var angleSign1:int; // в локальной системе координат угол положительный или отрицательный
    private var ownerSegmentOfForce:Segment;
    private var forceName1:String;
    private var forceValue1:String;
    private var angleName1:String;
    private var angleValue1:String;
    private var dimension1:String;
    public  var forceNumber:int;

    private var button:SimpleButton;
    private var dialogWnd:EditWindow3;

    private var forceSignature:Designation = null;
    private var angleSignature:Designation = null;
    private var forceSignatureCoord:Point;
    private var angleSignatureCoord:Point;
    private var parent1:*;
    private var timesFont:Font;
    private var symFont:Font;

    public function ConcentratedForce(parent:*, upState:DisplayObject = null,
                      overState:DisplayObject = null,
                      downState:DisplayObject = null,
                      hitTestState:DisplayObject = null,
                      forceName:String = null,
                      angleName:String = null)
    {
      // constructor code
      super();
      timesFont = new Times1();
      //symFont = new Symbol1();
      parent1 = parent;
      button = new SimpleButton(upState, overState, downState, hitTestState);
      addChild(button);
      this.forceName = forceName;
      this.angleName = angleName;

      button.addEventListener(MouseEvent.CLICK, onMouseClick);
    }

    private function onMouseClick(e:MouseEvent)
    {
      dispatchEvent( new Event(ComConst.LOCK_ALL, true));
      forceSignatureCoord = new Point(forceSignature.x, forceSignature.y);
      angleSignatureCoord = new Point(angleSignature.x, angleSignature.y);

      dialogWnd = new EditWindow3(forceValue1, forceName1, angleName1, angleValue1);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.units = dimension1;
      parent1.addChild(dialogWnd);
      dialogWnd.addEventListener(EditWindow.END_EDIT, onEndDialog);
      dialogWnd.addEventListener(EditWindow.CANCEL_EDIT, onCancelDialog);
    }

    private function onEndDialog(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndDialog);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelDialog);

      parent1.removeChild(dialogWnd);
      forceName = dialogWnd.force;
      forceValue = dialogWnd.value;
      angleName = dialogWnd.angleName;
      angleValue = dialogWnd.angle;
      dimension = dialogWnd.dimension;
      dialogWnd = null;
      dispatchEvent(new Event(ComConst.CHANGE_ELEMENT, true));
    }

    private function onCancelDialog(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndDialog);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelDialog);

      parent1.removeChild(dialogWnd);
      dialogWnd = null;
      dispatchEvent(new Event(ComConst.DELETE_ELEMENT, true));
    }

    public function setCoordOfForceName(p:Point)
    {
      forceSignature.x = p.x;
      forceSignature.y = p.y;
      forceSignatureCoord = p.clone();
    }

    public function setCoordOfAngleName(p:Point)
    {
      angleSignature.x = p.x;
      angleSignature.y = p.y;
      angleSignatureCoord = p.clone();
    }

    public function set forceValue(value:String)
    {
      forceValue1 = value;
    }

    public function get forceValue():String
    {
      return forceValue1;
    }

    public function set angleValue(value:String)
    {
      angleValue1 = value;
    }

    public function get angleValue():String
    {
      return angleValue1;
    }

    public function set forceName(value:String)
    {
      forceName1 = value;
      if(forceSignature == null)
      {
        forceSignature = new Designation(forceName1, timesFont.fontName/*"Times New Roman"*/);
        addChild(forceSignature);
      }
      else
      {
        removeChild(forceSignature);
        forceSignature = new Designation(forceName1, timesFont.fontName/*"Times New Roman"*/);
        addChild(forceSignature);
        forceSignature.x = forceSignatureCoord.x;
        forceSignature.y = forceSignatureCoord.y;
      }
    }

    public function get forceName():String
    {
      return forceName1;
    }

    public function set angleName(value:String)
    {
      angleName1 = value;
      if(angleSignature == null)
      {
        angleSignature = new Designation(angleName1, "Symbol1"/*symFont.fontName"Symbol"*/);
        addChild(angleSignature);
      }
      else
      {
        removeChild(angleSignature);
        angleSignature = new Designation(angleName1, "Symbol1"/*symFont.fontName/*"Symbol"*/);
        addChild(angleSignature);
        angleSignature.x = angleSignatureCoord.x;
        angleSignature.y = angleSignatureCoord.y;
      }
    }

    public function get angleName():String
    {
      return angleName1;
    }

    public function set segment(seg:Segment)
    {
      ownerSegmentOfForce = seg;
    }

    public function get segment():Segment
    {
      return ownerSegmentOfForce;
    }

    public function set dimension(dim:String)
    {
      dimension1 = dim;
    }

    public function get dimension():String
    {
      return dimension1;
    }

    public function get angleSign():int
    {
      return angleSign1;
    }

    public function set angleSign(sign:int)
    {
      this.angleSign1 = sign;
    }

    public function lock()
    {
      button.hitTestState = null;
      forceSignature.disable();
      angleSignature.disable();
    }

    public function unlock()
    {
      button.hitTestState = button.upState;
      forceSignature.enable();
      angleSignature.enable();
    }

    public function destroy()
    {
      button.removeEventListener(MouseEvent.CLICK, onMouseClick);
      forceSignature.destroy();
      angleSignature.destroy();
    }
  }
}