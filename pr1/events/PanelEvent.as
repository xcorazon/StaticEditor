package pr1.events
{
  import flash.events.*;

  public class PanelEvent extends Event
  {
  
    public var object:*;


    public function PanelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, object:* = null)
    {
      super(type, bubbles, cancelable);
      this.object = object;
    }


    public override function clone():Event {
      return new PanelEvent(type, bubbles, cancelable, object);
    }


    public override function toString( ):String
    {
      return formatToString ("DialogEvent", "type", "bubbles", "cancelable", "eventPhase", "object");
    }

  }
}