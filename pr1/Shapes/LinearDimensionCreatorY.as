package  pr1.Shapes
{
  import flash.display.SimpleButton;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import pr1.Shapes.LinearDimension;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindow4;
  import pr1.razmers.LinearDimensionYContainer;
  import pr1.Snap;
  import pr1.forces.*;
  import pr1.opora.*;
  import pr1.Frame;


  public class LinearDimensionCreatorY extends LinearDimensionCreatorX
  {
    public function LinearDimensionCreatorY(parent:*, segments:Array)
    {
      super(frame);
      
      parent1.removeChild(elementImage);
      this.elementImage = new LinearDimension(new Point(0,0), new Point(0,-15), -20, Math.PI/2, 0);
      parent1.addChild(elementImage);
      
      dimAngle = Math.PI/2;
    }
    
    override protected function getHeight():Number
    {
      return firstCoordinate.x - cursorPosition.x;
    }

    override protected function createObject(data:Object)
    {
      var p:Point;
      var angle:Number;
      razmer = new LinearDimensionYContainer(parent1, button_up, button_over, button_down, button_hit, data.name);
      setValues(razmer, data);
	  
      dispatchEvent(new Event(Creator.CREATE_DONE));
    }
  }
}
