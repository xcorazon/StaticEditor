package  pr1.panels
{
  import flash.display.Sprite;
  import flash.display.Shape;
  import flash.display.DisplayObject;
  import flash.geom.*;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.utils.*;
  import pr1.buttons.*;
  import pr1.events.PanelEvent;
  import pr1.Frame;
  import pr1.Shapes.*;

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
    private var removableButtons:Array;
    private var oneRemovedButton:DisplayObject;
    private var panelLocked = false;

    private var parent1:*;

    public function MainPanel()
    {
      createBtns = new Array();
      // constructor code
      var shape:Shape = new Shape();
      shape.graphics.lineStyle(1, 0x666666);
      shape.graphics.beginFill(0xcccccc);
      shape.graphics.drawRect(0,0,70,600);
      this.addChild(shape);

      this.parent1 = Frame.Instance;
      subPanel = new Shape();
      addChild(subPanel);
      removableButtons = new Array();

      segment = new BtnOtrezok();
      segment.parentPanel = this;
      segment.message = new PanelEvent(CREATE_OBJECT, false, false, new SegmentCreator());
      createBtns.push(segment);

      concentratedForce = new BtnForce();
      concentratedForce.parentPanel = this;
      concentratedForce.message = new PanelEvent(CREATE_OBJECT, false, false, new ConcentratedForceCreator());
      concentratedForce.decorator = new CommonDecor();
      createBtns.push(concentratedForce);

      distributedRForce = new BtnQl();
      distributedRForce.parentPanel = this;
      distributedRForce.message = new PanelEvent(CREATE_OBJECT, false, false, new DistributedForceRCreator());
      distributedRForce.decorator = new CommonDecor();
      createBtns.push(distributedRForce);

      distributedTForce = new BtnQmaxl();
      distributedTForce.parentPanel = this;
      distributedTForce.message = new PanelEvent(CREATE_OBJECT, false, false, new DistributedForceTCreator());
      distributedTForce.decorator = new CommonDecor();
      createBtns.push(distributedTForce);

      moment = new BtnMoment();
      moment.parentPanel = this;
      moment.message = new PanelEvent(CREATE_OBJECT, false, false, new MomentCreator());
      moment.decorator = new CommonDecor();
      createBtns.push(moment);

      freeDimension = new BtnRazmer();
      freeDimension.parentPanel = this;
      freeDimension.message = new PanelEvent(CREATE_OBJECT, false, false, new LinearDimensionCreator());
      freeDimension.decorator = new CommonDecor();
      createBtns.push(freeDimension);

      xDimension = new BtnRazmerX();
      xDimension.parentPanel = this;
      xDimension.message = new PanelEvent(CREATE_OBJECT, false, false, new LinearDimensionCreatorX());
      xDimension.decorator = new CommonDecor();
      createBtns.push(xDimension);

      yDimension = new BtnRazmerY();
      yDimension.parentPanel = this;
      yDimension.message = new PanelEvent(CREATE_OBJECT, false, false, new LinearDimensionCreatorY());
      yDimension.decorator = new CommonDecor();
      createBtns.push(yDimension);

      freeAngle = new BtnAngle();
      freeAngle.parentPanel = this;
      freeAngle.message = new PanelEvent(CREATE_OBJECT, false, false, new AngleDimensionCreator());
      freeAngle.decorator = new AngleDecor();
      createBtns.push(freeAngle);

      xAngle = new BtnAngleX();
      xAngle.parentPanel = this;
      xAngle.message = new PanelEvent(CREATE_OBJECT, false, false, new AngleDimensionCreatorX());
      xAngle.decorator = new AngleXYDecor();
      createBtns.push(xAngle);

      yAngle = new BtnAngleY();
      yAngle.parentPanel = this;
      yAngle.message = new PanelEvent(CREATE_OBJECT, false, false, new AngleDimensionCreatorY());
      yAngle.decorator = new AngleXYDecor();
      createBtns.push(yAngle);

      movableJoint = new BtnOpora1();
      movableJoint.parentPanel = this;
      movableJoint.message = new PanelEvent(CREATE_OBJECT, false, false, new MovableJointCreator());
      movableJoint.decorator = new MovableJointDecor();
      createBtns.push(movableJoint);

      sealing = new BtnOpora3();
      sealing.parentPanel = this;
      sealing.message = new PanelEvent(CREATE_OBJECT, false, false, new SealingCreator());
      sealing.decorator = new SealingDecor();
      createBtns.push(sealing);

      fixedJoint = new BtnOpora2();
      fixedJoint.parentPanel = this;
      fixedJoint.message = new PanelEvent(CREATE_OBJECT, false, false, new FixedJointCreator());
      fixedJoint.decorator = new FixedJointDecor();
      createBtns.push(fixedJoint);

      this.addChild(segment);
      this.addChild(concentratedForce);
      this.addChild(moment);

      solve = new SolveBtn();
      solve.x = 35;
      solve.y = 27+48*7;
      this.addChild(solve);
      solve.parentPanel = this;
      solve.message = new PanelEvent(MainPanel.SEND_DATA_TO_SERVER);
      createBtns.push(solve);

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
      addEventListener(MainPanel.SEND_DATA_TO_SERVER, onSendData);
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
      
      for each (var btn in this.createBtns)
        btn.changeState(PanelButton.UP);
    }

    public function setButtonsInactiveState()
    {
      for each (var btn in this.createBtns)
        btn.changeState(PanelButton.INACTIVE);
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
            for each (var btn in removableButtons)
            {
              removeChild(btn);
            }
          }
        }
        removableButtons = new Array(distributedRForce, distributedTForce);
        addSubPanel(3, removableButtons);
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
            for each (btn in removableButtons)
            {
              removeChild(btn);
            }
          }
        }
        removableButtons = new Array(freeDimension, xDimension, yDimension);
        addSubPanel(4, removableButtons);
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
            for each (btn in removableButtons)
            {
              removeChild(btn);
            }
          }
        }
        removableButtons = new Array(freeAngle, xAngle, yAngle);
        addSubPanel(5, removableButtons);
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
            for each (btn in removableButtons)
            {
              removeChild(btn);
            }
          }
        }
        removableButtons = new Array(sealing, fixedJoint, movableJoint);
        addSubPanel(6, removableButtons);
      }
      else
      {
        for each (btn in removableButtons)
        {
          removeChild(btn);
        }
        subPanel.graphics.clear();
        subPanelPresent = false;
        removableButtons = new Array();
      }
    }
    
    private function addSubPanel(pos:int, buttons:Array)
    {
      subPanel.graphics.clear();
      if (buttons.length <= 1)
      {
        subPanelPresent = false;
        return;
      }
      
      var buttonHeight:int = 42;
      var buttonsGap:int = 6; // расстояние между кнопками
      
      var width:int = buttons.length * 70;
      var height:int = 54;

      subPanel.graphics.lineStyle();
      subPanel.graphics.beginFill(0xcccccc);
      subPanel.graphics.drawRect(1,0,width,height);
      subPanel.graphics.endFill();
      subPanel.graphics.lineStyle(1, 0x666666);
      subPanel.graphics.moveTo(70, 0);
      subPanel.graphics.lineTo(width, 0);
      subPanel.graphics.lineTo(width, height);
      subPanel.graphics.lineTo(70, height);
      subPanel.x = 0;
      subPanel.y = buttonsGap/2 + pos * (buttonHeight + buttonsGap);
      subPanelPresent = true;
      
      for each(var btn in buttons)
        addChild(btn);
    }

    private function removeSubPanel()
    {
      for each (var btn in this.removableButtons)
        removeChild(btn);

      this.removableButtons = new Array();
      subPanel.graphics.clear();
      subPanelPresent = false;
    }

    private function onCreate(e:PanelEvent)
    {
      setButtonsInactiveState();
      e.button.changeState(PanelButton.DOWN);
      
      var cls:Class = getDefinitionByName(getQualifiedClassName(e.button)) as Class;
      var btn:Object = new cls();
      btn.destroy();
      
      if (subPanelPresent)
      {
        oneRemovedButton = btn.downState;
        oneRemovedButton.x = 35;
        oneRemovedButton.y = e.button.y;
        addChild(oneRemovedButton);
        removeSubPanel();
      }
      panelLocked = true;
    }
    
    private function onSendData(e:PanelEvent)
    {
      setButtonsInactiveState();
      e.button.changeState(PanelButton.DOWN);
    }
  }
}
