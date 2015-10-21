package  pr1.tests {
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import pr1.Shapes.SegmentCreator;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import pr1.Shapes.ConcentratedForceCreator;
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
	import pr1.opora.SealingContainer;
	import pr1.opora.FixedJointContainer;
	import pr1.Shapes.FixedJointCreator;
	import pr1.opora.MovableJointContainer;
	import pr1.Shapes.MovableJointCreator;

	
	public class TestSegments extends Sprite {
		
		private var segments:Array;
		private var forces:Array;
		private var moments:Array;
		private var distributedForcesR:Array;
		private var distributedForcesT:Array;
		private var linearDimensions:Array;
		private var angleDimensions:Array;
		private var segCreator:SegmentCreator;
		private var pCreator:ConcentratedForceCreator;
		private var mCreator:MomentCreator;
		private var q1Creator:DistributedForceRCreator;
		private var q2Creator:DistributedForceTCreator;
		private var freeLRazmerCreator:LinearDimensionCreator;
		private var xLRazmerCreator:LinearDimensionCreatorX;
		private var yLRazmerCreator:LinearDimensionCreatorY;
		private var freeARazmerCreator:AngleDimensionCreator;
		private var xARazmerCreator:AngleDimensionCreatorX;
		private var yARazmerCreator:AngleDimensionCreatorY;
		private var sealingCreator:SealingCreator;
		private var sealing:SealingContainer;
		private var fixedJointCreator:FixedJointCreator;
		private var fixedJoint:FixedJointContainer;
		private var movableJointCreator:MovableJointCreator;
		private var movableJoint:MovableJointContainer;
		private var spr:Workspace;
		private var snap1:Snap;
		
		public function TestSegments() {
			// constructor code
			spr = new Workspace();
			spr.graphics.beginFill(0xffffff, 0);
			spr.graphics.drawRect(0,0,800,600);
			spr.graphics.endFill();
			addChild(spr);
			spr.x = 0;
			spr.y = 0;
			segments = new Array();
			forces = new Array();
			moments = new Array();
			distributedForcesR = new Array();
			distributedForcesT = new Array();
			linearDimensions = new Array();
			angleDimensions = new Array();
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, forces);
			spr.snap = snap1;
			spr.addEventListener(Event.ACTIVATE, onStage);
			
		}
		
		public function get snap():Snap{
			return snap1;
		}
		
		private function onStage(e:Event){
			spr.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			spr.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent){
			
		}
		
		private function onKeyDown(e:KeyboardEvent){
			if(e.keyCode == Keyboard.F1){
				segCreator = new SegmentCreator(spr, segments);
				segCreator.addEventListener(SegmentCreator.CREATE_DONE, segmentCreationDone);
				segCreator.addEventListener(SegmentCreator.CANCEL, segmentCreationCancel);
			} else if(e.keyCode == Keyboard.F2){
				pCreator = new ConcentratedForceCreator(spr, segments, 1000);
				pCreator.addEventListener(ConcentratedForceCreator.CREATE_DONE, forceCreationDone);
				pCreator.addEventListener(ConcentratedForceCreator.CREATE_CANCEL, forceCreationCancel);
			} else if(e.keyCode == Keyboard.F3){
				mCreator = new MomentCreator(spr, segments, 2000);
				mCreator.addEventListener(ConcentratedForceCreator.CREATE_DONE, momentCreationDone);
				mCreator.addEventListener(ConcentratedForceCreator.CREATE_CANCEL, momentCreationCancel);
			} else if(e.keyCode == Keyboard.F4){
				q1Creator = new DistributedForceRCreator(spr, segments, 3000);
				q1Creator.addEventListener(DistributedForceRCreator.CREATE_DONE, q1CreationDone);
				q1Creator.addEventListener(DistributedForceRCreator.CREATE_CANCEL, q1CreationCancel);
			} else if(e.keyCode == Keyboard.F5){
				q2Creator = new DistributedForceTCreator(spr, segments, 4000);
				q2Creator.addEventListener(DistributedForceTCreator.CREATE_DONE, q2CreationDone);
				q2Creator.addEventListener(DistributedForceTCreator.CREATE_CANCEL, q2CreationCancel);
			} else if(e.keyCode == Keyboard.F6){
				freeLRazmerCreator = new LinearDimensionCreator(spr, segments);
				freeLRazmerCreator.addEventListener(LinearDimensionCreator.CREATE_DONE, freeRazmerCreationDone);
				freeLRazmerCreator.addEventListener(LinearDimensionCreator.CREATE_CANCEL, freeRazmerCreationCancel);
			} else if(e.keyCode == Keyboard.F7){
				xLRazmerCreator = new LinearDimensionCreatorX(spr, segments);
				xLRazmerCreator.addEventListener(LinearDimensionCreatorX.CREATE_DONE, xRazmerCreationDone);
				xLRazmerCreator.addEventListener(LinearDimensionCreatorX.CREATE_CANCEL, xRazmerCreationCancel);
			} else if(e.keyCode == Keyboard.F8){
				yLRazmerCreator = new LinearDimensionCreatorY(spr, segments);
				yLRazmerCreator.addEventListener(LinearDimensionCreatorY.CREATE_DONE, yRazmerCreationDone);
				yLRazmerCreator.addEventListener(LinearDimensionCreatorY.CREATE_CANCEL, yRazmerCreationCancel);
			} else if(e.keyCode == Keyboard.F9){
				freeARazmerCreator = new AngleDimensionCreator(spr, segments);
				freeARazmerCreator.addEventListener(AngleDimensionCreator.CREATE_DONE, angleRazmerCreationDone);
				freeARazmerCreator.addEventListener(AngleDimensionCreator.CREATE_CANCEL, angleRazmerCreationCancel);
			}  else if(e.keyCode == Keyboard.F11){
				fixedJointCreator = new FixedJointCreator(spr, segments);
				fixedJointCreator.addEventListener(FixedJointCreator.CREATE_DONE, fixedJointCreationDone);
				fixedJointCreator.addEventListener(FixedJointCreator.CREATE_CANCEL, fixedJointCreationCancel);
			} else if(e.keyCode == Keyboard.F12){
				sealingCreator = new SealingCreator(spr, segments);
				sealingCreator.addEventListener(SealingCreator.CREATE_DONE, sealingCreationDone);
				sealingCreator.addEventListener(SealingCreator.CREATE_CANCEL, sealingCreationCancel);
			} else if(e.keyCode == Keyboard.M){
				movableJointCreator = new MovableJointCreator(spr, segments);
				movableJointCreator.addEventListener(MovableJointCreator.CREATE_DONE, movableJointCreationDone);
				movableJointCreator.addEventListener(MovableJointCreator.CREATE_CANCEL, movableJointCreationCancel);
			} else if(e.keyCode == Keyboard.X){
				xARazmerCreator = new AngleDimensionCreatorX(spr, segments);
				xARazmerCreator.addEventListener(AngleDimensionCreatorX.CREATE_DONE, angleXRazmerCreationDone);
				xARazmerCreator.addEventListener(AngleDimensionCreatorX.CREATE_CANCEL, angleXRazmerCreationCancel);
			} else if(e.keyCode == Keyboard.Y){
				yARazmerCreator = new AngleDimensionCreatorY(spr, segments);
				yARazmerCreator.addEventListener(AngleDimensionCreatorY.CREATE_DONE, angleYRazmerCreationDone);
				yARazmerCreator.addEventListener(AngleDimensionCreatorY.CREATE_CANCEL, angleYRazmerCreationCancel);
			}
		}

		private function segmentCreationDone(e:Event){
			segments.push(segCreator.segment);
			segCreator.removeEventListener(SegmentCreator.CREATE_DONE, segmentCreationDone);
			spr.addChild(segCreator.segment);
			segCreator.removeEventListener(SegmentCreator.CANCEL, segmentCreationCancel);
		}
		
		private function segmentCreationCancel(e:Event){
			segCreator.removeEventListener(SegmentCreator.CREATE_DONE, segmentCreationDone);
			segCreator.removeEventListener(SegmentCreator.CANCEL, segmentCreationCancel);
		}
		
		private function forceCreationDone(e:Event){
			var a = pCreator;
			forces.push(pCreator.result);
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, forces);
			spr.snap = snap1;
			pCreator.removeEventListener(ConcentratedForceCreator.CREATE_DONE, forceCreationDone);
			spr.addChild(pCreator.result);
			pCreator.removeEventListener(ConcentratedForceCreator.CREATE_CANCEL, forceCreationCancel);
		}
		
		private function forceCreationCancel(e:Event){
			pCreator.removeEventListener(ConcentratedForceCreator.CREATE_DONE, forceCreationDone);
			pCreator.removeEventListener(ConcentratedForceCreator.CREATE_CANCEL, forceCreationCancel);
		}
		
		private function momentCreationDone(e:Event){
			moments.push(mCreator.result);
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, forces);
			mCreator.removeEventListener(ConcentratedForceCreator.CREATE_DONE, momentCreationDone);
			spr.addChild(mCreator.result);
			mCreator.removeEventListener(ConcentratedForceCreator.CREATE_CANCEL, momentCreationCancel);
		}
		
		private function momentCreationCancel(e:Event){
			mCreator.removeEventListener(ConcentratedForceCreator.CREATE_DONE, momentCreationDone);
			mCreator.removeEventListener(ConcentratedForceCreator.CREATE_CANCEL, momentCreationCancel);
		}
		
		private function q1CreationDone(e:Event){
			distributedForcesR.push(q1Creator.result);
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, forces);
			q1Creator.removeEventListener(DistributedForceRCreator.CREATE_DONE, q1CreationDone);
			spr.addChild(q1Creator.result);
			q1Creator.removeEventListener(DistributedForceRCreator.CREATE_CANCEL, q1CreationCancel);
		}
		
		private function q1CreationCancel(e:Event){
			q1Creator.removeEventListener(DistributedForceRCreator.CREATE_DONE, q1CreationDone);
			q1Creator.removeEventListener(DistributedForceRCreator.CREATE_CANCEL, q1CreationCancel);
		}
		
		private function q2CreationDone(e:Event){
			distributedForcesT.push(q2Creator.result);
			snap1 = new Snap(segments,distributedForcesR, distributedForcesT, forces);
			q2Creator.removeEventListener(DistributedForceRCreator.CREATE_DONE, q2CreationDone);
			spr.addChild(q2Creator.result);
			q2Creator.removeEventListener(DistributedForceRCreator.CREATE_CANCEL, q2CreationCancel);
		}
		
		private function q2CreationCancel(e:Event){
			q2Creator.removeEventListener(DistributedForceRCreator.CREATE_DONE, q2CreationDone);
			q2Creator.removeEventListener(DistributedForceRCreator.CREATE_CANCEL, q2CreationCancel);
		}
		
		private function freeRazmerCreationDone(e:Event){
			linearDimensions.push(freeLRazmerCreator.result);
			freeLRazmerCreator.removeEventListener(LinearDimensionCreator.CREATE_DONE, freeRazmerCreationDone);
			spr.addChild(freeLRazmerCreator.result);
			freeLRazmerCreator.removeEventListener(LinearDimensionCreator.CREATE_CANCEL, freeRazmerCreationCancel);
		}
		
		private function freeRazmerCreationCancel(e:Event){
			freeLRazmerCreator.removeEventListener(LinearDimensionCreator.CREATE_DONE, freeRazmerCreationDone);
			freeLRazmerCreator.removeEventListener(LinearDimensionCreator.CREATE_CANCEL, freeRazmerCreationCancel);
		}
		
		private function xRazmerCreationDone(e:Event){
			linearDimensions.push(xLRazmerCreator.result);
			xLRazmerCreator.removeEventListener(LinearDimensionCreatorX.CREATE_DONE, xRazmerCreationDone);
			spr.addChild(xLRazmerCreator.result);
			xLRazmerCreator.removeEventListener(LinearDimensionCreatorX.CREATE_CANCEL, xRazmerCreationCancel);
		}
		
		private function xRazmerCreationCancel(e:Event){
			xLRazmerCreator.removeEventListener(LinearDimensionCreatorX.CREATE_DONE, xRazmerCreationDone);
			xLRazmerCreator.removeEventListener(LinearDimensionCreatorX.CREATE_CANCEL, xRazmerCreationCancel);
		}
		
		private function yRazmerCreationDone(e:Event){
			linearDimensions.push(yLRazmerCreator.result);
			yLRazmerCreator.removeEventListener(LinearDimensionCreatorY.CREATE_DONE, yRazmerCreationDone);
			spr.addChild(yLRazmerCreator.result);
			yLRazmerCreator.removeEventListener(LinearDimensionCreatorY.CREATE_CANCEL, yRazmerCreationCancel);
		}
		
		private function yRazmerCreationCancel(e:Event){
			yLRazmerCreator.removeEventListener(LinearDimensionCreatorY.CREATE_DONE, yRazmerCreationDone);
			yLRazmerCreator.removeEventListener(LinearDimensionCreatorY.CREATE_CANCEL, yRazmerCreationCancel);
		}
		
		private function angleRazmerCreationDone(e:Event){
			this.angleDimensions.push(freeARazmerCreator.result);
			freeARazmerCreator.removeEventListener(AngleDimensionCreator.CREATE_DONE, angleRazmerCreationDone);
			spr.addChild(freeARazmerCreator.result);
			freeARazmerCreator.removeEventListener(AngleDimensionCreator.CREATE_CANCEL, angleRazmerCreationCancel);
		}
		
		private function angleRazmerCreationCancel(e:Event){
			freeARazmerCreator.removeEventListener(AngleDimensionCreator.CREATE_DONE, angleRazmerCreationDone);
			freeARazmerCreator.removeEventListener(AngleDimensionCreator.CREATE_CANCEL, angleRazmerCreationCancel);
		}
		
		private function sealingCreationDone(e:Event){
			this.sealing  = sealingCreator.result;
			sealingCreator.removeEventListener(SealingCreator.CREATE_DONE, sealingCreationDone);
			spr.addChild(sealingCreator.result);
			sealingCreator.removeEventListener(SealingCreator.CREATE_CANCEL, sealingCreationCancel);
		}
		
		private function sealingCreationCancel(e:Event){
			sealingCreator.removeEventListener(SealingCreator.CREATE_DONE, sealingCreationDone);
			sealingCreator.removeEventListener(SealingCreator.CREATE_CANCEL, sealingCreationCancel);
		}
		
		private function fixedJointCreationDone(e:Event){
			this.fixedJoint  = fixedJointCreator.result;
			fixedJointCreator.removeEventListener(FixedJointCreator.CREATE_DONE, fixedJointCreationDone);
			spr.addChild(fixedJointCreator.result);
			fixedJointCreator.removeEventListener(FixedJointCreator.CREATE_CANCEL, fixedJointCreationCancel);
		}
		
		private function fixedJointCreationCancel(e:Event){
			fixedJointCreator.removeEventListener(FixedJointCreator.CREATE_DONE, fixedJointCreationDone);
			fixedJointCreator.removeEventListener(FixedJointCreator.CREATE_CANCEL, fixedJointCreationCancel);
		}
		
		private function movableJointCreationDone(e:Event){
			this.movableJoint  = movableJointCreator.result;
			movableJointCreator.removeEventListener(MovableJointCreator.CREATE_DONE, movableJointCreationDone);
			spr.addChild(movableJointCreator.result);
			movableJointCreator.removeEventListener(MovableJointCreator.CREATE_CANCEL, movableJointCreationCancel);
		}
		
		private function movableJointCreationCancel(e:Event){
			movableJointCreator.removeEventListener(MovableJointCreator.CREATE_DONE, movableJointCreationDone);
			movableJointCreator.removeEventListener(MovableJointCreator.CREATE_CANCEL, movableJointCreationCancel);
		}
		
		private function angleXRazmerCreationDone(e:Event){
			this.angleDimensions.push(xARazmerCreator.result);
			xARazmerCreator.removeEventListener(AngleDimensionCreatorX.CREATE_DONE, angleXRazmerCreationDone);
			spr.addChild(xARazmerCreator.result);
			xARazmerCreator.removeEventListener(AngleDimensionCreatorX.CREATE_CANCEL, angleXRazmerCreationCancel);
		}
		
		private function angleXRazmerCreationCancel(e:Event){
			xARazmerCreator.removeEventListener(AngleDimensionCreatorX.CREATE_DONE, angleXRazmerCreationDone);
			xARazmerCreator.removeEventListener(AngleDimensionCreatorX.CREATE_CANCEL, angleXRazmerCreationCancel);
		}
		
		private function angleYRazmerCreationDone(e:Event){
			this.angleDimensions.push(yARazmerCreator.result);
			yARazmerCreator.removeEventListener(AngleDimensionCreatorY.CREATE_DONE, angleYRazmerCreationDone);
			spr.addChild(yARazmerCreator.result);
			yARazmerCreator.removeEventListener(AngleDimensionCreatorY.CREATE_CANCEL, angleYRazmerCreationCancel);
		}
		
		private function angleYRazmerCreationCancel(e:Event){
			yARazmerCreator.removeEventListener(AngleDimensionCreatorY.CREATE_DONE, angleYRazmerCreationDone);
			yARazmerCreator.removeEventListener(AngleDimensionCreatorY.CREATE_CANCEL, angleYRazmerCreationCancel);
		}
		
	}
	
}
