package  pr1.panels
{
  import flash.display.Sprite;
  import flash.display.Shape;
  import flash.display.DisplayObject;
  import flash.geom.*;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import pr1.buttons.PanelButton;
  import pr1.events.PanelEvent;
  import pr1.Frame;
  import pr1.Shapes.*;
  import pr1.Shapes.Segment;
  
  import pr1.Shapes.MomentCreator;
  import pr1.Shapes.Creator;
  import pr1.Shapes.SegmentCreator;
  import pr1.Shapes.ConcentratedForceCreator;
  import pr1.Shapes.DistributedForceRCreator;
  import pr1.Shapes.DistributedForceTCreator;
  import pr1.Shapes.LinearDimensionCreator;
  import pr1.Shapes.LinearDimensionCreatorX;
  import pr1.Shapes.LinearDimensionCreatorY;
  import pr1.Shapes.AngleDimensionCreator;
  import pr1.Shapes.AngleDimensionCreatorX;
  import pr1.Shapes.AngleDimensionCreatorY;
  import pr1.Shapes.SealingCreator;
  import pr1.Shapes.FixedJointCreator;
  import pr1.Shapes.MovableJointCreator;

  public class MainPanel extends Sprite
  {

    public static const CREATE_OBJECT:String = "Create";
    public static const SEND_DATA_TO_SERVER:String = "Send data to server";

    private var createBtns:Array;
    // отрезок
    private var segment:BtnOtrezok;
    // силы
    private var concentratedForce:BtnForce;
    private var distributedRForce:BtnQl;
    private var distributedTForce:BtnQmaxl;
    private var moment:BtnMoment;
    // линейные размеры
    private var freeDimension:BtnRazmer;
    private var xDimension:BtnRazmerX;
    private var yDimension:BtnRazmerY;
    // угловые размеры
    private var freeAngle:BtnAngle;
    private var xAngle:BtnAngleX;
    private var yAngle:BtnAngleY;
    // опоры и шарниры
    private var sealing:BtnOpora3;
    private var fixedJoint:BtnOpora2;
    private var movableJoint:BtnOpora1;

    //решить задание
    private var solve:SolveBtn;

    private var subPanel:Shape;
    private var subPanelPresent:Boolean;
    private var removedButtons:Array;
    private var oneRemovedButton:DisplayObject;
    private var panelLocked = false;

    private var parent1:*;

    public function MainPanel(parent:Frame)
    {
      createBtns = new Array();
      // constructor code
      var shape:Shape = new Shape();
      shape.graphics.lineStyle(1, 0x666666);
      shape.graphics.beginFill(0xcccccc);
      shape.graphics.drawRect(0,0,70,600);
      this.addChild(shape);

      this.parent1 = parent;
      subPanel = new Shape();
      addChild(subPanel);
      removedButtons = new Array();

      segment = new BtnOtrezok();
      segment.parentPanel = this;
      segment.message = new PanelEvent(CREATE_OBJECT, false, false, new SegmentCreator(parent));
      createBtns.push(segment);

      concentratedForce = new BtnForce();
      concentratedForce.parentPanel = this;
      concentratedForce.message = new PanelEvent(CREATE_OBJECT, false, false, new ConcentratedForceCreator(parent));
      createBtns.push(concentratedForce);

      distributedRForce = new BtnQl();
      distributedRForce.parentPanel = this;
      distributedRForce.message = new PanelEvent(CREATE_OBJECT, false, false, new DistributedForceRCreator(parent));
      createBtns.push(distributedRForce);

      distributedTForce = new BtnQmaxl();
      distributedTForce.parentPanel = this;
      distributedTForce.message = new PanelEvent(CREATE_OBJECT, false, false, new DistributedForceTCreator(parent));
      createBtns.push(distributedTForce);

      moment = new BtnMoment();
      moment.parentPanel = this;
      moment.message = new PanelEvent(CREATE_OBJECT, false, false, new MomentCreator(parent));
      createBtns.push(moment);

      freeDimension = new BtnRazmer();
      freeDimension.parentPanel = this;
      freeDimension.message = new PanelEvent(CREATE_OBJECT, false, false, new LinearDimensionCreator(parent));
      createBtns.push(freeDimension);

      xDimension = new BtnRazmerX();
      xDimension.parentPanel = this;
      xDimension.message = new PanelEvent(CREATE_OBJECT, false, false, new LinearDimensionCreatorX(parent));
      createBtns.push(xDimension);

      yDimension = new BtnRazmerY();
      yDimension.parentPanel = this;
      yDimension.message = new PanelEvent(CREATE_OBJECT, false, false, new LinearDimensionCreatorY(parent));
      createBtns.push(yDimension);

      freeAngle = new BtnAngle();
      freeAngle.parentPanel = this;
      freeAngle.message = new PanelEvent(CREATE_OBJECT, false, false, new AngleDimensionCreator(parent));
      createBtns.push(freeAngle);

      xAngle = new BtnAngleX();
      xAngle.parentPanel = this;
      xAngle.message = new PanelEvent(CREATE_OBJECT, false, false, new AngleDimensionCreatorX(parent));
      createBtns.push(xAngle);

      yAngle = new BtnAngleY();
      yAngle.parentPanel = this;
      yAngle.message = new PanelEvent(CREATE_OBJECT, false, false, new AngleDimensionCreatorY(parent));
      createBtns.push(yAngle);

      movableJoint = new BtnOpora1();
      movableJoint.parentPanel = this;
      movableJoint.message = new PanelEvent(CREATE_OBJECT, false, false, new MovableJointCreator(parent));
      createBtns.push(movableJoint);

      sealing = new BtnOpora3();
      sealing.parentPanel = this;
      sealing.message = new PanelEvent(CREATE_OBJECT, false, false, new SealingCreator(parent));
      createBtns.push(sealing);

      fixedJoint = new BtnOpora2();
      fixedJoint.parentPanel = this;
      fixedJoint.message = new PanelEvent(CREATE_OBJECT, false, false, new FixedJointCreator(parent));
      createBtns.push(fixedJoint);

      this.addChild(segment);
      this.addChild(concentratedForce);
      this.addChild(moment);

      solve = new SolveBtn();
      solve.x = 35;
      solve.y = 27+48*7;
      this.addChild(solve);

      var tempShape = new BtnQl().upState;
      this.addChild(tempShape);
      tempShape.x = 35;
      tempShape.y = 27+48*3;

      tempShape = new BtnRazmer().upState;
      this.addChild(tempShape);
      tempShape.x = 35;
      tempShape.y = 27+48*4;

      tempShape = new BtnAngle().upState;
      this.addChild(tempShape);
      tempShape.x = 35;
      tempShape.y = 27+48*5;

      tempShape = new BtnOpora1().upState;
      this.addChild(tempShape);
      tempShape.x = 35;
      tempShape.y = 27+48*6;


      setButtonsActiveState();
      
      addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
      addEventListener(MainPanel.CREATE_OBJECT, onCreate);
      solve.addEventListener(MouseEvent.CLICK, onDoSolve);
    }

    private function setButtonsCoordinates()
    {

      distributedRForce.x = 35;
      distributedRForce.y = 27+48*3;

      distributedTForce.x = 105;
      distributedTForce.y = 27+48*3;

      freeDimension.x = 35;
      freeDimension.y = 27+48*4;

      xDimension.x = 105;
      xDimension.y = 27+48*4;

      yDimension.x = 175;
      yDimension.y = 27+48*4;

      freeAngle.x = 35;
      freeAngle.y = 27+48*5;

      xAngle.x = 105;
      xAngle.y = 27+48*5;

      yAngle.x = 175;
      yAngle.y = 27+48*5;

      movableJoint.x = 35;
      movableJoint.y = 27+48*6;

      sealing.x = 175;
      sealing.y = 27+48*6;

      fixedJoint.x = 105;
      fixedJoint.y = 27+48*6;

      segment.x = 35;
      segment.y = 27;

      concentratedForce.x = 35;
      concentratedForce.y = 27+48;

      moment.x = 35;
      moment.y = 27+48*2;

    }

    public function setButtonsActiveState()
    {
      setButtonsCoordinates();
      panelLocked = false;
      removeSubPanel();

      if(oneRemovedButton != null)
      {
        removeChild(oneRemovedButton);
        oneRemovedButton = null;
      }

      if(parent1.segments.length <=1)
      {
        freeAngle.changeState(PanelButton.INACTIVE);
      }
      else
      {
        freeAngle.changeState(PanelButton.UP);
      }

      var notOrtoSeg:Boolean = false;
      for each (var seg:Segment in parent1.segments)
      {
        if(seg.specialDirection != Segment.HORISONTAL && seg.specialDirection != Segment.VERTICAL)
        {
          notOrtoSeg = true;
          break;
        }
      }
      if(notOrtoSeg)
      {
        xAngle.changeState(PanelButton.UP);
        yAngle.changeState(PanelButton.UP);
      }
      else
      {
        xAngle.changeState(PanelButton.INACTIVE);
        yAngle.changeState(PanelButton.INACTIVE);
      }

      if(parent1.segments.length == 0)
      {
        var state1 = PanelButton.INACTIVE
        sealing.changeState(PanelButton.INACTIVE);
        fixedJoint.changeState(PanelButton.INACTIVE);
        movableJoint.changeState(PanelButton.INACTIVE);
      }
      else
      {
        state1 = PanelButton.UP;
        if( Frame(parent1).opora1.length >= 3 || Frame(parent1).opora3 != null || (Frame(parent1).opora2 != null && Frame(parent1).opora1.length >= 1))
        {
          sealing.changeState(PanelButton.INACTIVE);
          fixedJoint.changeState(PanelButton.INACTIVE);
          movableJoint.changeState(PanelButton.INACTIVE);
        }
        else if(Frame(parent1).opora1.length >= 2 || Frame(parent1).opora2 != null)
        {
          sealing.changeState(PanelButton.INACTIVE);
          fixedJoint.changeState(PanelButton.INACTIVE);
          movableJoint.changeState(PanelButton.UP);
        }
        else if(Frame(parent1).opora1.length >= 1)
        {
          sealing.changeState(PanelButton.INACTIVE);
          fixedJoint.changeState(PanelButton.UP);
          movableJoint.changeState(PanelButton.UP);
        }
        else
        {
          sealing.changeState(PanelButton.UP);
          fixedJoint.changeState(PanelButton.UP);
          movableJoint.changeState(PanelButton.UP);
        }
      }
      concentratedForce.changeState(state1);
      distributedRForce.changeState(state1);
      distributedTForce.changeState(state1);
      moment.changeState(state1);
      freeDimension.changeState(state1);
      xDimension.changeState(state1);
      yDimension.changeState(state1);

      segment.changeState(PanelButton.UP);
    }

    public function setButtonsInactiveState()
    {
      var state1 = PanelButton.INACTIVE;

      concentratedForce.changeState(state1);
      distributedRForce.changeState(state1);
      distributedTForce.changeState(state1);
      moment.changeState(state1);
      freeDimension.changeState(state1);
      xDimension.changeState(state1);
      yDimension.changeState(state1);
      freeAngle.changeState(state1);
      xAngle.changeState(state1);
      yAngle.changeState(state1);
      segment.changeState(state1);
      sealing.changeState(PanelButton.INACTIVE);
      fixedJoint.changeState(PanelButton.INACTIVE);
      movableJoint.changeState(PanelButton.INACTIVE);
    }

    private function onMouseOver(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.localX, e.localY);
      if(panelLocked) return;
      if(cursorPosition.y >= 147 && cursorPosition.y <= 195 && cursorPosition.x <= 135)
      {
        if(subPanelPresent)
        {
          if(subPanel.y == 144)
          {
            return;
          }
          else
          {
            for each (var btn in removedButtons)
            {
              removeChild(btn);
            }
          }
        }
        subPanel.graphics.clear();
        subPanel.graphics.lineStyle();
        subPanel.graphics.beginFill(0xcccccc);
        subPanel.graphics.drawRect(1,0,140,54);
        subPanel.graphics.endFill();
        subPanel.graphics.lineStyle(1, 0x666666);
        subPanel.graphics.moveTo(70, 0);
        subPanel.graphics.lineTo(140, 0);
        subPanel.graphics.lineTo(140, 54);
        subPanel.graphics.lineTo(70, 54);
        subPanel.x = 0;
        subPanel.y = 144;
        subPanelPresent = true;
        addChild(distributedRForce);
        addChild(distributedTForce);
        removedButtons = new Array(distributedRForce, distributedTForce);
      } else if(cursorPosition.y >= 195 && cursorPosition.y <= 243 && cursorPosition.x <= 205)
      {
        if(subPanelPresent)
        {
          if(subPanel.y == 192)
          {
            return;
          }
          else
          {
            for each (btn in removedButtons)
            {
              removeChild(btn);
            }
          }
        }
        subPanel.graphics.clear();
        subPanel.graphics.lineStyle();
        subPanel.graphics.beginFill(0xcccccc);
        subPanel.graphics.drawRect(1,0,210,54);
        subPanel.graphics.endFill();
        subPanel.graphics.lineStyle(1, 0x666666);
        subPanel.graphics.moveTo(70, 0);
        subPanel.graphics.lineTo(210, 0);
        subPanel.graphics.lineTo(210, 54);
        subPanel.graphics.lineTo(70, 54);
        subPanel.x = 0;
        subPanel.y = 192;
        subPanelPresent = true;
        addChild(freeDimension);
        addChild(xDimension);
        addChild(yDimension);
        removedButtons = new Array(freeDimension, xDimension, yDimension);
      }
      else if(cursorPosition.y >= 243 && cursorPosition.y <= 291 && cursorPosition.x <= 205)
      {
        if(subPanelPresent)
        {
          if(subPanel.y == 240)
          {
            return;
          }
          else
          {
            for each (btn in removedButtons)
            {
              removeChild(btn);
            }
          }
        }
        subPanel.graphics.clear();
        subPanel.graphics.lineStyle();
        subPanel.graphics.beginFill(0xcccccc);
        subPanel.graphics.drawRect(1,0,210,54);
        subPanel.graphics.endFill();
        subPanel.graphics.lineStyle(1, 0x666666);
        subPanel.graphics.moveTo(70, 0);
        subPanel.graphics.lineTo(210, 0);
        subPanel.graphics.lineTo(210, 54);
        subPanel.graphics.lineTo(70, 54);
        subPanel.x = 0;
        subPanel.y = 240;
        subPanelPresent = true;
        addChild(freeAngle);
        addChild(xAngle);
        addChild(yAngle);
        removedButtons = new Array(freeAngle, xAngle, yAngle);
      }
      else if(cursorPosition.y >= 291 && cursorPosition.y <= 339 && cursorPosition.x <= 205)
      {
        if(subPanelPresent)
        {
          if(subPanel.y == 288)
          {
            return;
          }
          else
          {
            for each (btn in removedButtons)
            {
              removeChild(btn);
            }
          }
        }
        subPanel.graphics.clear();
        subPanel.graphics.lineStyle();
        subPanel.graphics.beginFill(0xcccccc);
        subPanel.graphics.drawRect(1,0,210,54);
        subPanel.graphics.endFill();
        subPanel.graphics.lineStyle(1, 0x666666);
        subPanel.graphics.moveTo(70, 0);
        subPanel.graphics.lineTo(210, 0);
        subPanel.graphics.lineTo(210, 54);
        subPanel.graphics.lineTo(70, 54);
        subPanel.x = 0;
        subPanel.y = 288;
        subPanelPresent = true;
        addChild(movableJoint);
        addChild(fixedJoint);
        addChild(sealing);
        removedButtons = new Array(sealing, fixedJoint, movableJoint);
      }
      else
      {
        for each (btn in removedButtons)
        {
          removeChild(btn);
        }
        subPanel.graphics.clear();
        subPanelPresent = false;
        removedButtons = new Array();
      }
    }

    private function removeSubPanel()
    {
      for each (var btn in this.removedButtons)
      {
        removeChild(btn);
      }
      this.removedButtons = new Array();
      subPanel.graphics.clear();
      subPanelPresent = false;
    }

	private function onCreate(e:PanelEvent)
	{
		
	}
    private function onCreateSegment(e:Event)
    {
      setButtonsInactiveState();
      segment.changeState(PanelButton.DOWN);
      panelLocked = true;
    }
    private function onCreateConcentratedForce(e:Event)
    {
      setButtonsInactiveState();
      concentratedForce.changeState(PanelButton.DOWN);
      panelLocked = true;
    }
    private function onCreateMoment(e:Event)
    {
      setButtonsInactiveState();
      moment.changeState(PanelButton.DOWN);
      panelLocked = true;
    }
    private function onCreateDistributedRForce(e:Event)
    {
      setButtonsInactiveState();
      oneRemovedButton = new BtnQl().downState;
      addChild(oneRemovedButton);
      oneRemovedButton.x = 35;
      oneRemovedButton.y = 27+48*3;
      panelLocked = true;
      removeSubPanel();
    }
    private function onCreateDistributedTForce(e:Event)
    {
      setButtonsInactiveState();
      oneRemovedButton = new BtnQmaxl().downState;
      addChild(oneRemovedButton);
      oneRemovedButton.x = 35;
      oneRemovedButton.y = 27+48*3;
      panelLocked = true;
      removeSubPanel();
    }
    private function onCreateFreeDimension(e:Event)
    {
      setButtonsInactiveState();
      oneRemovedButton = new BtnRazmer().downState;
      addChild(oneRemovedButton);
      oneRemovedButton.x = 35;
      oneRemovedButton.y = 27+48*4;
      panelLocked = true;
      removeSubPanel();
    }
    private function onCreateDimensionX(e:Event)
    {
      setButtonsInactiveState();
      oneRemovedButton = new BtnRazmerX().downState;
      addChild(oneRemovedButton);
      oneRemovedButton.x = 35;
      oneRemovedButton.y = 27+48*4;
      panelLocked = true;
      removeSubPanel();
    }
    private function onCreateDimensionY(e:Event)
    {
      setButtonsInactiveState();
      oneRemovedButton = new BtnRazmerY().downState;
      addChild(oneRemovedButton);
      oneRemovedButton.x = 35;
      oneRemovedButton.y = 27+48*4;
      panelLocked = true;
      removeSubPanel();
    }
    private function onCreateFreeAngle(e:Event)
    {
      setButtonsInactiveState();
      oneRemovedButton = new BtnAngle().downState;
      addChild(oneRemovedButton);
      oneRemovedButton.x = 35;
      oneRemovedButton.y = 27+48*5;
      panelLocked = true;
      removeSubPanel();
    }
    private function onCreateAngleX(e:Event)
    {
      setButtonsInactiveState();
      oneRemovedButton = new BtnAngleX().downState;
      addChild(oneRemovedButton);
      oneRemovedButton.x = 35;
      oneRemovedButton.y = 27+48*5;
      panelLocked = true;
      removeSubPanel();
    }
    private function onCreateAngleY(e:Event)
    {
      setButtonsInactiveState();
      oneRemovedButton = new BtnAngleY().downState;
      addChild(oneRemovedButton);
      oneRemovedButton.x = 35;
      oneRemovedButton.y = 27+48*5;
      panelLocked = true;
      removeSubPanel();
    }
    private function onCreateMovableJoint(e:Event)
    {
      setButtonsInactiveState();
      oneRemovedButton = new BtnOpora1().downState;
      addChild(oneRemovedButton);
      oneRemovedButton.x = 35;
      oneRemovedButton.y = 27+48*6;
      panelLocked = true;
      removeSubPanel();
    }
    private function onCreateFixedJoint(e:Event)
    {
      setButtonsInactiveState();
      oneRemovedButton = new BtnOpora2().downState;
      addChild(oneRemovedButton);
      oneRemovedButton.x = 35;
      oneRemovedButton.y = 27+48*6;
      panelLocked = true;
      removeSubPanel();
    }
    private function onCreateSealing(e:Event)
    {
      setButtonsInactiveState();
      oneRemovedButton = new BtnOpora3().downState;
      addChild(oneRemovedButton);
      oneRemovedButton.x = 35;
      oneRemovedButton.y = 27+48*6;
      panelLocked = true;
      removeSubPanel();
    }
    private function onDoSolve(e:MouseEvent)
    {
      dispatchEvent(new Event(MainPanel.SEND_DATA_TO_SERVER, true));
    }
  }
}
