package  pr1.forces
{
  import flash.display.SimpleButton;
  import flash.display.Sprite;
  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;

  import pr1.events.DialogEvent;

  import pr1.windows.EditWindowMoment;
  import pr1.windows.EditWindow;
  import pr1.Shapes.Segment;
  import pr1.Shapes.Designation;
  import pr1.ComConst;
  import flash.text.Font;

  public class Moment extends Sprite
  {

    private var clockWise:Boolean;
    private var ownerSegmentOfForce:Segment;
    private var momentName1:String;
    private var momentValue1:String;
    private var _units:String;
    public var momentNumber:int;

    private var button:SimpleButton;
    private var dialogWnd:EditWindowMoment;

    private var momentSignature:Designation = null;
    private var momentSignatureCoord:Point;
    private var parent1:*;
    private var timesFont:Font;


    public var mustBeDeleted:Boolean = false;

    public function Moment(parent:*,upState:DisplayObject = null,
                 overState:DisplayObject = null,
                 downState:DisplayObject = null,
                 hitTestState:DisplayObject = null,
                 momentName:String = null)
    {
      super();
      parent1 = parent;
      timesFont = new Times1();
      button = new SimpleButton(upState, overState, downState, hitTestState);
      addChild(button);
      this.momentName = momentName;

      button.addEventListener(MouseEvent.CLICK, onMouseClick);
    }

    private function onMouseClick(e:MouseEvent)
    {
      dispatchEvent( new Event(ComConst.LOCK_ALL, true));
      momentSignatureCoord = new Point(momentSignature.x, momentSignature.y);

      initDialog();
    }

    private function onEndDialog(e:DialogEvent)
    {
      releaseDialog();

      if(e.canceled)
        deleteElement();
      else
        createMoment(e.eventData);

      dispatchEvent(new Event(ComConst.CHANGE_ELEMENT, true));
    }

    private function initDialog()
    {
      dialogWnd = new EditWindowMoment(momentValue1, momentName1);
      dialogWnd.units = units;
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      parent1.addChild(dialogWnd);
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }

    private function releaseDialog()
    {
      dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndDialog);

      parent1.removeChild(dialogWnd);
      dialogWnd = null;
    }

    private function changeValues(data:Object)
    {
      momentName = data.forceName;
      momentValue = data.forceValue;
      units = data.units;
    }

    private function deleteElement()
    {
      mustBeDeleted = true;
      dispatchEvent(new Event(ComConst.DELETE_ELEMENT, true));
    }

    public function set isClockWise(b:Boolean)
    {
      clockWise = b;
    }
    public function get isClockWise():Boolean
    {
      return this.clockWise;
    }
    public function setCoordOfMomentName(p:Point)
    {
      momentSignature.x = p.x;
      momentSignature.y = p.y;
      momentSignatureCoord = p.clone();
    }

    public function set momentValue(value:String)
    {
      momentValue1 = value;
    }

    public function get momentValue():String
    {
      return momentValue1;
    }


    public function set momentName(value:String)
    {
      momentName1 = value;
      if(momentSignature == null)
      {
        momentSignature = new Designation(momentName1, timesFont.fontName);
        addChild(momentSignature);
      }
      else
      {
        removeChild(momentSignature);
        momentSignature = new Designation(momentName1, timesFont.fontName /*"Times New Roman"*/);
        addChild(momentSignature);
        momentSignature.x = momentSignatureCoord.x;
        momentSignature.y = momentSignatureCoord.y;
      }
    }

    public function get momentName():String
    {
      return momentName1;
    }

    public function set segment(seg:Segment)
    {
      ownerSegmentOfForce = seg;
    }

    public function get segment():Segment
    {
      return ownerSegmentOfForce;
    }

    public function set units(val:String)
    {
      _units = val;
    }

    public function get units():String
    {
      return _units;
    }

    public function lock()
    {
      button.hitTestState = null;
      momentSignature.disable();
    }

    public function unlock()
    {
      button.hitTestState = button.upState;
      momentSignature.enable();
    }

    public function destroy()
    {
      button.removeEventListener(MouseEvent.CLICK, onMouseClick);
      momentSignature.destroy();
    }
  }
}