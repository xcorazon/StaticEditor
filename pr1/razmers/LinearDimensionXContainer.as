package  pr1.razmers
{
  import flash.geom.Point;
  import flash.display.DisplayObject;
  import pr1.Frame;
  import pr1.Shapes.Designation;

  public class LinearDimensionXContainer extends LinearDimensionYContainer
  {
    public function LinearDimensionXContainer(frame:Frame, upState:DisplayObject = null,
                 overState:DisplayObject = null,
                 downState:DisplayObject = null,
                 hitTestState:DisplayObject = null,
                 razmerName:String = null)
    {
      super(frame, upState, overState, downState, hitTestState, razmerName);
    }

    override public function setCoordOfRazmerName()
    {
      var width:Number = secondPointDecartCoord.x - firstPointDecartCoord.x;
      var p1:Point = new Point();

      p1.x = (width - signatures.name.width)/2;
      p1.y = -razmerHeight - (signatures.name.height - 5);

      signatures.name.x = p1.x;
      signatures.name.y = p1.y;
    }


    override public function set razmerName(value:String)
    {
      params.name = value;
      if(signatures.name == null)
      {
        signatures.name = new Designation(params.name, "Times New Roman");
        signatures.name.disable();
        addChild(signatures.name);
      }
      else
      {
        removeChild(signatures.name);
        signatures.name.destroy();
        signatures.name = new Designation(params.name, "Times New Roman");
        signatures.name.disable();
        addChild(signatures.name);
      }
    }

    override public function get razmerType():int
    {
      return HORISONTAL_DIMENSION;
    }
  }
}
