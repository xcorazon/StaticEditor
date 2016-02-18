package  pr1.forces
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import pr1.Shapes.Segment;
  import pr1.windows.EditWindowQ;
  import pr1.windows.EditWindow;
  import pr1.Shapes.Designation;
  import pr1.ComConst;
  import flash.text.Font;
  import pr1.Frame;
  import pr1.events.DialogEvent;
  import pr1.forces.Element;
  import pr1.CoordinateTransformation;


  public class DistributedForceR extends Element
  {
    public var forceNumber1:int;
    public var forceNumber2:int;
    public var arrowsHeight:int;
    public var arrowsLength:int;
    public var angleOfAxis:Number;

    public function DistributedForceR(frame:Frame, upState:DisplayObject = null,
                 overState:DisplayObject = null,
                 downState:DisplayObject = null,
                 hitTestState:DisplayObject = null,
                 forceName:String = null)
    {
      super(frame, upState, overState, downState, hitTestState);

      this.forceName = forceName;
      firstScreenCoord = new Point(0,0);
      secondScreenCoord = new Point(0,0);
    }

    override protected function onMouseClick(e:MouseEvent)
    {
      dispatchEvent( new Event(ComConst.LOCK_ALL, true));
      sigPoses.name = new Point(signatures.name.x, signatures.name.y);

      dialogWnd = new EditWindowQ(params.value, params.name);
      dialogWnd.units = params.units;
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      parent1.addChild(dialogWnd);
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }
    
    public function setCoordOfSignatures()
    {
      var sign = arrowsHeight >= 0 ? 1 : -1;
      var height = Math.max(Math.abs(arrowsHeight), 26) + 10;
      var p:Point = new Point(arrowsLength/2, sign * height);
      p = CoordinateTransformation.rotate(p, angleOfAxis);
      p.y *= -1;
      p.x = p.x - signatures.name.width/2;
      p.y = p.y - signatures.name.height/2;
      setCoordOfForceName(p);
    }

    override protected function changeValues(data:Object)
    {
      forceName  = data.forceName;
      forceValue = data.forceValue;
      units      = data.units;
    }

    public function setCoordOfForceName(p:Point)
    {
      signatures.name.x = p.x;
      signatures.name.y = p.y;
      sigPoses.name = p.clone();
    }

    public function set forceValue(value:String)
    {
      params.value = value;
    }

    public function get forceValue():String
    {
      return params.value;
    }

    public function set forceName(value:String)
    {
      params.name = value;
      if(signatures.name == null)
      {
        signatures.name = new Designation(params.name, timesFont.fontName/*"Times New Roman"*/);
        addChild(signatures.name);
      }
      else
      {
        removeChild(signatures.name);
        signatures.name = new Designation(params.name, timesFont.fontName/*"Times New Roman"*/);
        addChild(signatures.name);
        signatures.name.x = sigPoses.name.x;
        signatures.name.y = sigPoses.name.y;
      }
    }

    public function get forceName():String
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

    public function set firstScreenCoord(p:Point)
    {
      params.firstScrPt = p.clone();
    }

    public function get firstScreenCoord():Point
    {
      return params.firstScrPt.clone();
    }

    public function set secondScreenCoord(p:Point)
    {
      params.secondScrPt = p.clone();
    }

    public function get secondScreenCoord():Point
    {
      return params.secondScrPt.clone();
    }

    public function get angleValue():String
    {
      return params.angle;
    }

    public function set angleValue(angle:String)
    {
      params.angle = angle;
    }
  }
}