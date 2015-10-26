package  pr1.opora
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.windows.EditWindowFixedJoint;
  import pr1.windows.EditWindow;
  import pr1.Shapes.Designation;
  import pr1.Shapes.AngleDimension;
  import pr1.ComConst;
  import pr1.CoordinateTransformation;
  import pr1.Shapes.FixedJoint;
  import flash.display.Shape;
  import pr1.Shapes.Arrow;
  import pr1.Shapes.Segment;
  import pr1.forces.Element;
  import pr1.Frame;
  import pr1.events.DialogEvent;


  public class FixedJointContainer extends Element
  {
    private var angleOfFixedJoint:Number;
    public var pointNumber:int;

    public function FixedJointContainer(frame:Frame, angle)
    {

      var upState:FixedJoint = new FixedJoint();
      upState.rotation = angle;
      upState.scaleX = 0.8;
      upState.scaleY = 0.8;
      var overState:FixedJoint = new FixedJoint(0xff);
      overState.scaleX = 0.8;
      overState.scaleY = 0.8;
      overState.rotation = angle;
      
      super(frame, upState, overState, upState, upState);

      var hArrow:Arrow = new Arrow(new Point(0,0), 0, new Point(5,0), false, 0xCC0000);
      var vArrow:Arrow = new Arrow(new Point(0,0), 0, new Point(0,-5), false, 0xCC0000);
      addChild(hArrow);
      addChild(vArrow);

      sigPoses.hReaction = new Point(50,0);
      sigPoses.vReaction = new Point(-0,-70);

    }

    private function onMouseClick(e:MouseEvent)
    {
      sigPoses.hReaction = new Point(signatures.hReaction.x, signatures.hReaction.y);
      sigPoses.vReaction = new Point(signatures.vReaction.x, signatures.vReaction.y);

      dialogWnd = new EditWindowFixedJoint(horisontalReaction, verticalReaction);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      parent1.addChild(dialogWnd);
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }
    
    override protected function changeValues(data:Object)
    {
      horisontalReaction = data.hReaction;
      verticalReaction   = data.vReaction;
      
      setCoordOfSignatures();
    }

    public function setCoordOfSignatures()
    {
      signatures.hReaction.x = sigPoses.hReaction.x;
      signatures.hReaction.y = sigPoses.hReaction.y;
      signatures.vReaction.x = sigPoses.vReaction.x;
      signatures.vReaction.y = sigPoses.vReaction.y;
    }

    public function set horisontalReaction(value:String)
    {
      params.hReaction = value;
      if(signatures.hReaction == null)
      {
        signatures.hReaction = new Designation(params.hReaction, "Times New Roman");
      }
      else
      {
        removeChild(signatures.hReaction);
        signatures.hReaction.destroy();
        signatures.hReaction = new Designation(params.hReaction, "Times New Roman");
      }
      addChild(signatures.hReaction);
    }

    public function get horisontalReaction():String
    {
      return params.hReaction;
    }

    public function set verticalReaction(value:String)
    {
      params.vReaction = value;
      if(signatures.vReaction == null)
      {
        signatures.vReaction = new Designation(params.vReaction, "Times New Roman");
      }
      else
      {
        removeChild(signatures.vReaction);
        signatures.vReaction.destroy();
        signatures.vReaction = new Designation(params.vReaction, "Times New Roman");
      }
      addChild(signatures.vReaction);
    }

    public function get verticalReaction():String
    {
      return params.vReaction;
    }
  }
}