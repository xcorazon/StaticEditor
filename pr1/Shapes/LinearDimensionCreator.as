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
	import pr1.razmers.LinearDimensionContainer;
	import pr1.Snap;
	
	public class LinearDimensionCreator extends Sprite {
		// события в объекте
		public static const CREATE_CANCEL:String = "Cancel creation of dimension";
		public static const CREATE_DONE:String = "Done creation of dimension";
		// константы для внутреннего использования
		private static const SELECT_SEGMENT:int = 0;
		private static const SELECT_POSITION1:int = 1;
		private static const SELECT_POSITION2:int = 2;
		private static const SELECT_HEIGHT:int = 3;
		
		private var parent1:*;
		private var segments:Array;
		private var highlightedSegment:Segment;
		private var snap:Snap;
		private var linearDimensionF:LinearDimension;	// 
		
		// выходные данные
		private var firstCoordinate:Point; 	// координаты первой точки размера на экране
		private var secondCoordinate:Point; 	// координаты второй точки размера на экране
		private var razmerHeight:Number;
		private var angle1:Number;
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
		private var razmer:LinearDimensionContainer = null;
		
		private var dialogWnd:EditWindow4;
		
		private var doNow:int;
		
		public function LinearDimensionCreator(parent:*, segments:Array) {
			// constructor code
			this.parent1 = parent;
			this.segments = segments;
			this.doNow = SELECT_SEGMENT;
			this.highlightedSegment = null;
			
			this.snap = parent1.snap;
			parent1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			parent1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseMove(e:MouseEvent){
			switch(doNow){
				case SELECT_SEGMENT:
					doHighlightSegment(e);
					break;
				case SELECT_POSITION1:
					doMoveFirstPoint(e);
					break;
				case SELECT_POSITION2:
					doMoveSecondPoint(e);
					break;
				case SELECT_HEIGHT:
					doMoveHeight(e);
			}
		}
		
				private function doHighlightSegment(e){
					var cursorPosition:Point = new Point(e.stageX, e.stageY);
					var thres:Number = 8;
					var tempSegment:Segment = null;
					var tempThres:Number;
			
					for each (var seg in this.segments){
						tempThres = snap.distance(cursorPosition, seg);
						if( tempThres <= thres){
							tempSegment = seg;
							thres = tempThres;
						}
					}
			
					if(highlightedSegment != null){
						if(tempSegment == null){
							highlightedSegment.setColor(0x0);
							highlightedSegment = null;
							return;
						} else {
							highlightedSegment.setColor(0x0);
							highlightedSegment = tempSegment;
							highlightedSegment.setColor(0xff);
							return;
						}
					} else {
						if(tempSegment != null){
							highlightedSegment = tempSegment;
							highlightedSegment.setColor(0xff);
							return;
						}
					}
				}
		
				private function doMoveFirstPoint(e:MouseEvent){
					var p:Point;
					var cursorPosition:Point = new Point(e.stageX, e.stageY);
					p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
					p = snap.doSnapToForce(p, highlightedSegment);
					this.linearDimensionF.x = p.x;
					this.linearDimensionF.y = p.y;
					firstCoordinate = p;
				}
				
				private function doMoveSecondPoint(e:MouseEvent){
					var p:Point;
					var cursorPosition:Point = new Point(e.stageX, e.stageY);
					p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
					p = snap.doSnapToForce(p, highlightedSegment);
					parent1.removeChild(linearDimensionF);
					linearDimensionF = new LinearDimension(firstCoordinate, p, 20, this.angle1, 0x0);
					parent1.addChild(linearDimensionF);
					this.linearDimensionF.x = firstCoordinate.x;
					this.linearDimensionF.y = firstCoordinate.y;
					secondCoordinate = p;
				}
		
				private function doMoveHeight(e:MouseEvent){
					var height:Number;
					var cursorPosition:Point = new Point(e.stageX, e.stageY);
					var localCoordSysPosition:Point = firstCoordinate;
					parent1.removeChild(linearDimensionF);
					
					//находим высоту
					var p = CoordinateTransformation.screenToLocal(cursorPosition,localCoordSysPosition, this.angle1);
					height = p.y;
					razmerHeight = height;
					
					linearDimensionF = new LinearDimension(firstCoordinate, secondCoordinate, height, this.angle1, 0);
					button_over = new LinearDimension(firstCoordinate, secondCoordinate, height, this.angle1, 0xff);
					button_up = new LinearDimension(firstCoordinate, secondCoordinate, height, this.angle1, 0);
					button_down = button_up;
					button_hit = button_up;
					
					linearDimensionF.x = firstCoordinate.x;
					linearDimensionF.y = firstCoordinate.y;
					parent1.addChild(linearDimensionF);
				}
		
		private function onMouseDown(e:MouseEvent){
			switch(doNow){
				case SELECT_SEGMENT:
					doSelectSegment(e);
					break;
				case SELECT_POSITION1:
					doSelectFirstPoint(e);
					break;
				case SELECT_POSITION2:
					doSelectSecondPoint(e);
					break;
				case SELECT_HEIGHT:
					doSelectHeight(e);
			}
		}
		
				private function doSelectSegment(e:MouseEvent){
					var p:Point;
					var positionOfFirstPoint:Point;
					var positionOfSecondPoint:Point;
					if( this.highlightedSegment != null){
						p = highlightedSegment.secondDecartCoord.subtract(highlightedSegment.firstDecartCoord);
						this.angle1 = CoordinateTransformation.decartToPolar(p).y;
						doNow = SELECT_POSITION1;
						highlightedSegment.setColor(0x0);
						positionOfFirstPoint = snap.doSnapToSegment( new Point(e.stageX, e.stageY), highlightedSegment);
						positionOfSecondPoint = CoordinateTransformation.localToScreen(new Point(15,0),positionOfFirstPoint, this.angle1);
						linearDimensionF = new LinearDimension(positionOfFirstPoint, positionOfSecondPoint, 10, this.angle1, 0x0);
						parent1.addChild(linearDimensionF);
						linearDimensionF.x = positionOfFirstPoint.x;
						linearDimensionF.y = positionOfFirstPoint.y;
						firstCoordinate = positionOfFirstPoint;
					}
				}

				private function doSelectFirstPoint(e:MouseEvent){
					var p:Point;
					var p1:Point;
					var cursorPosition:Point = new Point(e.stageX, e.stageY);
					p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
					p1 = snap.doSnapToForce(p, highlightedSegment);
					if( !p.equals(p1) || p1.equals(highlightedSegment.firstScreenCoord) 
					   				  || p1.equals(highlightedSegment.secondScreenCoord)){
						this.linearDimensionF.x = p1.x;
						this.linearDimensionF.y = p1.y;
						firstCoordinate = p1;
						doNow = SELECT_POSITION2;
					}
				}
				
				private function doSelectSecondPoint(e:MouseEvent){
					var p:Point;
					var p1:Point;
					var cursorPosition:Point = new Point(e.stageX, e.stageY);
					
					p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
					p1 = snap.doSnapToForce(p, highlightedSegment);
					if(p1.equals(firstCoordinate)) return;
					if(p1.equals(highlightedSegment.firstScreenCoord) 
					   || p1.equals(highlightedSegment.secondScreenCoord)
					   || !p1.equals(p)){
						secondCoordinate = p1;
						doNow = SELECT_HEIGHT;
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
							parent1.removeChild(linearDimensionF);
			
							razmerName = dialogWnd.razmer;
							razmerValue = dialogWnd.value;
							dimension = dialogWnd.dimension;
							dialogWnd = null;
							doCreateLinearDimension();
							dispatchEvent(new Event(LinearDimensionCreator.CREATE_DONE));
						}
		
								private function doCreateLinearDimension(){
									var p:Point;
									var angle:Number;
									razmer = new LinearDimensionContainer(parent1, button_up, button_over, button_down, button_hit,
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
									
									p = razmer.secondPointDecartCoord.subtract(razmer.firstPointDecartCoord);
									angle = CoordinateTransformation.decartToPolar(p).y;
									if(Math.abs(angle1 - angle) >= 0.0001 ){
										razmerHeight = - razmerHeight;
									}
									
									razmer.razmerHeight = razmerHeight;
									razmer.setCoordOfRazmerName();
									
									
								}
		
						private function onCancelEditInDialogWindow(e:Event){
							dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
							dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

							parent1.removeChild(dialogWnd);
							parent1.removeChild(linearDimensionF);
							
							dialogWnd = null;
							dispatchEvent(new Event(LinearDimensionCreator.CREATE_CANCEL));
						}
		
		public function get result():LinearDimensionContainer{
			return razmer;
		}

	}
	
}
