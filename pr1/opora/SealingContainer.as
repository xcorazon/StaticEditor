package  pr1.opora
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import pr1.windows.EditWindowSealing;
  import pr1.Shapes.Designation;
  import pr1.Shapes.Sealing;
  import flash.display.Shape;
  import pr1.Shapes.Arrow;
  import pr1.Shapes.ArcArrow;
  import pr1.forces.Element;
  import pr1.Frame;
  import pr1.events.DialogEvent;


  public class SealingContainer extends Element
  {

    private var angleOfSealing:Number;
    public var pointNumber:int;

    public function SealingContainer(frame:Frame, angle)
    {

      var upState:Sealing = new Sealing();
      var overState:Sealing = new Sealing(0xff);
      var hitTestState:Shape = new Shape();

      upState.rotation = angle;
      overState.rotation = angle;

      hitTestState.graphics.beginFill(0xffffff);
      hitTestState.graphics.drawRect(-10,-40,10,80);
      hitTestState.graphics.endFill();
      hitTestState.rotation = angle;

      super(frame, upState, overState, upState, hitTestState);

      var hArrow:Arrow = new Arrow(new Point(0,0), 0, new Point(5,0), false, 0xCC0000);
      var vArrow:Arrow = new Arrow(new Point(0,0), 0, new Point(0,-5), false, 0xCC0000);
      var moment:ArcArrow = new ArcArrow(new Point(0,0), new Point(-30,40), false, 0xcc0000);
      addChild(hArrow);
      addChild(vArrow);
      addChild(moment);

      sigPoses.hReaction = new Point(50,0);
      sigPoses.vReaction = new Point(-0,-70);
      sigPoses.moment = new Point(-35, 35);

    }

    override protected function onMouseClick(e:MouseEvent)
    {
      sigPoses.hReaction = new Point(signatures.hReaction.x, signatures.hReaction.y);
      sigPoses.vReaction = new Point(signatures.vReaction.x, signatures.vReaction.y);
      sigPoses.moment = new Point(signatures.moment.x, signatures.moment.y);

      dialogWnd = new EditWindowSealing(horisontalReaction, verticalReaction, moment);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      parent1.addChild(dialogWnd);
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }


    override protected function changeValues(data:Object)
    {
      horisontalReaction = data.hReaction;
      verticalReaction   = data.vReaction;
      moment             = data.moment;

      setCoordOfSignatures();
    }


    public function setCoordOfSignatures()
    {
      signatures.hReaction.x = sigPoses.hReaction.x;
      signatures.hReaction.y = sigPoses.hReaction.y;
      signatures.vReaction.x = sigPoses.vReaction.x;
      signatures.vReaction.y = sigPoses.vReaction.y;
      signatures.moment.x = sigPoses.moment.x;
      signatures.moment.y = sigPoses.moment.y;
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

    public function set moment(value:String)
    {
      params.moment = value;
      if(signatures.moment == null)
      {
        signatures.moment = new Designation(params.moment, "Times New Roman");
      }
      else
      {
        removeChild(signatures.moment);
        signatures.moment.destroy();
        signatures.moment = new Designation(params.moment, "Times New Roman");
      }
      addChild(signatures.moment);
    }

    public function get moment():String
    {
      return params.moment;
    }
  }
}