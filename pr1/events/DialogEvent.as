package pr1.events
{
  import flash.events.*;

  public class DialogEvent extends Event
  {
    public static const END_DIALOG:String = "End dialog";

    public var eventData:Object;
    public var canceled:Boolean;


    public function DialogEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:Object = null)
    {
      super(type, bubbles, cancelable);
      this.eventData = data;
      canceled = false;
    }


    public override function clone( ):Event {
      return new DialogEvent(type, bubbles, cancelable, eventData);
    }


    public override function toString( ):String
    {
      return formatToString ("DialogEvent", "type", "bubbles", "cancelable", "eventPhase", "eventData", "canceled");
    }

  }
}