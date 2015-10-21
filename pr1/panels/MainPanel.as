package  pr1.panels {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.geom.*;
	import flash.events.MouseEvent;
	import pr1.buttons.PanelButton;
	import pr1.Frame;
	import flash.events.Event;
	import pr1.Shapes.Segment;
	
	public class MainPanel extends Sprite {
		
		public static const CREATE_SEGMENT:String = "Create segment";
		public static const CREATE_C_FORCE:String = "Create concentrated force";
		public static const CREATE_M_FORCE:String = "Create moment";
		public static const CREATE_DR_FORCE:String = "Create rectangular distributed force";
		public static const CREATE_DT_FORCE:String = "Create triangular distributed force";
		public static const CREATE_FREE_DIMENSION:String = "Create free dimension";
		public static const CREATE_X_DIMENSION:String = "Create X dimension";
		public static const CREATE_Y_DIMENSION:String = "Create Y dimension";
		public static const CREATE_FREE_ANGLE:String = "Create free angle";
		public static const CREATE_X_ANGLE:String = "Create X angle";
		public static const CREATE_Y_ANGLE:String = "Create Y angle";
		public static const CREATE_SEALING:String = "Create sealing";
		public static const CREATE_FIXED_JOINT:String = "Create fixed joint";
		public static const CREATE_MOVABLE_JOINT:String = "Create movable joint";
		public static const SEND_DATA_TO_SERVER:String = "Send data to server";
		
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
		
		public function MainPanel(parent:*) {
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
			segment.msgButton = CREATE_SEGMENT;
			
			concentratedForce = new BtnForce();
			concentratedForce.parentPanel = this;
			concentratedForce.msgButton = CREATE_C_FORCE;
			
			distributedRForce = new BtnQl();
			distributedRForce.parentPanel = this;
			distributedRForce.msgButton = CREATE_DR_FORCE;
			
			distributedTForce = new BtnQmaxl();
			distributedTForce.parentPanel = this;
			distributedTForce.msgButton = CREATE_DT_FORCE;
			
			moment = new BtnMoment();
			moment.parentPanel = this;
			moment.msgButton = CREATE_M_FORCE;
			
			freeDimension = new BtnRazmer();
			freeDimension.parentPanel = this;
			freeDimension.msgButton = CREATE_FREE_DIMENSION;
			
			xDimension = new BtnRazmerX();
			xDimension.parentPanel = this;
			xDimension.msgButton = CREATE_X_DIMENSION;
			
			yDimension = new BtnRazmerY();
			yDimension.parentPanel = this;
			yDimension.msgButton = CREATE_Y_DIMENSION;
			
			freeAngle = new BtnAngle();
			freeAngle.parentPanel = this;
			freeAngle.msgButton = CREATE_FREE_ANGLE;
			
			xAngle = new BtnAngleX();
			xAngle.parentPanel = this;
			xAngle.msgButton = CREATE_X_ANGLE;
			
			yAngle = new BtnAngleY();
			yAngle.parentPanel = this;
			yAngle.msgButton = CREATE_Y_ANGLE;
			
			movableJoint = new BtnOpora1();
			movableJoint.parentPanel = this;
			movableJoint.msgButton = CREATE_MOVABLE_JOINT;
			
			sealing = new BtnOpora3();
			sealing.parentPanel = this;
			sealing.msgButton = CREATE_SEALING;
			
			fixedJoint = new BtnOpora2();
			fixedJoint.parentPanel = this;
			fixedJoint.msgButton = CREATE_FIXED_JOINT;
			
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
			addEventListener(MainPanel.CREATE_SEGMENT, onCreateSegment);
			addEventListener(MainPanel.CREATE_C_FORCE, onCreateConcentratedForce);
			addEventListener(MainPanel.CREATE_M_FORCE, onCreateMoment);
			addEventListener(MainPanel.CREATE_DR_FORCE, onCreateDistributedRForce);
			addEventListener(MainPanel.CREATE_DT_FORCE, onCreateDistributedTForce);
			addEventListener(MainPanel.CREATE_FREE_DIMENSION, onCreateFreeDimension);
			addEventListener(MainPanel.CREATE_X_DIMENSION, onCreateDimensionX);
			addEventListener(MainPanel.CREATE_Y_DIMENSION, onCreateDimensionY);
			addEventListener(MainPanel.CREATE_FREE_ANGLE, onCreateFreeAngle);
			addEventListener(MainPanel.CREATE_X_ANGLE, onCreateAngleX);
			addEventListener(MainPanel.CREATE_Y_ANGLE, onCreateAngleY);
			addEventListener(MainPanel.CREATE_MOVABLE_JOINT, onCreateMovableJoint);
			addEventListener(MainPanel.CREATE_FIXED_JOINT, onCreateFixedJoint);
			addEventListener(MainPanel.CREATE_SEALING, onCreateSealing);
			solve.addEventListener(MouseEvent.CLICK, onDoSolve);
		}
		
		private function setButtonsCoordinates(){

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
		
		public function setButtonsActiveState(){
			setButtonsCoordinates();
			panelLocked = false;
			removeSubPanel();
			
			if(oneRemovedButton != null){
				removeChild(oneRemovedButton);
				oneRemovedButton = null;
			}
			
			if(parent1.segments.length <=1){
				freeAngle.changeState(PanelButton.INACTIVE);
			} else {
				freeAngle.changeState(PanelButton.UP);
			}
			
			var notOrtoSeg:Boolean = false;
			for each (var seg:Segment in parent1.segments){
				if(seg.specialDirection != Segment.HORISONTAL && seg.specialDirection != Segment.VERTICAL){
					notOrtoSeg = true;
					break;
				}
			}
			if(notOrtoSeg){
				xAngle.changeState(PanelButton.UP);
				yAngle.changeState(PanelButton.UP);
			} else {
				xAngle.changeState(PanelButton.INACTIVE);
				yAngle.changeState(PanelButton.INACTIVE);
			}
			
			if(parent1.segments.length == 0){
				var state1 = PanelButton.INACTIVE
				sealing.changeState(PanelButton.INACTIVE);
				fixedJoint.changeState(PanelButton.INACTIVE);
				movableJoint.changeState(PanelButton.INACTIVE);
			} else {
				state1 = PanelButton.UP;
				if( Frame(parent1).opora1.length >= 3 || Frame(parent1).opora3 != null || (Frame(parent1).opora2 != null && Frame(parent1).opora1.length >= 1)){
					sealing.changeState(PanelButton.INACTIVE);
					fixedJoint.changeState(PanelButton.INACTIVE);
					movableJoint.changeState(PanelButton.INACTIVE);
				} else if(Frame(parent1).opora1.length >= 2 || Frame(parent1).opora2 != null){
					sealing.changeState(PanelButton.INACTIVE);
					fixedJoint.changeState(PanelButton.INACTIVE);
					movableJoint.changeState(PanelButton.UP);
				} else if(Frame(parent1).opora1.length >= 1){
					sealing.changeState(PanelButton.INACTIVE);
					fixedJoint.changeState(PanelButton.UP);
					movableJoint.changeState(PanelButton.UP);
				} else {
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
		
		public function setButtonsInactiveState(){
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
		
		private function onMouseOver(e:MouseEvent){
			var cursorPosition:Point = new Point(e.localX, e.localY);
			if(panelLocked) return;
			if(cursorPosition.y >= 147 && cursorPosition.y <= 195 && cursorPosition.x <= 135){
				if(subPanelPresent){
					if(subPanel.y == 144){
						return;
					} else {
						for each (var btn in removedButtons){
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
			} else if(cursorPosition.y >= 195 && cursorPosition.y <= 243 && cursorPosition.x <= 205){
				if(subPanelPresent){
					if(subPanel.y == 192){
						return;
					} else {
						for each (btn in removedButtons){
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
			} else if(cursorPosition.y >= 243 && cursorPosition.y <= 291 && cursorPosition.x <= 205){
				if(subPanelPresent){
					if(subPanel.y == 240){
						return;
					} else {
						for each (btn in removedButtons){
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
			} else if(cursorPosition.y >= 291 && cursorPosition.y <= 339 && cursorPosition.x <= 205){
				if(subPanelPresent){
					if(subPanel.y == 288){
						return;
					} else {
						for each (btn in removedButtons){
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
			} else {
				for each (btn in removedButtons){
					removeChild(btn);
				}
				subPanel.graphics.clear();
				subPanelPresent = false;
				removedButtons = new Array();
			}
		}
		
		private function removeSubPanel(){
			for each (var btn in this.removedButtons){
				removeChild(btn);
			}
			this.removedButtons = new Array();
			subPanel.graphics.clear();
			subPanelPresent = false;
		}
		
		private function onCreateSegment(e:Event){
			setButtonsInactiveState();
			segment.changeState(PanelButton.DOWN);
			panelLocked = true;
		}
		private function onCreateConcentratedForce(e:Event){
			setButtonsInactiveState();
			concentratedForce.changeState(PanelButton.DOWN);
			panelLocked = true;
		}
		private function onCreateMoment(e:Event){
			setButtonsInactiveState();
			moment.changeState(PanelButton.DOWN);
			panelLocked = true;
		}
		private function onCreateDistributedRForce(e:Event){
			setButtonsInactiveState();
			oneRemovedButton = new BtnQl().downState;
			addChild(oneRemovedButton);
			oneRemovedButton.x = 35;
			oneRemovedButton.y = 27+48*3; 
			panelLocked = true;
			removeSubPanel();
		}
		private function onCreateDistributedTForce(e:Event){
			setButtonsInactiveState();
			oneRemovedButton = new BtnQmaxl().downState;
			addChild(oneRemovedButton);
			oneRemovedButton.x = 35;
			oneRemovedButton.y = 27+48*3; 
			panelLocked = true;
			removeSubPanel();
		}
		private function onCreateFreeDimension(e:Event){
			setButtonsInactiveState();
			oneRemovedButton = new BtnRazmer().downState;
			addChild(oneRemovedButton);
			oneRemovedButton.x = 35;
			oneRemovedButton.y = 27+48*4; 
			panelLocked = true;
			removeSubPanel();
		}
		private function onCreateDimensionX(e:Event){
			setButtonsInactiveState();
			oneRemovedButton = new BtnRazmerX().downState;
			addChild(oneRemovedButton);
			oneRemovedButton.x = 35;
			oneRemovedButton.y = 27+48*4; 
			panelLocked = true;
			removeSubPanel();
		}
		private function onCreateDimensionY(e:Event){
			setButtonsInactiveState();
			oneRemovedButton = new BtnRazmerY().downState;
			addChild(oneRemovedButton);
			oneRemovedButton.x = 35;
			oneRemovedButton.y = 27+48*4; 
			panelLocked = true;
			removeSubPanel();
		}
		private function onCreateFreeAngle(e:Event){
			setButtonsInactiveState();
			oneRemovedButton = new BtnAngle().downState;
			addChild(oneRemovedButton);
			oneRemovedButton.x = 35;
			oneRemovedButton.y = 27+48*5; 
			panelLocked = true;
			removeSubPanel();
		}
		private function onCreateAngleX(e:Event){
			setButtonsInactiveState();
			oneRemovedButton = new BtnAngleX().downState;
			addChild(oneRemovedButton);
			oneRemovedButton.x = 35;
			oneRemovedButton.y = 27+48*5; 
			panelLocked = true;
			removeSubPanel();
		}
		private function onCreateAngleY(e:Event){
			setButtonsInactiveState();
			oneRemovedButton = new BtnAngleY().downState;
			addChild(oneRemovedButton);
			oneRemovedButton.x = 35;
			oneRemovedButton.y = 27+48*5; 
			panelLocked = true;
			removeSubPanel();
		}
		private function onCreateMovableJoint(e:Event){
			setButtonsInactiveState();
			oneRemovedButton = new BtnOpora1().downState;
			addChild(oneRemovedButton);
			oneRemovedButton.x = 35;
			oneRemovedButton.y = 27+48*6; 
			panelLocked = true;
			removeSubPanel();
		}
		private function onCreateFixedJoint(e:Event){
			setButtonsInactiveState();
			oneRemovedButton = new BtnOpora2().downState;
			addChild(oneRemovedButton);
			oneRemovedButton.x = 35;
			oneRemovedButton.y = 27+48*6; 
			panelLocked = true;
			removeSubPanel();
		}
		private function onCreateSealing(e:Event){
			setButtonsInactiveState();
			oneRemovedButton = new BtnOpora3().downState;
			addChild(oneRemovedButton);
			oneRemovedButton.x = 35;
			oneRemovedButton.y = 27+48*6; 
			panelLocked = true;
			removeSubPanel();
		}
		private function onDoSolve(e:MouseEvent){
			dispatchEvent(new Event(MainPanel.SEND_DATA_TO_SERVER, true));
		}
	}
	
}
