package  pr1.opora
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.windows.EditWindowSealing;
  import pr1.windows.EditWindow;
  import pr1.Shapes.Designation;
  import pr1.Shapes.AngleDimension;
  import pr1.ComConst;
  import pr1.CoordinateTransformation;
  import pr1.Shapes.Sealing;
  import flash.display.Shape;
  import pr1.Shapes.Arrow;
  import pr1.Shapes.ArcArrow;
  import pr1.Shapes.Segment;


  public class SealingContainer extends Sprite
  {

    private var angleOfSealing:Number;
    public var pointNumber:int;
    public var segment:Segment;
    private var horisontalReaction1:String;
    private var verticalReaction1:String;
    private var moment1:String;

    private var button:SimpleButton;
    private var dialogWnd:EditWindowSealing;

    private var hReactionSignature:Designation = null;
    private var hSignatureCoord:Point = null;
    private var vReactionSignature:Designation = null;
    private var vSignatureCoord:Point = null;
    private var momentSignature:Designation = null;
    private var momentCoord:Point = null;
    private var parent1:*;
    private var tempHitTestState:Shape;

    public var mustBeDeleted:Boolean = false;

    public function SealingContainer(parent:*, angle)
    {
      super();
      parent1 = parent;
      var upState:Sealing = new Sealing();
      upState.rotation = angle;
      var overState:Sealing = new Sealing(0xff);
      overState.rotation = angle;
      var hitTestState:Shape = new Shape();
      hitTestState.graphics.beginFill(0xffffff);
      hitTestState.graphics.drawRect(-10,-40,10,80);
      hitTestState.graphics.endFill();
      hitTestState.rotation = angle;
      tempHitTestState = hitTestState;
      button = new SimpleButton(upState, overState, upState, hitTestState);
      addChild(button);

      var hArrow:Arrow = new Arrow(new Point(0,0), 0, new Point(5,0), false, 0xCC0000);
      var vArrow:Arrow = new Arrow(new Point(0,0), 0, new Point(0,-5), false, 0xCC0000);
      var moment:ArcArrow = new ArcArrow(new Point(0,0), new Point(-30,40), false, 0xcc0000);
      addChild(hArrow);
      addChild(vArrow);
      addChild(moment);

      hSignatureCoord = new Point(50,0);
      vSignatureCoord = new Point(-0,-70);
      momentCoord = new Point(-35, 35);


      button.addEventListener(MouseEvent.CLICK, onMouseClick);
    }

    private function onMouseClick(e:MouseEvent)
    {
      hSignatureCoord = new Point(hReactionSignature.x, hReactionSignature.y);
      vSignatureCoord = new Point(vReactionSignature.x, vReactionSignature.y);
      momentCoord = new Point(momentSignature.x, momentSignature.y);

      dialogWnd = new EditWindowSealing(horisontalReaction, verticalReaction, moment);
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
      horisontalReaction = dialogWnd.horizontalReaction;
      verticalReaction = dialogWnd.verticalReaction;
      moment = dialogWnd.moment;

      setCoordOfSignatures();
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


    public function setCoordOfSignatures()
    {
      hReactionSignature.x = hSignatureCoord.x;
      hReactionSignature.y = hSignatureCoord.y;
      vReactionSignature.x = vSignatureCoord.x;
      vReactionSignature.y = vSignatureCoord.y;
      momentSignature.x = momentCoord.x;
      momentSignature.y = momentCoord.y;
    }

    public function set horisontalReaction(value:String)
    {
      horisontalReaction1 = value;
      if(hReactionSignature == null)
      {
        hReactionSignature = new Designation(horisontalReaction1, "Times New Roman");
      }
      else
      {
        removeChild(hReactionSignature);
        hReactionSignature.destroy();
        hReactionSignature = new Designation(horisontalReaction1, "Times New Roman");
      }
      addChild(hReactionSignature);
    }

    public function get horisontalReaction():String
    {
      return horisontalReaction1;
    }

    public function set verticalReaction(value:String)
    {
      verticalReaction1 = value;
      if(vReactionSignature == null)
      {
        vReactionSignature = new Designation(verticalReaction1, "Times New Roman");
      }
      else
      {
        removeChild(vReactionSignature);
        vReactionSignature.destroy();
        vReactionSignature = new Designation(verticalReaction1, "Times New Roman");
      }
      addChild(vReactionSignature);
    }

    public function get verticalReaction():String
    {
      return verticalReaction1;
    }

    public function set moment(value:String)
    {
      moment1 = value;
      if(momentSignature == null)
      {
        momentSignature = new Designation(moment1, "Times New Roman");
      }
      else
      {
        removeChild(momentSignature);
        momentSignature.destroy();
        momentSignature = new Designation(moment1, "Times New Roman");
      }
      addChild(momentSignature);
    }

    public function get moment():String
    {
      return moment1;
    }

    public function lock()
    {
      button.hitTestState = null;
      momentSignature.disable();
      vReactionSignature.disable();
      hReactionSignature.disable();
    }

    public function unlock()
    {
      button.hitTestState = tempHitTestState;
      momentSignature.enable();
      vReactionSignature.enable();
      hReactionSignature.enable();
    }

    public function destroy()
    {
      button.removeEventListener(MouseEvent.CLICK, onMouseClick);
      vReactionSignature.destroy();
      hReactionSignature.destroy();
      momentSignature.destroy();
    }
  }
}