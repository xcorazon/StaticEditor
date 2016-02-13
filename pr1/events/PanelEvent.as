package pr1.events
{
  import flash.events.*;

  public class PanelEvent extends Event
  {
  
    public var object:*;
    public var button:*;


    public function PanelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, object:* = null, button:* = null)
    {
      super(type, bubbles, cancelable);
      this.object = object;
      this.button = button;
    }


    public override function clone():Event {
      return new PanelEvent(type, bubbles, cancelable, object, button);
    }


    public override function toString( ):String
    {
      return formatToString ("DialogEvent", "type", "bubbles", "cancelable", "eventPhase", "object", "button");
    }

  }
}