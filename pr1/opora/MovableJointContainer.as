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


  public class MovableJointContainer extends Sprite
  {

    public var angleOfMovableJoint:Number;
    public var angleOfAxis:Number;
    public var firstPointOfAngle:int;
    public var secondPointOfAngle:int;
    public var thirdPointOfAngle:int;

    public var pointNumber:int;

    public var isAnglePresent:Boolean = false;
    private var reaction1:String;
    private var angle1:String = "";
    private var angleValue1:String;
    private var angleSign1:int;
    public var segment:Segment;

    private var button:SimpleButton;
    private var dialogWnd:*;

    private var reactionSignature:Designation = null;
    private var signatureCoord:Point = null;
    private var angleSignature:Designation = null;
    private var angleSignatureCoord:Point = null;

    private var parent1:*;

    public var mustBeDeleted:Boolean = false;

    public function MovableJointContainer(parent:*, upState, overState, downState, hitTestState, arrow)
    {
      super();
      parent1 = parent;
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
      button = new SimpleButton(upState, overState, upState, upState);
      addChild(button);
      addChild(arrow);

      signatureCoord = new Point(50,0);
      angleSignatureCoord = new Point(-0,-70);

      button.addEventListener(MouseEvent.CLICK, onMouseClick);
    }

    private function onMouseClick(e:MouseEvent)
    {
      signatureCoord = new Point(reactionSignature.x, reactionSignature.y);

      if(this.isAnglePresent)
      {
        angleSignatureCoord = new Point(angleSignature.x, angleSignature.y);
        dialogWnd = new EditWindowMovableJoint1(reaction, angle, angleValue);
      }
      else
      {
        dialogWnd = new EditWindowMovableJoint2(reaction);
      }

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
      reaction = dialogWnd.reaction;
      if(this.isAnglePresent)
      {
        angle = dialogWnd.angleName;
        angleValue = dialogWnd.angleValue;
      }
      setCoordOfSignatures();
      dialogWnd = null;
      dispatchEvent(new EditEvent(ComConst.CHANGE_ELEMENT, true));
    }

    private function onCancelDialog(e:Event)
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndDialog);
      dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelDialog);

      parent1.removeChild(dialogWnd);
      dialogWnd = null;
      mustBeDeleted = true;
      dispatchEvent(new EditEvent(ComConst.DELETE_ELEMENT, true));
    }


    public function setCoordOfSignatures()
    {
      var R:Number = 80;
      var angle:Number = angleOfAxis + angleSign * angleOfMovableJoint;
      var p:Point = CoordinateTransformation.rotate(new Point(R,0), angle);
      p = CoordinateTransformation.localToScreen(p, new Point(0,0), 0);
      p.x = p.x - reactionSignature.width/2;
      p.y = p.y - reactionSignature.height/2;

      reactionSignature.x = p.x;
      reactionSignature.y = p.y;
      if(this.isAnglePresent)
      {
        angle = angleOfAxis + angleSign * angleOfMovableJoint/2;
        R = 40;
        p = CoordinateTransformation.rotate(new Point(R,0), angle);
        p = CoordinateTransformation.localToScreen(p, new Point(0,0), 0);
        p.x = p.x - angleSignature.width/2;
        p.y = p.y - angleSignature.height/2;

        angleSignature.x = p.x;
        angleSignature.y = p.y;
      }
    }

    public function set reaction(value:String)
    {
      reaction1 = value;
      if(reactionSignature == null)
      {
        reactionSignature = new Designation(reaction1, "Times New Roman");
      }
      else
      {
        removeChild(reactionSignature);
        reactionSignature.destroy();
        reactionSignature = new Designation(reaction1, "Times New Roman");
      }
      addChild(reactionSignature);
    }

    public function get reaction():String
    {
      return reaction1;
    }

    public function set angle(value:String)
    {
      angle1 = value;
      if(angleSignature == null)
      {
        angleSignature = new Designation(angle1, "Symbol1");
      }
      else
      {
        removeChild(angleSignature);
        angleSignature.destroy();
        angleSignature = new Designation(angle1, "Symbol1");
      }
      addChild(angleSignature);
    }

    public function get angle():String
    {
      return angle1;
    }

    public function set angleValue(value:String)
    {
      angleValue1 = value;
    }

    public function get angleValue():String
    {
      return angleValue1;
    }

    public function set angleSign(value:int)
    {
      angleSign1 = value;
    }

    public function get angleSign():int
    {
      return angleSign1;
    }

    public function lock()
    {
      button.hitTestState = null;
      reactionSignature.disable();
      if(angleSignature != null)
        angleSignature.disable();
    }

    public function unlock()
    {
      button.hitTestState = button.upState;
      reactionSignature.enable();
      if(angleSignature != null)
        angleSignature.enable();
    }

    public function destroy()
    {
      button.removeEventListener(MouseEvent.CLICK, onMouseClick);
      if(angleSignature != null)
        angleSignature.destroy();

      reactionSignature.destroy();
    }
  }
}