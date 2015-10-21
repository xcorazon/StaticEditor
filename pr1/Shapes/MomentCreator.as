package  pr1.Shapes {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	import pr1.panels.MomentPanel;
	import pr1.Shapes.ArcArrow;
	import pr1.CoordinateTransformation;
	import pr1.ComConst;
	import pr1.windows.EditWindowMoment;
	import pr1.windows.EditWindow;
	import pr1.forces.Moment;
	import pr1.Snap;
	
	public class MomentCreator extends Sprite {
		// события в объекте
		public static const CREATE_CANCEL:String = "Cancel creation of moment";
		public static const CREATE_DONE:String = "Done creation of moment";
		// константы для внутреннего использования
		private static const SELECT_SEGMENT:int = 0;
		private static const SELECT_POSITION:int = 1;
		private static const SELECT_ANGLE:int = 2;
		
		private var parent1:*;
		private var segments:Array;
		private var momentNumber:int;
		private var highlightedSegment:Segment;
		private var panel:MomentPanel;
		private var snap:Snap;
		
		// выходные данные
		private var arrow:ArcArrow;
		private var arrowAngle:Number;
		private var arrowCoordinates:Point; 	// координаты стрелки на экране
		private var momentName:String;
		private var momentValue:String;
		private var dimension:String;
		private var isClockWise:Boolean;
		
		private var button_up:ArcArrow;
		private var button_over:ArcArrow;
		private var button_down:ArcArrow;
		private var button_hit:ArcArrow;
		//cам элемент нагрузки в полном виде
		private var moment:Moment = null;
		
		private var dialogWnd:EditWindowMoment;
		
		private var doNow:int;
		
		public function MomentCreator(parent:*, segments:Array, lastNonusedForceNumber:int){
			this.parent1 = parent;
			this.segments = segments;
			this.doNow = SELECT_SEGMENT;
			this.highlightedSegment = null;
			this.momentNumber = lastNonusedForceNumber;
			snap = parent1.snap;
			
			parent1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			parent1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseMove(e:MouseEvent){
			switch(doNow){
				case SELECT_SEGMENT:
					doHighlightSegment(e);
					break;
				case SELECT_POSITION:
					doMoveArrow(e);
					break;
				case SELECT_ANGLE:
					doRotateArrow(e);
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
		
				private function doMoveArrow(e:MouseEvent){
					var p:Point;
					var cursorPosition:Point = new Point(e.stageX, e.stageY);
					p = snap.doSnapToSegment(cursorPosition, highlightedSegment);
					p = snap.doSnapToForce(p, highlightedSegment);
					this.arrow.x = p.x;
					this.arrow.y = p.y;
					arrowCoordinates = p;
				}
		
				private function doRotateArrow(e:MouseEvent){
					var cursorPosition:Point = new Point(e.stageX, e.stageY);
					parent1.removeChild(arrow);
					arrow = new ArcArrow(arrowCoordinates, cursorPosition, panel.isMomentClockWise, 0);
					button_over = new ArcArrow(arrowCoordinates, cursorPosition, panel.isMomentClockWise, 0xff);
					button_up = new ArcArrow(arrowCoordinates, cursorPosition, panel.isMomentClockWise, 0);
					button_down = button_up;
					button_hit = button_up;
			
					arrow.x = arrowCoordinates.x;
					arrow.y = arrowCoordinates.y;
					parent1.addChild(arrow);
				}
		
		private function onMouseDown(e:MouseEvent){
			switch(doNow){
				case SELECT_SEGMENT:
					doSelectSegment(e);
					break;
				case SELECT_POSITION:
					doSelectPosition();
					break;
				case SELECT_ANGLE:
					doSelectAngle();
			}
		}
		
				private function doSelectSegment(e:MouseEvent){
					var angle:Number;
					var p:Point;
					var positionOfArrow:Point;
					if( this.highlightedSegment != null){
						doNow = SELECT_POSITION;
						highlightedSegment.setColor(0x0);
						positionOfArrow = snap.doSnapToSegment( new Point(e.stageX, e.stageY), highlightedSegment);
						positionOfArrow = snap.doSnapToForce( positionOfArrow, highlightedSegment);
						arrow = new ArcArrow(positionOfArrow, new Point(e.stageX, e.stageY), true, 0);
						parent1.addChild(arrow);
						arrow.x = positionOfArrow.x;
						arrow.y = positionOfArrow.y;
						arrowCoordinates = positionOfArrow;
					}
				}

				private function doSelectPosition(){
					panel = new MomentPanel();
					panel.x = 800-135;
					doNow = SELECT_ANGLE;
					
					parent1.addChild(panel);
				}
		
				private function doSelectAngle(){
					// убираем всех прослушивателей событий
					parent1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					parent1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					this.isClockWise = panel.isMomentClockWise;
					panel.destroy();
					parent1.removeChild(panel);

					arrowAngle = arrow.angleOfTip;
					
					dialogWnd = new EditWindowMoment("","");
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
							parent1.removeChild(arrow);
			
							momentName = dialogWnd.force;
							momentValue = dialogWnd.value;
							dimension = dialogWnd.dimension;
							dialogWnd = null;
							doCreateMoment();
							dispatchEvent(new Event(ConcentratedForceCreator.CREATE_DONE));
						}
		
								private function doCreateMoment(){
									var p:Point;
									var angle:Number;
									moment = new Moment(parent1, button_up, button_over, button_down, button_hit,
																  momentName);
									moment.dimension = dimension;
									moment.segment = highlightedSegment;
									moment.momentValue = momentValue;
									moment.momentNumber = momentNumber;
									moment.isClockWise = this.isClockWise;
									p = Point.polar(40, arrowAngle);
									p.y = -p.y;  // преобразуем из дкартовой системы координат в оконную
									moment.setCoordOfMomentName(p);
									moment.x = arrowCoordinates.x;
									moment.y = arrowCoordinates.y;
								}
		
						private function onCancelEditInDialogWindow(e:Event){
							dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
							dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

							parent1.removeChild(dialogWnd);
							parent1.removeChild(arrow);
							
							dialogWnd = null;
							dispatchEvent(new Event(ConcentratedForceCreator.CREATE_CANCEL));
						}
		
		public function get result():Moment {
			return moment;
		}
		
	}
}
