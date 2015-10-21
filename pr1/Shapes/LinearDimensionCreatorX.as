package  pr1.Shapes {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	import pr1.Shapes.LinearDimension;
	import pr1.CoordinateTransformation;
	import pr1.ComConst;
	import pr1.windows.EditWindow4;
	import pr1.windows.EditWindow;
	import pr1.razmers.LinearDimensionXContainer;
	import pr1.Snap;
	import pr1.forces.*;
	import pr1.opora.*;
	
	public class LinearDimensionCreatorX extends Sprite {
		// события в объекте
		public static const CREATE_CANCEL:String = "Cancel creation of dimension X";
		public static const CREATE_DONE:String = "Done creation of dimension X";
		// константы для внутреннего использования
		private static const SELECT_FIRST_POINT:int = 0;
		private static const SELECT_SECOND_POINT:int = 1;
		private static const SELECT_HEIGHT:int = 2;
		
		private var parent1:*;
		private var segments:Array;
		private var highlightedSegment:Segment;
		private var snap:Snap;
		private var linearDimension:LinearDimension;	// 
		
		// выходные данные
		private var firstCoordinate:Point; 	// координаты первой точки размера на экране
		private var secondCoordinate:Point; 	// координаты второй точки размера на экране
		private var razmerHeight:Number;
		private var firstPointNumber:int;
		private var secondPointNumber:int;
		private var razmerName:String;
		private var razmerValue:String;
		private var dimension:String;	// размерность размера (м, мм, см)
		
		private var button_up:LinearDimension;
		private var button_over:LinearDimension;
		private var button_down:LinearDimension;
		private var button_hit:LinearDimension;
		//cам элемент нагрузки в полном виде
		private var razmer:LinearDimensionXContainer = null;
		
		private var dialogWnd:EditWindow4;
		
		private var doNow:int;
		
		public function LinearDimensionCreatorX(parent:*, segments:Array) {
			// constructor code
			this.parent1 = parent;
			this.segments = segments;
			this.doNow = SELECT_FIRST_POINT;
			this.highlightedSegment = null;
			
			this.snap = parent1.snap;
			this.linearDimension = new LinearDimension(new Point(0,0), new Point(15,0), -20, 0, 0);
			parent1.addChild(linearDimension);
			parent1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			parent1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseMove(e:MouseEvent){
			switch(doNow){
				case SELECT_FIRST_POINT:
					doSnapToFirstPoint(e);
					break;
				case SELECT_SECOND_POINT:
					doSnapToSecondPoint(e);
					break;
				case SELECT_HEIGHT:
					doMoveHeight(e);
			}
		}
		
				private function doSnapToFirstPoint(e){
					var cursorPosition:Point = new Point(e.stageX, e.stageY);
					var p:Point = snap.doSnapToAnything(cursorPosition);
					linearDimension.x = p.x;
					linearDimension.y = p.y;
				}
		
				private function doSnapToSecondPoint(e:MouseEvent){
					var cursorPosition:Point = new Point(e.stageX, e.stageY);
					var p:Point = snap.doSnapToAnything(cursorPosition);
					parent1.removeChild(linearDimension);
					linearDimension = new LinearDimension(firstCoordinate, p, -20, 0, 0);
					
					linearDimension.x = firstCoordinate.x;
					linearDimension.y = firstCoordinate.y;
					
					parent1.addChild(linearDimension);
				}
		
				private function doMoveHeight(e:MouseEvent){
					var height:Number;
					var cursorPosition:Point = new Point(e.stageX, e.stageY);
					parent1.removeChild(linearDimension);
					
					//находим высоту
					height = firstCoordinate.y - cursorPosition.y;
					razmerHeight = height;
					
					linearDimension = new LinearDimension(firstCoordinate, secondCoordinate, height, 0, 0);
					button_over = new LinearDimension(firstCoordinate, secondCoordinate, height, 0, 0xff);
					button_up = new LinearDimension(firstCoordinate, secondCoordinate, height, 0, 0);
					button_down = button_up;
					button_hit = button_up;
					
					linearDimension.x = firstCoordinate.x;
					linearDimension.y = firstCoordinate.y;
					parent1.addChild(linearDimension);
				}
		
		private function onMouseDown(e:MouseEvent){
			switch(doNow){
				case SELECT_FIRST_POINT:
					doSelectFirstPoint(e);
					break;
				case SELECT_SECOND_POINT:
					doSelectSecondPoint(e);
					break;
				case SELECT_HEIGHT:
					doSelectHeight(e);
			}
		}
		

		private function doSelectFirstPoint(e:MouseEvent){
			var cursorPosition:Point = new Point(e.stageX, e.stageY);
			var p:Point = snap.doSnapToAnything(cursorPosition);
			if(snap.lastSnappedObject is Segment){
				if(p.equals(snap.lastSnappedObject.firstScreenCoord)){
				   this.firstPointNumber = snap.lastSnappedObject.firstPointNumber;
				   firstCoordinate = p;
				   doNow = SELECT_SECOND_POINT;
				} else if(p.equals(snap.lastSnappedObject.secondScreenCoord)){
				   this.firstPointNumber = snap.lastSnappedObject.secondPointNumber;
				   firstCoordinate = p;
				   doNow = SELECT_SECOND_POINT;
				}
			}
			
			if(snap.lastSnappedObject is ConcentratedForce){
				this.firstPointNumber = snap.lastSnappedObject.forceNumber;
				firstCoordinate = p;
				doNow = SELECT_SECOND_POINT;
			}
			
			if(snap.lastSnappedObject is DistributedForceR || snap.lastSnappedObject is DistributedForceT){
				if(p.equals(snap.lastSnappedObject.firstScreenCoord)){
					this.firstPointNumber = snap.lastSnappedObject.forceNumber1;
					firstCoordinate = p;
					doNow = SELECT_SECOND_POINT;
				}
				if(p.equals(snap.lastSnappedObject.secondScreenCoord)){
					this.firstPointNumber = snap.lastSnappedObject.forceNumber2;
					firstCoordinate = p;
					doNow = SELECT_SECOND_POINT;
				}
			}
			if(snap.lastSnappedObject is MovableJointContainer || snap.lastSnappedObject is FixedJointContainer
			   || snap.lastSnappedObject is SealingContainer){
				if(p.x == snap.lastSnappedObject.x && p.y == snap.lastSnappedObject.y){
					this.firstPointNumber = snap.lastSnappedObject.pointNumber;
					firstCoordinate = p;
					doNow = SELECT_SECOND_POINT;
				}
			}
			
			linearDimension.x = p.x;
			linearDimension.y = p.y;
		}
				
		private function doSelectSecondPoint(e:MouseEvent){
			var cursorPosition:Point = new Point(e.stageX, e.stageY);
			var p:Point = snap.doSnapToAnything(cursorPosition);
			if(p.equals(firstCoordinate)) return;
			if(snap.lastSnappedObject is Segment){
				if(p.equals(snap.lastSnappedObject.firstScreenCoord)){
				   this.secondPointNumber = snap.lastSnappedObject.firstPointNumber;
				   secondCoordinate = p;
				   doNow = SELECT_HEIGHT;
				} else if(p.equals(snap.lastSnappedObject.secondScreenCoord)){
				   this.secondPointNumber = snap.lastSnappedObject.secondPointNumber;
				   secondCoordinate = p;
				   doNow = SELECT_HEIGHT;
				}
			}
			
			if(snap.lastSnappedObject is ConcentratedForce){
				this.secondPointNumber = snap.lastSnappedObject.forceNumber;
				secondCoordinate = p;
				doNow = SELECT_HEIGHT;
			}
			
			if(snap.lastSnappedObject is DistributedForceR || snap.lastSnappedObject is DistributedForceT){
				if(p.equals(snap.lastSnappedObject.firstScreenCoord)){
					this.secondPointNumber = snap.lastSnappedObject.forceNumber1;
					secondCoordinate = p;
					doNow = SELECT_HEIGHT;
				}
				if(p.equals(snap.lastSnappedObject.secondScreenCoord)){
					this.secondPointNumber = snap.lastSnappedObject.forceNumber2;
					secondCoordinate = p;
					doNow = SELECT_HEIGHT;
				}
			}
			if(snap.lastSnappedObject is MovableJointContainer || snap.lastSnappedObject is FixedJointContainer
			   || snap.lastSnappedObject is SealingContainer){
				if(p.x == snap.lastSnappedObject.x && p.y == snap.lastSnappedObject.y){
					this.secondPointNumber = snap.lastSnappedObject.pointNumber;
					secondCoordinate = p;
					doNow = SELECT_HEIGHT;
				}
			}
		}
		
		private function doSelectHeight(e:MouseEvent){
			// убираем всех прослушивателей событий
			parent1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			parent1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

			dialogWnd = new EditWindow4("","");
			parent1.addChild(dialogWnd);
			dialogWnd.x = 400;
			dialogWnd.y = 300;
			dialogWnd.addEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
			dialogWnd.addEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);
		}
		
						private function onEndEditInDialogWindow(e:Event){
							dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
							dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

							parent1.removeChild(dialogWnd);
							parent1.removeChild(linearDimension);
			
							razmerName = dialogWnd.razmer;
							razmerValue = dialogWnd.value;
							dimension = dialogWnd.dimension;
							dialogWnd = null;
							doCreateLinearDimension();
							dispatchEvent(new Event(LinearDimensionCreatorX.CREATE_DONE));
						}
		
								private function doCreateLinearDimension(){
									var p:Point;
									var angle:Number;
									razmer = new LinearDimensionXContainer(parent1, button_up, button_over, button_down, button_hit,
																  razmerName);
									razmer.dimension = dimension;
									razmer.razmerValue = razmerValue;
									razmer.razmerName = razmerName;
									
									razmer.firstPointDecartCoord = CoordinateTransformation.screenToLocal(firstCoordinate, new Point(0,600),0);
									razmer.secondPointDecartCoord = CoordinateTransformation.screenToLocal(secondCoordinate, new Point(0,600),0);
									razmer.firstPointScreenCoord = firstCoordinate;
									razmer.secondPointScreenCoord = secondCoordinate;
									razmer.x = firstCoordinate.x;
									razmer.y = firstCoordinate.y;
									
									razmer.razmerHeight = razmerHeight;
									razmer.setCoordOfRazmerName();
									
								}
		
						private function onCancelEditInDialogWindow(e:Event){
							dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
							dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

							parent1.removeChild(dialogWnd);
							parent1.removeChild(linearDimension);
							
							dialogWnd = null;
							dispatchEvent(new Event(LinearDimensionCreatorX.CREATE_CANCEL));
						}
		
		public function get result():LinearDimensionXContainer{
			return razmer;
		}

	}
	
}
