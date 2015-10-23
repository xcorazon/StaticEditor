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
  import pr1.Frame;


  public class ConcentratedForce extends Element
  {

    public var anglePoints:Array;

    public function ConcentratedForce(frame:Frame, upState:DisplayObject = null,
                      overState:DisplayObject = null,
                      downState:DisplayObject = null,
                      hitTestState:DisplayObject = null,
                      forceName:String = null,
                      angleName:String = null)
    {
      super(frame, upState, overState, downState, hitTestState);

      this.forceName = forceName;
      this.angleName = angleName;
    }

    private function onMouseClick(e:MouseEvent)
    {
      dispatchEvent( new Event(ComConst.LOCK_ALL, true));
      sigPoses.force = new Point(signatures.force.x, signatures.force.y);
      sigPoses.angle = new Point(signatures.angle.x, signatures.angle.y);

      dialogWnd = new EditWindow3(forceValue, forceName, angleName, angleValue);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.units = units;
      parent1.addChild(dialogWnd);
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }

    
    override protected function changeValues(data:Object)
    {
      forceName  = data.forceName;
      forceValue = data.forceValue;
      angleName  = data.angleName;
      angleValue = data.angleValue;
      units      = data.units;
    }
    
    
    public function setCoordOfForceName(p:Point)
    {
      signatures.force.x = p.x;
      signatures.force.y = p.y;
      sigPoses.force = p.clone();
    }

    public function setCoordOfAngleName(p:Point)
    {
      signatures.angle.x = p.x;
      signatures.angle.y = p.y;
      sigPoses.angle = p.clone();
    }

    public function set forceValue(value:String)
    {
      params.forceValue = value;
    }

    public function get forceValue():String
    {
      return params.forceValue;
    }

    public function set angleValue(value:String)
    {
      params.angleValue = value;
    }

    public function get angleValue():String
    {
      return params.angleValue;
    }

    public function set forceName(value:String)
    {
      params.forceName = value;
      if(signatures.force == null)
      {
        signatures.force = new Designation(params.forceName, timesFont.fontName);
        addChild(signatures.force);
      }
      else
      {
        removeChild(signatures.force);
        signatures.force = new Designation(params.forceName, timesFont.fontName);
        addChild(signatures.force);
        signatures.force.x = sigPoses.force.x;
        signatures.force.y = sigPoses.force.y;
      }
    }

    public function get forceName():String
    {
      return params.forceName;
    }

    public function set angleName(value:String)
    {
      params.angleName = value;
      if(signatures.angle == null)
      {
        signatures.angle = new Designation(angleName, "Symbol1");
        addChild(signatures.angle);
      }
      else
      {
        removeChild(signatures.angle);
        signatures.angle = new Designation(angleName, "Symbol1");
        addChild(signatures.angle);
        signatures.angle.x = sigPoses.angle.x;
        signatures.angle.y = sigPoses.angle.y;
      }
    }

    public function get angleName():String
    {
      return params.angleName;
    }


    public function set units(dim:String)
    {
      params.units = dim;
    }

    public function get units():String
    {
      return params.units;
    }

    public function get angleSign():int
    {
      return params.angleSign;
    }

    public function set angleSign(sign:int)
    {
      params.angleSign = sign;
    }
    
    public function get forceNumber():int
    {
      return params.number;
    }
    
    public function set forceNumber(val:int)
    {
      params.number = val;
    }
  }
}