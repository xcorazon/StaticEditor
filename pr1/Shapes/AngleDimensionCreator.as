package  pr1.Shapes {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	import pr1.Shapes.LinearDimension;
	import pr1.CoordinateTransformation;
	import pr1.ComConst;
	import pr1.windows.EditWindowAngle;
	import pr1.windows.EditWindow;
	import pr1.razmers.AngleDimensionContainer;
	import pr1.Snap;
	import pr1.panels.AnglePanel;
	
	public class AngleDimensionCreator extends Sprite {
		// события в объекте
		public static const CREATE_CANCEL:String = "Cancel creation of angle";
		public static const CREATE_DONE:String = "Done creation of angle";
		// константы для внутреннего использования
		private static const SELECT_FIRST_SEGMENT:int = 0;
		private static const SELECT_SECOND_SEGMENT:int = 1;
		private static const SELECT_RADIUS:int = 2;
		
		private var parent1:*;
		private var segments:Array;
		private var firstHighlightedSegment:Segment;
		private var secondHighlightedSegment:Segment;
		private var snap:Snap;
		private var angleDimensionF:AngleDimension;
		private var panel:AnglePanel;
		
		// выходные данные
		private var razmerScreenPosition:Point;
		private var firstSegmentAngle:Number;
		private var pointOfSecondSegment:Point;
		private var razmerRadius:Number;
		private var firstPointNumber:int;
		private var secondPointNumber:int;
		private var thirdPointNumber:int;
		private var firstPointScreenCoord:Point;
		private var secondPointScreenCoord:Point;
		private var thirdPointScreenCoord:Point;
		private var radius:Number;
		
		private var isInnerAngle:Boolean;
		private var razmerName:String;
		private var razmerValue:String;
		
		private var button_up:AngleDimension;
		private var button_over:AngleDimension;
		private var button_down:AngleDimension;
		private var button_hit:AngleDimension;
		//cам элемент нагрузки в полном виде
		private var razmer:AngleDimensionContainer = null;
		
		private var dialogWnd:EditWindowAngle;
		
		private var doNow:int;
		
		public function AngleDimensionCreator(parent:*, segments:Array) {
			// constructor code
			this.parent1 = parent;
			this.segments = segments;
			this.doNow = SELECT_FIRST_SEGMENT;
			this.firstHighlightedSegment = null;
			this.secondHighlightedSegment = null;
			
			this.snap = parent1.snap;
			parent1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			parent1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseMove(e:MouseEvent){
			switch(doNow){
				case SELECT_FIRST_SEGMENT:
					doHighlightFirstSegment(e);
					break;
				case SELECT_SECOND_SEGMENT:
					doHighlightSecondSegment(e);
					break;
				case SELECT_RADIUS:
					doMoveRadius(e);
			}
		}
		
		private function doHighlightFirstSegment(e){
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
			
			if( isAnySegmentNear(tempSegment)){
				if(firstHighlightedSegment != null){
					if(tempSegment == null){
						firstHighlightedSegment.setColor(0x0);
						firstHighlightedSegment = null;
						return;
					} else {
						firstHighlightedSegment.setColor(0x0);
						firstHighlightedSegment = tempSegment;
						firstHighlightedSegment.setColor(0xff);
						return;
					}
				} else {
					if(tempSegment != null){
						firstHighlightedSegment = tempSegment;
						firstHighlightedSegment.setColor(0xff);
						return;
					}
				}
			}
		}
		
		private function doHighlightSecondSegment(e){
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
			
			if(tempSegment == firstHighlightedSegment) return;
			if(tempSegment != null){
				if(firstHighlightedSegment.specialDirection != -1 && tempSegment.specialDirection != -1){
					return;
				}
			}
			
			if(secondHighlightedSegment != null){
				if(tempSegment == null){
					secondHighlightedSegment.setColor(0x0);
					secondHighlightedSegment = null;
					return;
				} else {
					secondHighlightedSegment.setColor(0x0);
					secondHighlightedSegment = tempSegment;
					secondHighlightedSegment.setColor(0xff);
					return;
				}
			} else {
				if(tempSegment != null){
					secondHighlightedSegment = tempSegment;
					secondHighlightedSegment.setColor(0xff);
					return;
				}
			}
		}
		
		private function doMoveRadius(e:MouseEvent){
			var p:Point;
			var cursorPosition:Point = new Point(e.stageX, e.stageY);
			var angle:Number = firstSegmentAngle;
			this.isInnerAngle = panel.isInnerAngle;
			if(!panel.isInnerAngle){
				angle += Math.PI;
				if(angle >= Math.PI*2) angle = angle - 2 * Math.PI;
			}
			this.parent1.removeChild(angleDimensionF);
			
			angleDimensionF = new AngleDimension(razmerScreenPosition, angle, this.pointOfSecondSegment, cursorPosition, 0);
			button_over = new AngleDimension(razmerScreenPosition, angle, this.pointOfSecondSegment, cursorPosition, 0xff);
			button_up = new AngleDimension(razmerScreenPosition, angle, this.pointOfSecondSegment, cursorPosition, 0);
			button_down = button_up;
			button_hit = button_up;
			
			this.radius = angleDimensionF.radius;
			
			angleDimensionF.x = razmerScreenPosition.x;
			angleDimensionF.y = razmerScreenPosition.y;
			this.parent1.addChild(angleDimensionF);
		}
		
		private function onMouseDown(e:MouseEvent){
			switch(doNow){
				case SELECT_FIRST_SEGMENT:
					doSelectFirstSegment(e);
					break;
				case SELECT_SECOND_SEGMENT:
					doSelectSecondSegment(e);
					break;
				case SELECT_RADIUS:
					doSelectRadius(e);
			}
		}
		
		private function doSelectFirstSegment(e:MouseEvent){
					
			if( this.firstHighlightedSegment != null){
				doNow = SELECT_SECOND_SEGMENT;
			}
		}
				
		private function doSelectSecondSegment(e:MouseEvent){
			var vector:Point;
			var cursorPosition:Point = new Point(e.stageX, e.stageY);
			if( this.secondHighlightedSegment != null){
				if(firstHighlightedSegment.firstScreenCoord.equals(secondHighlightedSegment.firstScreenCoord)
				   || firstHighlightedSegment.firstScreenCoord.equals(secondHighlightedSegment.secondScreenCoord)){
					razmerScreenPosition = firstHighlightedSegment.firstScreenCoord;
					//угол отрезка относительно выбранной точки
					vector = firstHighlightedSegment.secondDecartCoord.subtract(firstHighlightedSegment.firstDecartCoord);
					this.firstSegmentAngle = CoordinateTransformation.decartToPolar(vector).y;
					// запоминаем точки данного отрезка
					this.firstPointNumber = firstHighlightedSegment.secondPointNumber;
					this.firstPointScreenCoord = firstHighlightedSegment.secondScreenCoord;
					this.secondPointNumber = firstHighlightedSegment.firstPointNumber;
					this.secondPointScreenCoord = firstHighlightedSegment.firstScreenCoord;
					// вторая опорная точка для построения угла
					if(secondHighlightedSegment.firstScreenCoord.equals(firstHighlightedSegment.firstScreenCoord)){
						this.pointOfSecondSegment = secondHighlightedSegment.secondScreenCoord;
						this.thirdPointNumber = secondHighlightedSegment.secondPointNumber;
						this.thirdPointScreenCoord = secondHighlightedSegment.secondScreenCoord;
					} else {
						this.pointOfSecondSegment = secondHighlightedSegment.firstScreenCoord;
						this.thirdPointNumber = secondHighlightedSegment.firstPointNumber;
						this.thirdPointScreenCoord = secondHighlightedSegment.firstScreenCoord;
					}
				} else {
					razmerScreenPosition = firstHighlightedSegment.secondScreenCoord
					//угол отрезка относительно выбранной точки
					vector = firstHighlightedSegment.firstDecartCoord.subtract(firstHighlightedSegment.secondDecartCoord);
					this.firstSegmentAngle = CoordinateTransformation.decartToPolar(vector).y;
					// запоминаем точки данного отрезка
					this.firstPointNumber = firstHighlightedSegment.firstPointNumber;
					this.firstPointScreenCoord = firstHighlightedSegment.firstScreenCoord;
					this.secondPointNumber = firstHighlightedSegment.secondPointNumber;
					this.secondPointScreenCoord = firstHighlightedSegment.secondScreenCoord;
					// вторая опорная точка для построения угла
					if(secondHighlightedSegment.firstScreenCoord.equals(firstHighlightedSegment.secondScreenCoord)){
						this.pointOfSecondSegment = secondHighlightedSegment.secondScreenCoord;
						this.thirdPointNumber = secondHighlightedSegment.secondPointNumber;
						this.thirdPointScreenCoord = secondHighlightedSegment.secondScreenCoord;
					} else {
						this.pointOfSecondSegment = secondHighlightedSegment.firstScreenCoord;
						this.thirdPointNumber = secondHighlightedSegment.firstPointNumber;
						this.thirdPointScreenCoord = secondHighlightedSegment.firstScreenCoord;
					}
				}
				firstHighlightedSegment.setColor(0x0);
				secondHighlightedSegment.setColor(0x0);
				
				angleDimensionF = new AngleDimension(razmerScreenPosition, firstSegmentAngle, this.pointOfSecondSegment, cursorPosition, 0);
				this.parent1.addChild(angleDimensionF);
				angleDimensionF.x = razmerScreenPosition.x;
				angleDimensionF.y = razmerScreenPosition.y;
				
				panel = new AnglePanel();
				panel.x = 800-135;
				parent1.addChild(panel);
				doNow = SELECT_RADIUS;
			}
		}
		
		private function doSelectRadius(e:MouseEvent){
			// убираем всех прослушивателей событий
			parent1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			parent1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			parent1.removeChild(panel);
			panel.destroy();
			panel = null;

			dialogWnd = new EditWindowAngle("","");
			parent1.addChild(dialogWnd);
			dialogWnd.x = 400;
			dialogWnd.y = 300;
			dialogWnd.addEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
			dialogWnd.addEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);
			/*trace("Номер первой точки: ", this.firstPointNumber);
			trace("Номер второй точки: ", this.secondPointNumber);
			trace("Номер третьей точки: ", this.thirdPointNumber);
			
			trace("Координата первой точки: ", this.firstPointScreenCoord.toString());
			trace("Координата второй точки: ", this.secondPointScreenCoord.toString());
			trace("Координата третьей точки: ", this.thirdPointScreenCoord.toString());
			*/
		}
		
		private function onEndEditInDialogWindow(e:Event){
			dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
			dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

			parent1.removeChild(dialogWnd);
			parent1.removeChild(angleDimensionF);
			
			razmerName = dialogWnd.razmer;
			razmerValue = dialogWnd.value;
			dialogWnd = null;
			doCreateAngleDimension();
			dispatchEvent(new Event(AngleDimensionCreator.CREATE_DONE));
		}
		
		private function doCreateAngleDimension(){
			var p:Point;
			var angle:Number;
			razmer = new AngleDimensionContainer(parent1, button_up, button_over, button_down, button_hit,
										  razmerName);
			razmer.razmerValue = razmerValue;
			razmer.razmerName = razmerName;
			razmer.firstPointNumber = this.firstPointNumber;
			razmer.secondPointNumber = this.secondPointNumber;
			razmer.thirdPointNumber = this.thirdPointNumber;
			razmer.firstPointScreenCoord = this.firstPointScreenCoord;
			razmer.secondPointScreenCoord = this.secondPointScreenCoord;
			razmer.thirdPointScreenCoord = this.thirdPointScreenCoord;
			razmer.radius = this.radius;
			razmer.isInnerAngle = this.isInnerAngle;
			
			razmer.x = razmerScreenPosition.x;
			razmer.y = razmerScreenPosition.y;

			razmer.setCoordOfRazmerName();
		}
		
		private function onCancelEditInDialogWindow(e:Event){
			dialogWnd.removeEventListener(EditWindow.END_EDIT, onEndEditInDialogWindow);
			dialogWnd.removeEventListener(EditWindow.CANCEL_EDIT, onCancelEditInDialogWindow);

			parent1.removeChild(dialogWnd);
			parent1.removeChild(angleDimensionF);
							
			dialogWnd = null;
			dispatchEvent(new Event(LinearDimensionCreator.CREATE_CANCEL));
		}
		
		private function isAnySegmentNear(seg:Segment):Boolean {
			var nearSegments:Array = new Array();
			if(seg == null) return true;
			
			for each (var s:Segment in segments){
				if((s.firstPointNumber == seg.firstPointNumber || s.firstPointNumber == seg.secondPointNumber ||
				   s.secondPointNumber == seg.firstPointNumber || s.secondPointNumber == seg.secondPointNumber) && s != seg){
					   nearSegments.push(s);
				   }
			}
			if(seg.specialDirection == Segment.HORISONTAL || seg.specialDirection == Segment.VERTICAL){
				for each (s in nearSegments){
					if( s.specialDirection == -1){
						return true;
					}
				}
			} else if(nearSegments.length != 0) return true;
			
			return false;
		}
		
		public function get result():AngleDimensionContainer{
			return razmer;
		}

	}
	
}
