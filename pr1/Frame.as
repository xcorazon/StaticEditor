package pr1 {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*; //TextField;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	import pr1.Shapes.SegmentCreator;
	import pr1.Shapes.ConcentratedForceCreator;
	import pr1.forces.*;
	import pr1.razmers.*;
	import pr1.Shapes.MomentCreator;
	import pr1.Snap;
	import pr1.Shapes.DistributedForceRCreator;
	import pr1.Shapes.DistributedForceTCreator;
	import pr1.Shapes.LinearDimensionCreator;
	import pr1.Shapes.LinearDimensionCreatorX;
	import pr1.Shapes.LinearDimensionCreatorY;
	import pr1.Shapes.AngleDimensionCreator;
	import pr1.Shapes.AngleDimensionCreatorX;
	import pr1.Shapes.AngleDimensionCreatorY;
	import pr1.Shapes.SealingCreator;
	import pr1.opora.*;
	import pr1.Shapes.FixedJointCreator;
	import pr1.Shapes.MovableJointCreator;
	import pr1.tests.Workspace;
	import com.adobe.images.PNGEncoder;
	import flash.system.Security;
	import pr1.panels.MainPanel;
	import pr1.EditEvent;
	import pr1.Shapes.Segment;
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	
	public class Frame extends Sprite {
		[Embed(source='..\\symbol.ttf', fontName='Symbol1', embedAsCFF='false')]
		const myNewFont:Class;
		
		private var creator:*;
		
		public var distributedForcesR:Array;		// массив равномерно распределенных нагрузок
		public var lastNonUsedDRForce:int;
		public var distributedForcesT:Array;		// массив треугольно распределенных нагрузок
		public var lastNonUsedDTForce:int;
		public var pForces:Array;		// массив сосредоточенных нагрузок
		public var lastNonUsedConcentratedForce:int;
		public var mForces:Array;		// массив моментов сил
		public var lastNonUsedMoment:int;
		
		public var dimensionX:Array;		// массив вертикальных размеров
		public var dimensionY:Array;		// массив горизонтальных размеров
		public var freeDimension:Array;		// массив свободных размеров
		public var anglesX:Array;		// массив угловых размеров относительно оси X
		public var anglesY:Array;		// массив угловых размеров относительно оси Y
		public var angles:Array;		// массив угловых размеров относительно конструкций (свободных отрезков)
		public var segments:Array;		// массив отрезков на которых расположены силы
	
		public var opora1:Array;		// опора с одной реакцией (тележка)
		public var opora2:FixedJointContainer;		// опора с двумя реакциями
		public var opora3:SealingContainer;			// опора с тремя реакциями
		private var lastNonUsedJoint:int;
		
		
		private var mainPanel:MainPanel;
		private var parent1:Workspace;
		private var outData:OutDataCreator;
		private var snap1:Snap;
		// таймер для задержки после отправки всех данных на сайт
		private var timer:Timer;
		// имя файла для решения
		private var _resolveFileName:String;
		
		
		public function Frame():void {
			
			Security.allowDomain("http://teormeh.com");
			Security.loadPolicyFile("http://teormeh.com/crossdomain.xml");
			
			//для тестирования использую эту политику
			//Security.allowDomain("http://teormeh");
			//Security.loadPolicyFile("http://teormeh/crossdomain.xml");
			
			dimensionX = new Array();
			dimensionY = new Array();
			freeDimension = new Array();
			anglesX = new Array();
			anglesY = new Array();
			angles = new Array();
			pForces = new Array();
			lastNonUsedConcentratedForce = 1000;
			mForces = new Array();
			lastNonUsedMoment = 2000;
			
			distributedForcesR = new Array();
			lastNonUsedDRForce = 3000;
			distributedForcesT = new Array();
			lastNonUsedDTForce = 4000;
			
			opora1 = new Array();
			//freeOpora1 = null;
			opora2 = null;
			opora3 = null;
			segments = new Array();
			lastNonUsedJoint = 5000;
			
			parent1 = new Workspace();
			parent1.graphics.beginFill(0xffffff, 0);
			parent1.graphics.drawRect(0,0,800,600);
			parent1.graphics.endFill();
			addChild(parent1);
			parent1.x = 0;
			parent1.y = 0;
			snap1 = new Snap(segments, distributedForcesR, distributedForcesT, pForces, joints);
			parent1.snap = snap1;
			
			mainPanel = new MainPanel(this);
			outData = new OutDataCreator();
			addChild(mainPanel);
			
			mainPanel.addEventListener(MainPanel.CREATE_SEGMENT, createSegment);
			mainPanel.addEventListener(MainPanel.CREATE_C_FORCE, createConcentratedForce);
			mainPanel.addEventListener(MainPanel.CREATE_M_FORCE, createMoment);
			mainPanel.addEventListener(MainPanel.CREATE_DR_FORCE, createRDistributedForce);
			mainPanel.addEventListener(MainPanel.CREATE_DT_FORCE, createTDistributedForce);
			mainPanel.addEventListener(MainPanel.CREATE_FREE_DIMENSION, createFreeDimension);
			mainPanel.addEventListener(MainPanel.CREATE_X_DIMENSION, createDimensionX);
			mainPanel.addEventListener(MainPanel.CREATE_Y_DIMENSION, createDimensionY);
			mainPanel.addEventListener(MainPanel.CREATE_FREE_ANGLE, createFreeAngle);
			mainPanel.addEventListener(MainPanel.CREATE_X_ANGLE, createAngleX);
			mainPanel.addEventListener(MainPanel.CREATE_Y_ANGLE, createAngleY);
			mainPanel.addEventListener(MainPanel.CREATE_MOVABLE_JOINT, createMovableJoint);
			mainPanel.addEventListener(MainPanel.CREATE_FIXED_JOINT, createFixedJoint);
			mainPanel.addEventListener(MainPanel.CREATE_SEALING, createSealing);
			mainPanel.addEventListener(MainPanel.SEND_DATA_TO_SERVER, onSendData);
			addEventListener(ComConst.CHANGE_ELEMENT, onChangeElement);
			addEventListener(ComConst.DELETE_ELEMENT, onDeleteElement);
			addEventListener(ComConst.LOCK_ALL, lockAllElements);
			
		}
		// создание отрезка
		private function createSegment(e:Event){
			lockAllElements();
			creator = new SegmentCreator(parent1, segments);
			creator.addEventListener(SegmentCreator.CREATE_DONE, segmentCreationDone);
			creator.addEventListener(SegmentCreator.CANCEL, segmentCreationCancel);
		}
		private function segmentCreationDone(e:Event){
			unlockAllElements();
			segments.push(creator.segment);
			creator.removeEventListener(SegmentCreator.CREATE_DONE, segmentCreationDone);
			parent1.addChild(creator.segment);
			creator.removeEventListener(SegmentCreator.CANCEL, segmentCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		private function segmentCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(SegmentCreator.CREATE_DONE, segmentCreationDone);
			creator.removeEventListener(SegmentCreator.CANCEL, segmentCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		// создание концентрированной нагрузки
		private function createConcentratedForce(e:Event){
			lockAllElements();
			creator = new ConcentratedForceCreator(parent1, segments, lastNonUsedConcentratedForce);
			creator.addEventListener(ConcentratedForceCreator.CREATE_DONE, forceCreationDone);
			creator.addEventListener(ConcentratedForceCreator.CREATE_CANCEL, forceCreationCancel);
		}
		private function forceCreationDone(e:Event){
			unlockAllElements();
			updateConcentratedForcesAndAngles(creator.result);
			pForces.push(creator.result);
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, pForces, joints);
			parent1.snap = snap1;
			creator.removeEventListener(ConcentratedForceCreator.CREATE_DONE, forceCreationDone);
			parent1.addChild(creator.result);
			creator.removeEventListener(ConcentratedForceCreator.CREATE_CANCEL, forceCreationCancel);
			mainPanel.setButtonsActiveState();
			lastNonUsedConcentratedForce++;
		}
		private function forceCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(ConcentratedForceCreator.CREATE_DONE, forceCreationDone);
			creator.removeEventListener(ConcentratedForceCreator.CREATE_CANCEL, forceCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		// создание момента сил
		private function createMoment(e:Event){
			
			lockAllElements();
			creator = new MomentCreator(parent1, segments, lastNonUsedMoment);
			creator.addEventListener(ConcentratedForceCreator.CREATE_DONE, momentCreationDone);
			creator.addEventListener(ConcentratedForceCreator.CREATE_CANCEL, momentCreationCancel);
		}
		private function momentCreationDone(e:Event){
			unlockAllElements();
			updateMoments(creator.result);
			mForces.push(creator.result);
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, pForces, joints);
			parent1.snap = snap1;
			creator.removeEventListener(ConcentratedForceCreator.CREATE_DONE, momentCreationDone);
			parent1.addChild(creator.result);
			creator.removeEventListener(ConcentratedForceCreator.CREATE_CANCEL, momentCreationCancel);
			mainPanel.setButtonsActiveState();
			lastNonUsedMoment++;
		}
		private function momentCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(ConcentratedForceCreator.CREATE_DONE, momentCreationDone);
			creator.removeEventListener(ConcentratedForceCreator.CREATE_CANCEL, momentCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		// создание равномерно распределенной нагрузки
		private function createRDistributedForce(e:Event){
			lockAllElements();
			creator = new DistributedForceRCreator(parent1, segments, lastNonUsedDRForce);
			creator.addEventListener(DistributedForceRCreator.CREATE_DONE, qrCreationDone);
			creator.addEventListener(DistributedForceRCreator.CREATE_CANCEL, qrCreationCancel);
		}
		private function qrCreationDone(e:Event){
			unlockAllElements();
			updateDistributedForces(creator.result);
			distributedForcesR.push(creator.result);
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, pForces, joints);
			parent1.snap = snap1;
			creator.removeEventListener(DistributedForceRCreator.CREATE_DONE, qrCreationDone);
			parent1.addChild(creator.result);
			creator.removeEventListener(DistributedForceRCreator.CREATE_CANCEL, qrCreationCancel);
			mainPanel.setButtonsActiveState();
			lastNonUsedDRForce += 2;
		}
		private function qrCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(DistributedForceRCreator.CREATE_DONE, qrCreationDone);
			creator.removeEventListener(DistributedForceRCreator.CREATE_CANCEL, qrCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		// создание треугольно распределенной нагрузки
		private function createTDistributedForce(e:Event){
			lockAllElements();
			creator = new DistributedForceTCreator(parent1, segments, lastNonUsedDTForce);
			creator.addEventListener(DistributedForceTCreator.CREATE_DONE, qtCreationDone);
			creator.addEventListener(DistributedForceTCreator.CREATE_CANCEL, qtCreationCancel);
		}
		private function qtCreationDone(e:Event){
			unlockAllElements();
			updateDistributedForces(creator.result);
			distributedForcesT.push(creator.result);
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, pForces, joints);
			parent1.snap = snap1;
			creator.removeEventListener(DistributedForceRCreator.CREATE_DONE, qtCreationDone);
			parent1.addChild(creator.result);
			creator.removeEventListener(DistributedForceRCreator.CREATE_CANCEL, qtCreationCancel);
			mainPanel.setButtonsActiveState();
			lastNonUsedDTForce += 2;
		}
		private function qtCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(DistributedForceRCreator.CREATE_DONE, qtCreationDone);
			creator.removeEventListener(DistributedForceRCreator.CREATE_CANCEL, qtCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		//создание размера
		private function createFreeDimension(e:Event){
			lockAllElements();
			creator = new LinearDimensionCreator(parent1, segments);
			creator.addEventListener(LinearDimensionCreator.CREATE_DONE, freeDimensionCreationDone);
			creator.addEventListener(LinearDimensionCreator.CREATE_CANCEL, freeDimensionCreationCancel);
		
		}
		private function freeDimensionCreationDone(e:Event){
			unlockAllElements();
			updateLinearDimensions(creator.result);
			freeDimension.push(creator.result);
			creator.removeEventListener(LinearDimensionCreator.CREATE_DONE, freeDimensionCreationDone);
			parent1.addChild(creator.result);
			creator.removeEventListener(LinearDimensionCreator.CREATE_CANCEL, freeDimensionCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		private function freeDimensionCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(LinearDimensionCreator.CREATE_DONE, freeDimensionCreationDone);
			creator.removeEventListener(LinearDimensionCreator.CREATE_CANCEL, freeDimensionCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		//создание размера X
		private function createDimensionX(e:Event){
			lockAllElements();
			creator = new LinearDimensionCreatorX(parent1, segments);
			creator.addEventListener(LinearDimensionCreatorX.CREATE_DONE, dimensionXCreationDone);
			creator.addEventListener(LinearDimensionCreatorX.CREATE_CANCEL, dimensionXCreationCancel);
		
		}
		private function dimensionXCreationDone(e:Event){
			unlockAllElements();
			updateLinearDimensions(creator.result);
			dimensionX.push(creator.result);
			creator.removeEventListener(LinearDimensionCreatorX.CREATE_DONE, dimensionXCreationDone);
			parent1.addChild(creator.result);
			creator.removeEventListener(LinearDimensionCreatorX.CREATE_CANCEL, dimensionXCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		private function dimensionXCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(LinearDimensionCreatorX.CREATE_DONE, dimensionXCreationDone);
			creator.removeEventListener(LinearDimensionCreatorX.CREATE_CANCEL, dimensionXCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		//создание размера Y
		private function createDimensionY(e:Event){
			lockAllElements();
			creator = new LinearDimensionCreatorY(parent1, segments);
			creator.addEventListener(LinearDimensionCreatorY.CREATE_DONE, dimensionYCreationDone);
			creator.addEventListener(LinearDimensionCreatorY.CREATE_CANCEL, dimensionYCreationCancel);
		
		}
		private function dimensionYCreationDone(e:Event){
			unlockAllElements();
			updateLinearDimensions(creator.result);
			dimensionY.push(creator.result);
			creator.removeEventListener(LinearDimensionCreatorY.CREATE_DONE, dimensionYCreationDone);
			parent1.addChild(creator.result);
			creator.removeEventListener(LinearDimensionCreatorY.CREATE_CANCEL, dimensionYCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		private function dimensionYCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(LinearDimensionCreatorY.CREATE_DONE, dimensionYCreationDone);
			creator.removeEventListener(LinearDimensionCreatorY.CREATE_CANCEL, dimensionYCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		// создание углового размера
		private function createFreeAngle(e:Event){
			lockAllElements();
			creator = new AngleDimensionCreator(parent1, segments);
			creator.addEventListener(AngleDimensionCreator.CREATE_DONE, freeAngleCreationDone);
			creator.addEventListener(AngleDimensionCreator.CREATE_CANCEL, freeAngleCreationCancel);
		}
		private function freeAngleCreationDone(e:Event){
			unlockAllElements();
			updateAngleDimensions(creator.result);
			angles.push(creator.result);
			creator.removeEventListener(AngleDimensionCreator.CREATE_DONE, freeAngleCreationDone);
			parent1.addChild(creator.result);
			creator.removeEventListener(AngleDimensionCreator.CREATE_CANCEL, freeAngleCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		private function freeAngleCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(AngleDimensionCreator.CREATE_DONE, freeAngleCreationDone);
			creator.removeEventListener(AngleDimensionCreator.CREATE_CANCEL, freeAngleCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		// создание углового размера относительно оси X
		private function createAngleX(e:Event){
			lockAllElements();
			creator = new AngleDimensionCreatorX(parent1, segments);
			creator.addEventListener(AngleDimensionCreatorX.CREATE_DONE, angleXCreationDone);
			creator.addEventListener(AngleDimensionCreatorX.CREATE_CANCEL, angleXCreationCancel);
		}
		private function angleXCreationDone(e:Event){
			unlockAllElements();
			updateAngleDimensions(creator.result);
			anglesX.push(creator.result);
			creator.removeEventListener(AngleDimensionCreatorX.CREATE_DONE, angleXCreationDone);
			parent1.addChild(creator.result);
			creator.removeEventListener(AngleDimensionCreatorX.CREATE_CANCEL, angleXCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		private function angleXCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(AngleDimensionCreatorX.CREATE_DONE, angleXCreationDone);
			creator.removeEventListener(AngleDimensionCreatorX.CREATE_CANCEL, angleXCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		// создание углового размера относительно оси Y
		private function createAngleY(e:Event){
			lockAllElements();
			creator = new AngleDimensionCreatorY(parent1, segments);
			creator.addEventListener(AngleDimensionCreatorY.CREATE_DONE, angleYCreationDone);
			creator.addEventListener(AngleDimensionCreatorY.CREATE_CANCEL, angleYCreationCancel);
		}
		private function angleYCreationDone(e:Event){
			unlockAllElements();
			updateAngleDimensions(creator.result);
			anglesY.push(creator.result);
			creator.removeEventListener(AngleDimensionCreatorY.CREATE_DONE, angleYCreationDone);
			parent1.addChild(creator.result);
			creator.removeEventListener(AngleDimensionCreatorY.CREATE_CANCEL, angleYCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		private function angleYCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(AngleDimensionCreatorY.CREATE_DONE, angleYCreationDone);
			creator.removeEventListener(AngleDimensionCreatorY.CREATE_CANCEL, angleYCreationCancel);
			mainPanel.setButtonsActiveState();
		}

		// создание подвижного шанира
		private function createMovableJoint(e:Event){
			lockAllElements();
			creator = new MovableJointCreator(parent1, segments, lastNonUsedJoint);
			creator.addEventListener(MovableJointCreator.CREATE_DONE, movableJointCreationDone);
			creator.addEventListener(MovableJointCreator.CREATE_CANCEL, movableJointCreationCancel);
		}
		private function movableJointCreationDone(e:Event){
			unlockAllElements();
			opora1.push(creator.result);
			creator.removeEventListener(MovableJointCreator.CREATE_DONE, movableJointCreationDone);
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, pForces, joints);
			parent1.snap = snap1;
			parent1.addChild(creator.result);
			creator.removeEventListener(MovableJointCreator.CREATE_CANCEL, movableJointCreationCancel);
			mainPanel.setButtonsActiveState();
			lastNonUsedJoint++;
		}
		private function movableJointCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(MovableJointCreator.CREATE_DONE, movableJointCreationDone);
			creator.removeEventListener(MovableJointCreator.CREATE_CANCEL, movableJointCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		// создание неподвижного шанира
		private function createFixedJoint(e:Event){
			lockAllElements();
			creator = new FixedJointCreator(parent1, segments, lastNonUsedJoint);
			creator.addEventListener(FixedJointCreator.CREATE_DONE, fixedJointCreationDone);
			creator.addEventListener(FixedJointCreator.CREATE_CANCEL, fixedJointCreationCancel);
		}
		private function fixedJointCreationDone(e:Event){
			unlockAllElements();
			opora2 = creator.result;
			creator.removeEventListener(FixedJointCreator.CREATE_DONE, fixedJointCreationDone);
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, pForces, joints);
			parent1.snap = snap1;
			parent1.addChild(creator.result);
			creator.removeEventListener(FixedJointCreator.CREATE_CANCEL, fixedJointCreationCancel);
			mainPanel.setButtonsActiveState();
			lastNonUsedJoint++;
		}
		private function fixedJointCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(FixedJointCreator.CREATE_DONE, fixedJointCreationDone);
			creator.removeEventListener(FixedJointCreator.CREATE_CANCEL, fixedJointCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		//создание заделки
		private function createSealing(e:Event){
			lockAllElements();
			creator = new SealingCreator(parent1, segments);
			creator.addEventListener(SealingCreator.CREATE_DONE, sealingCreationDone);
			creator.addEventListener(SealingCreator.CREATE_CANCEL, sealingCreationCancel);
		}
		private function sealingCreationDone(e:Event){
			unlockAllElements();
			opora3  = creator.result;
			creator.removeEventListener(SealingCreator.CREATE_DONE, sealingCreationDone);
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, pForces, joints);
			parent1.snap = snap1;
			parent1.addChild(creator.result);
			creator.removeEventListener(SealingCreator.CREATE_CANCEL, sealingCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		private function sealingCreationCancel(e:Event){
			unlockAllElements();
			creator.removeEventListener(SealingCreator.CREATE_DONE, sealingCreationDone);
			creator.removeEventListener(SealingCreator.CREATE_CANCEL, sealingCreationCancel);
			mainPanel.setButtonsActiveState();
		}
		
		private function get joints():Array {
			var jArr = new Array();
			for each ( var op in opora1){
				if(op != null){
					jArr.push(op);
				}
			}
			if(opora2 != null){
				jArr.push(opora2);
			}
			return jArr;
		}
	
		private function updateConcentratedForcesAndAngles(force:ConcentratedForce){
			for each (var f:ConcentratedForce in pForces){
				if(f.forceName == force.forceName){
					f.dimension = force.dimension;
					f.forceValue = force.forceValue;
				}
				if(f.angleName == force.angleName && force.angleName != ""){
					f.angleValue = force.angleValue;
				}
			}
			for each ( var joint in opora1){
				if(joint.angle == force.angleName && force.angleName != ""){
					joint.angleValue = force.angleValue;
				}
			}
			for each (var ang:AngleDimensionContainer in angles){
				if(ang.razmerName == force.angleName){
					ang.razmerValue = force.angleValue;
				}
			}
			for each (ang in anglesX){
				if(ang.razmerName == force.angleName){
					ang.razmerValue = force.angleValue;
				}
			}
			for each (ang in anglesY){
				if(ang.razmerName == force.angleName){
					ang.razmerValue = force.angleValue;
				}
			}
		}
		private function updateMoments(moment:Moment){
			for each ( var m:Moment in mForces){
				if(m.momentName == moment.momentName){
					m.momentValue = moment.momentValue;
					m.dimension = moment.dimension;
				}
			}
		}
		private function updateDistributedForces(q:*){
			for each (var distributedForce in distributedForcesR){
				if(distributedForce.forceName == q.forceName){
					distributedForce.forceValue = q.forceValue;
					distributedForce.dimension = q.dimension;
				}
			}
			for each (distributedForce in distributedForcesT){
				if(distributedForce.forceName == q.forceName){
					distributedForce.forceValue = q.forceValue;
					distributedForce.dimension = q.dimension;
				}
			}
		}
		private function updateLinearDimensions(dimension:*){
			for each (var d in freeDimension){
				if(d.razmerName == dimension.razmerName){
					d.razmerValue = dimension.razmerValue;
					d.dimension = dimension.dimension;
				}
			}
			for each (d in dimensionX){
				if(d.razmerName == dimension.razmerName){
					d.razmerValue = dimension.razmerValue;
					d.dimension = dimension.dimension;
				}
			}
			for each (d in dimensionY){
				if(d.razmerName == dimension.razmerName){
					d.razmerValue = dimension.razmerValue;
					d.dimension = dimension.dimension;
				}
			}
		}
		private function updateAngleDimensions(angle:*){
			if(angle is MovableJointContainer){
				for each (var ang:AngleDimensionContainer in angles){
					if(ang.razmerName == angle.angle){
						ang.razmerValue = angle.angleValue;
					}
				}
				for each (ang in anglesX){
					if(ang.razmerName == angle.angle){
						ang.razmerValue = angle.angleValue;
					}
				}
				for each (ang in anglesY){
					if(ang.razmerName == angle.angle){
						ang.razmerValue = angle.angleValue;
					}
				}
				for each (var f:ConcentratedForce in pForces){
					if(f.angleName == angle.angle){
						f.angleValue = angle.angleValue;
					}
				}
				for each ( var joint in opora1){
					if(joint.angle == angle.angle){
						joint.angleValue = angle.angleValue;
					}
				}
			} else {
				for each (ang in angles){
					if(ang.razmerName == angle.razmerName){
						ang.razmerValue = angle.razmerValue;
					}
				}
				for each (ang in anglesX){
					if(ang.razmerName == angle.razmerName){
						ang.razmerValue = angle.razmerValue;
					}
				}
				for each (ang in anglesY){
					if(ang.razmerName == angle.razmerName){
						ang.razmerValue = angle.razmerValue;
					}
				}
				for each (f in pForces){
					if(f.angleName == angle.razmerName){
						f.angleValue = angle.razmerValue;
					}
				}
				for each ( joint in opora1){
					if(joint.angle == angle.razmerName){
						joint.angleValue = angle.razmerValue;
					}
				}
			}
		}
		private function removeExcessDimensions(screenCoord:Point){
			for each (var f:ConcentratedForce in pForces){
				if(f.x == screenCoord.x && f.y == screenCoord.y) return;
			}
			for each (var q1:DistributedForceR in distributedForcesR){
				if(q1.firstScreenCoord.equals(screenCoord) || q1.secondScreenCoord.equals(screenCoord))
					return;
			}
			for each (var q2:DistributedForceT in distributedForcesT){
				if(q2.firstScreenCoord.equals(screenCoord) || q2.secondScreenCoord.equals(screenCoord))
					return;
			}
			for each (var joint:* in opora1){
				if(joint.x == screenCoord.x && joint.y == screenCoord.y)
					return;
			}
			for each (var seg:Segment in segments){
				if(seg.firstScreenCoord.equals(screenCoord) || seg.secondScreenCoord.equals(screenCoord))
					return;
			}
			if(opora2 != null){
				if(opora2.x == screenCoord.x && opora2.y == screenCoord.y)
					return;
			}
			if(opora3 != null){
				if(opora3.x == screenCoord.x && opora3.y == screenCoord.y)
					return;
			}
			
			for each (var dimF:LinearDimensionContainer in freeDimension){
				if(dimF.firstPointScreenCoord.equals(screenCoord) || dimF.secondPointScreenCoord.equals(screenCoord))
					removeDimension(dimF);
			}
			for each (var dimX:LinearDimensionXContainer in dimensionX){
				if(dimX.firstPointScreenCoord.equals(screenCoord) || dimX.secondPointScreenCoord.equals(screenCoord))
					removeDimension(dimX);
			}
			for each (var dimY:LinearDimensionYContainer in dimensionY){
				if(dimY.firstPointScreenCoord.equals(screenCoord) || dimY.secondPointScreenCoord.equals(screenCoord))
					removeDimension(dimY);
			}
		}
		private function removeDimension(dim){
			for (var i in freeDimension){
				if( dim == freeDimension[i]){
					LinearDimensionContainer(dim).destroy();
					parent1.removeChild(dim);
					freeDimension.splice(i,1)
					return;
				}
			}
			for ( i in dimensionX){
				if( dim == dimensionX[i]){
					LinearDimensionXContainer(dim).destroy();
					parent1.removeChild(dim);
					dimensionX.splice(i,1)
				}
			}
			for ( i in dimensionY){
				if( dim == dimensionY[i]){
					LinearDimensionYContainer(dim).destroy();
					parent1.removeChild(dim);
					dimensionY.splice(i,1)
				}
			}
		}
		
		private function lockAllElements(e:Event = null){
			for each (var element in pForces){
				element.lock();
			}
			for each (element in mForces){
				element.lock();
			}
			for each (element in distributedForcesR){
				element.lock();
			}
			for each (element in distributedForcesT){
				element.lock();
			}
			for each (element in dimensionX){
				element.lock();
			}
			for each (element in dimensionY){
				element.lock();
			}
			for each (element in freeDimension){
				element.lock();
			}
			for each (element in anglesX){
				element.lock();
			}
			for each (element in anglesY){
				element.lock();
			}
			for each (element in angles){
				element.lock();
			}
			for each (element in opora1){
				element.lock();
			}
			if(opora2 != null){
				opora2.lock();
			}
			if(opora3 != null){
				opora3.lock();
			}
		}
		private function unlockAllElements(){
			for each (var element in pForces){
				element.unlock();
			}
			for each (element in mForces){
				element.unlock();
			}
			for each (element in distributedForcesR){
				element.unlock();
			}
			for each (element in distributedForcesT){
				element.unlock();
			}
			for each (element in dimensionX){
				element.unlock();
			}
			for each (element in dimensionY){
				element.unlock();
			}
			for each (element in freeDimension){
				element.unlock();
			}
			for each (element in anglesX){
				element.unlock();
			}
			for each (element in anglesY){
				element.unlock();
			}
			for each (element in angles){
				element.unlock();
			}
			for each (element in opora1){
				element.unlock();
			}
			if(opora2 != null){
				opora2.unlock();
			}
			if(opora3 != null){
				opora3.unlock();
			}
		}
		
		private function onChangeElement(e:Event){
			trace("Изменения в объекте: ", e.target);
			unlockAllElements()
			if(e.target is ConcentratedForce) updateConcentratedForcesAndAngles(ConcentratedForce(e.target));
			if(e.target is Moment) updateMoments(Moment(e.target));
			if(e.target is DistributedForceT || e.target is DistributedForceR) 
				updateDistributedForces(e.target);
			if(e.target is LinearDimensionYContainer || e.target is LinearDimensionXContainer
			   || e.target is LinearDimensionContainer)
			   updateLinearDimensions(e.target);
			if(e.target is AngleDimensionContainer) updateAngleDimensions(e.target);
			if(e.target is MovableJointContainer) updateAngleDimensions(e.target);
		}
		private function onDeleteElement(e:Event){
			trace("Удаление объекта: ", e.target);
			unlockAllElements();
			if(e.target is ConcentratedForce){
				for (var i in pForces){
					if(pForces[i] == e.target){
						pForces.splice(i, 1);
						ConcentratedForce(e.target).destroy();
						parent1.removeChild(ConcentratedForce(e.target));
						removeExcessDimensions(new Point(e.target.x, e.target.y));
					}
				}
			}
			if(e.target is DistributedForceR){
				for (i in distributedForcesR){
					if(distributedForcesR[i] == e.target){
						distributedForcesR.splice(i, 1);
						DistributedForceR(e.target).destroy();
						parent1.removeChild(DistributedForceR(e.target));
						removeExcessDimensions(DistributedForceR(e.target).firstScreenCoord);
						removeExcessDimensions(DistributedForceR(e.target).secondScreenCoord);
					}
				}
			}
			if(e.target is DistributedForceT){
				for (i in distributedForcesT){
					if(distributedForcesT[i] == e.target){
						distributedForcesT.splice(i, 1);
						DistributedForceT(e.target).destroy();
						parent1.removeChild(DistributedForceT(e.target));
						removeExcessDimensions(DistributedForceT(e.target).firstScreenCoord);
						removeExcessDimensions(DistributedForceT(e.target).secondScreenCoord);
					}
				}
			}
			if(e.target is Moment){
				for (i in mForces){
					if(mForces[i] == e.target){
						mForces.splice(i, 1);
						Moment(e.target).destroy();
						parent1.removeChild(Moment(e.target));
						removeExcessDimensions(new Point(e.target.x, e.target.y));
					}
				}
			}
			if(e.target is AngleDimensionContainer){
				for (i in angles){
					if(angles[i] == e.target){
						angles.splice(i, 1);
						AngleDimensionContainer(e.target).destroy();
						parent1.removeChild(AngleDimensionContainer(e.target));
					}
				}
				for ( i in anglesX){
					if(anglesX[i] == e.target){
						anglesX.splice(i, 1);
						AngleDimensionContainer(e.target).destroy();
						parent1.removeChild(AngleDimensionContainer(e.target));
					}
				}
				for (i in anglesY){
					if(anglesY[i] == e.target){
						anglesY.splice(i, 1);
						AngleDimensionContainer(e.target).destroy();
						parent1.removeChild(AngleDimensionContainer(e.target));
					}
				}
			}
			if(e.target is LinearDimensionContainer || e.target is LinearDimensionXContainer
			   || e.target is LinearDimensionYContainer){
				removeDimension(e.target);
			}
			if(e.target is MovableJointContainer){
				for (i in opora1){
					if(opora1[i] == e.target){
						opora1.splice(i, 1);
						MovableJointContainer(e.target).destroy();
						parent1.removeChild(MovableJointContainer(e.target));
						removeExcessDimensions(new Point(e.target.x, e.target.y));
					}
				}
			}
			if(e.target is FixedJointContainer){
				if(opora2 == e.target){
					opora2 = null;
					FixedJointContainer(e.target).destroy();
					parent1.removeChild(FixedJointContainer(e.target));
					removeExcessDimensions(new Point(e.target.x, e.target.y));
				}
			}
			if(e.target is SealingContainer){
				if(opora3 == e.target){
					opora3 = null;
					SealingContainer(e.target).destroy();
					parent1.removeChild(SealingContainer(e.target));
					removeExcessDimensions(new Point(e.target.x, e.target.y));
				}
			}
			mainPanel.setButtonsActiveState();
		}
		
		
		private function onSendData(e:Event){
			createOutData();
			// получаем имя для сохранения файла
			var loader:URLLoader = new URLLoader();
			var req:URLRequest = new URLRequest("http://teormeh.com/index.php?option=com_statr&task=get_name");
			
			// для тестирования
			//var req:URLRequest = new URLRequest("http://teormeh/index.php?option=com_statr&task=get_name");
			
			req.method = URLRequestMethod.POST;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(req);
			loader.addEventListener(Event.COMPLETE, completeHandler);
		}
		private function completeHandler(event:Event):void {
			
        	var loader:URLLoader = URLLoader(event.target);
        	_resolveFileName = loader.data;
			
			
			var bmp:Bitmap = new Bitmap(parent1.getBitmap());
			var brr:ByteArray = PNGEncoder.encode(bmp.bitmapData);
			
			
			var req:URLRequest = new URLRequest("http://teormeh.com/index.php?option=com_statr&task=save_png&name=" + _resolveFileName);
			
			// для тестирования
			//var req:URLRequest = new URLRequest("http://teormeh/index.php?option=com_statr&task=save_png&name=" + _resolveFileName);
			
			req.method = URLRequestMethod.POST;
			req.data = brr;
			req.contentType = "application/octet-stream";

			loader = new URLLoader();
			loader.load(req);
			req = null;
			
			req = new URLRequest("http://teormeh.com/index.php?option=com_statr&task=save_xml&name=" + _resolveFileName);
			
			// для тестирования
			//req = new URLRequest("http://teormeh/index.php?option=com_statr&task=save_xml&name=" + _resolveFileName);
			
			var rhArray:Array = new Array(new URLRequestHeader("Content-Transfer-Encoding", "binary"));

			req.method = URLRequestMethod.POST;
			req.data = this.outData.data;
			req.contentType = "application/octet-stream";
			req.requestHeaders = rhArray;

			loader = new URLLoader();
			loader.load(req);
			
			event.target.removeEventListener(Event.COMPLETE, completeHandler);
			
			this.timer = new Timer(1000, 1);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onTimer);
        }
		
		private function onTimer(e:TimerEvent)
		{
			timer.stop();
			//navigateToURL(new URLRequest('http://teormeh.com/spisok-zadanij.html'), '_self');
			navigateToURL(new URLRequest('http://teormeh.com/index.php?option=com_statr&task=get_solution&name='+_resolveFileName), '_self');
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
		}

		
		private function createOutData(){
			outData.clearLists();
			outData.addPointsListFromSegments(segments);
			outData.addPointsListFromConcentratedForces(pForces);
			outData.addPointsListFromDistributedForcesR(this.distributedForcesR);
			outData.addPointsListFromDistributedForcesT(this.distributedForcesT);
			var a:Array = new Array();
			if(opora3 != null) a.push(opora3);
			if(opora2 != null) a.push(opora2);
			a = a.concat(opora1);
			outData.addPointsListFromJoints(a);
			
			outData.createSegmentsList(segments, pForces,distributedForcesR,distributedForcesT, a);
			outData.createCForcesList(this.pForces);
			outData.createDRForcesList(this.distributedForcesR);
			outData.createDTForcesList(this.distributedForcesT);
			outData.createMomentsList(this.mForces);
			
			a = new Array();
			a = this.dimensionX;
			a = a.concat(this.dimensionY);
			a = a.concat(this.freeDimension);
			outData.createLinearDimensionsList(a);
			
			a = new Array();
			a = this.angles;
			a = a.concat(this.anglesX);
			a = a.concat(this.anglesY);
			outData.createAnglesList(a);
			outData.createJointsList(opora1, opora2, opora3);
			trace(outData.data);
		}
	}
}