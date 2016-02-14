package  pr1.opora
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.windows.EditWindowMovableJoint1;
  import pr1.windows.EditWindowMovableJoint2;
  import pr1.windows.EditWindow;
  import pr1.Shapes.Designation;
  import pr1.Shapes.AngleDimension;
  import pr1.ComConst;
  import pr1.CoordinateTransformation;
  import pr1.Shapes.MovableJoint;
  import flash.display.Shape;
  import pr1.Shapes.Arrow;
  import pr1.Shapes.Segment;
  import pr1.EditEvent;
  import pr1.forces.Element;
  import pr1.events.DialogEvent;


  public class MovableJointContainer extends Element
  {

    public var angleOfMovableJoint:Number;
    public var angleOfAxis:Number;
    public var firstPointOfAngle:int;
    public var secondPointOfAngle:int;
    public var thirdPointOfAngle:int;

    public var pointNumber:int;

    public var isAnglePresent:Boolean = false;

    public function MovableJointContainer(parent:*, upState, overState, downState, hitTestState, arrow)
    {
      super(parent, upState, overState, downState, hitTestState);
      upState.x = 0;
      upState.y = 0;
      overState.x = 0;
      overState.y = 0;
      downState.x = 0;
      downState.y = 0;
      hitTestState.x = 0;
      hitTestState.y = 0;
      arrow.x = 0;
      arrow.y = 0;
      addChild(arrow);

      sigPoses.reaction = new Point(50,0);
      sigPoses.angle = new Point(-0,-70);
    }

    override protected function onMouseClick(e:MouseEvent)
    {
      sigPoses.reaction = new Point(signatures.reaction.x, signatures.reaction.y);

      if(this.isAnglePresent)
      {
        sigPoses.angle = new Point(signatures.angle.x, signatures.angle.y);
        dialogWnd = new EditWindowMovableJoint1(reaction, angle, angleValue);
      }
      else
      {
        dialogWnd = new EditWindowMovableJoint2(reaction);
      }

      dialogWnd.x = 400;
      dialogWnd.y = 300;
      parent1.addChild(dialogWnd);
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }

    override protected function changeValues(data:Object)
    {
      reaction    = data.reaction;
      angle       = data.angle;
      angleValue  = data.angleValue;
      
      setCoordOfSignatures();
    }

    public function setCoordOfSignatures()
    {
      var R:Number = 80;
      var angle:Number = angleOfAxis + angleSign * angleOfMovableJoint;
      var p:Point = CoordinateTransformation.rotate(new Point(R,0), angle);
      p = CoordinateTransformation.localToScreen(p, new Point(0,0), 0);
      p.x = p.x - signatures.reaction.width/2;
      p.y = p.y - signatures.reaction.height/2;

      signatures.reaction.x = p.x;
      signatures.reaction.y = p.y;
      if(this.isAnglePresent)
      {
        angle = angleOfAxis + angleSign * angleOfMovableJoint/2;
        R = 40;
        p = CoordinateTransformation.rotate(new Point(R,0), angle);
        p = CoordinateTransformation.localToScreen(p, new Point(0,0), 0);
        p.x = p.x - signatures.angle.width/2;
        p.y = p.y - signatures.angle.height/2;

        signatures.angle.x = p.x;
        signatures.angle.y = p.y;
      }
    }

    public function set reaction(value:String)
    {
      params.reaction = value;
      if(signatures.reaction == null)
      {
        signatures.reaction = new Designation(params.reaction, "Times New Roman");
      }
      else
      {
        removeChild(signatures.reaction);
        signatures.reaction.destroy();
        signatures.reaction = new Designation(params.reaction, "Times New Roman");
      }
      addChild(signatures.reaction);
    }

    public function get reaction():String
    {
      return params.reaction;
    }

    public function set angle(value:String)
    {
      params.angle = value;
      if(signatures.angle == null)
      {
        signatures.angle = new Designation(params.angle, "Symbol1");
      }
      else
      {
        removeChild(signatures.angle);
        signatures.angle.destroy();
        signatures.angle = new Designation(params.angle, "Symbol1");
      }
      addChild(signatures.angle);
    }

    public function get angle():String
    {
      return params.angle;
    }

    public function set angleValue(value:String)
    {
      params.angleValue = value;
    }

    public function get angleValue():String
    {
      return params.angleValue;
    }

    public function set angleSign(value:int)
    {
      params.angleSign = value;
    }

    public function get angleSign():int
    {
      return params.angleSign;
    }
  }
}