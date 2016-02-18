package  pr1.forces
{
  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;

  import pr1.events.DialogEvent;

  import pr1.windows.EditWindowMoment;
  import pr1.Shapes.Segment;
  import pr1.Shapes.Designation;
  import pr1.ComConst;
  import pr1.Frame;

  public class Moment extends Element
  {

    public var arrowAngle:Number;
    
    public function Moment(frame:Frame, upState:DisplayObject = null,
                 overState:DisplayObject = null,
                 downState:DisplayObject = null,
                 hitTestState:DisplayObject = null,
                 momentName:String = null)
    {
      super(frame, upState, overState, downState, hitTestState);
      
      momentName = momentName;
      isClockWise = false;
    }

    override protected function onMouseClick(e:MouseEvent)
    {
      dispatchEvent( new Event(ComConst.LOCK_ALL, true));
      sigPoses.moment = new Point(signatures.moment.x, signatures.moment.y);

      initDialog();
    }

    
    private function initDialog()
    {
      dialogWnd = new EditWindowMoment(momentValue, momentName);
      dialogWnd.units = units;
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      parent1.addChild(dialogWnd);
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }


    override protected function changeValues(data:Object)
    {
      momentName = data.forceName;
      momentValue = data.forceValue;
      units = data.units;
    }

    public function set isClockWise(b:Boolean)
    {
      params.clockWise = b;
    }
    
    public function get isClockWise():Boolean
    {
      return params.clockWise;
    }
    
    public function setCoordOfSignatures()
    {
      var sign = isClockWise ? -1:1;
      var delta:Number = sign * 15 * Math.PI/180;
      var p:Point = Point.polar(40, arrowAngle + delta);
      p.y *= -1;
      
      p.x = p.x - signatures.moment.width/2;
      p.y = p.y - signatures.moment.height/2;
      setCoordOfMomentName(p);
    }
    
    public function setCoordOfMomentName(p:Point)
    {
      signatures.moment.x = p.x;
      signatures.moment.y = p.y;
      sigPoses.moment = p.clone();
    }

    public function set momentValue(value:String)
    {
      params.momentValue = value;
    }

    public function get momentValue():String
    {
      return params.momentValue;
    }

    public function set momentName(value:String)
    {
      params.momentName = value;
      if(signatures.moment == null)
      {
        signatures.moment = new Designation(params.momentName, timesFont.fontName);
        addChild(signatures.moment);
      }
      else
      {
        removeChild(signatures.moment);
        signatures.moment = new Designation(params.momentName, timesFont.fontName);
        addChild(signatures.moment);
        signatures.moment.x = sigPoses.moment.x;
        signatures.moment.y = sigPoses.moment.y;
      }
    }

    public function get momentName():String
    {
      return params.momentName;
    }


    public function set units(val:String)
    {
      params.units = val;
    }

    public function get units():String
    {
      return params.units;
    }
    
    public function get momentNumber():int
    {
      return params.number;
    }
    
    public function set momentNumber(val:int)
    {
      params.number = val;
    }
  }
}