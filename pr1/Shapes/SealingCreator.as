package  pr1.Shapes
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.CoordinateTransformation;
  import pr1.ComConst;
  import pr1.windows.EditWindowSealing;
  import pr1.Snap;
  import pr1.opora.SealingContainer;
  import pr1.Frame;
  import pr1.events.DialogEvent;

  public class SealingCreator extends Creator
  {
    private var selectedSegment:Segment;
    private var snapPoints:Array;
    private var secondSnapPoint:Point = null;

    // выходные данные
    private var angleOfSealing:Number;
    private var sealingPosition:Point;
    private var horisontalReaction:String;
    private var verticalReaction:String;
    private var moment:String;

    //cам элемент защемления в полном виде
    private var sealingContainer:SealingContainer = null;

    public function SealingCreator()
    {
      super();
    }
    
    override public function create()
    {
      super.create();
      snapPoints = new Array();
      getSnapPoints();

      elementImage = new Sealing();
      parent1.addChild(elementImage);

      initHandlers();
      initEvents();
    }

    private function initHandlers()
    {
      moveHandlers[0] = moveSealing;
      downHandlers[0] = fixPosition;
    }

    private function getSnapPoints()
    {
      var seg1:Segment;
      var seg2:Segment;
      var p1:Point;
      var p2:Point = null;

      if(segments.length == 1)
      {
        snapPoints.push(segments[0].firstScreenCoord);
        snapPoints.push(segments[0].secondScreenCoord);
        return;
      }
      // ищем несовпадающие точки
      // именно к ним и будет производиться привязка

      for each (seg1 in segments)
      {
        p1 = seg1.firstScreenCoord;
        var copyPresent:Boolean = false;
        for each (seg2 in segments)
        {
          if(seg1 != seg2)
          {
            if(p1.equals(seg2.firstScreenCoord))
            {
              copyPresent = true;
              break;
            }
            if(p1.equals(seg2.secondScreenCoord))
            {
              copyPresent = true;
              break;
            }
          }
        }
        if(!copyPresent) snapPoints.push(p1);

        p2 = seg1.secondScreenCoord;
        copyPresent = false;
        for each (seg2 in segments)
        {
          if(seg1 != seg2){
            if(p2.equals(seg2.firstScreenCoord))
            {
              copyPresent = true;
              break;
            }
            if(p2.equals(seg2.secondScreenCoord))
            {
              copyPresent = true;
              break;
            }
          }
        }
        if(!copyPresent) snapPoints.push(p2);
      }
    }


    private function moveSealing(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var thres:Number = 8;
      var angle:Number;
      for each (var p1:Point in snapPoints){
        if(Point.distance(cursorPosition, p1) <= thres)
        {
          angle = getAngle(p1);
          elementImage.rotation = angle;
          angleOfSealing = angle;
          elementImage.x = p1.x;
          elementImage.y = p1.y;
          break;
        }
        else
        {
          elementImage.rotation = 0;
          angleOfSealing = 0;
          elementImage.x = cursorPosition.x;
          elementImage.y = cursorPosition.y;
        }
      }
    }


    private function fixPosition(e:MouseEvent)
    {
      var cursorPosition:Point = new Point(e.stageX, e.stageY);
      var thres:Number = 8;
      var angle:Number;
      for each (var p1:Point in snapPoints)
      {
        if(Point.distance(cursorPosition, p1) <= thres)
        {
          angle = getAngle(p1);
          elementImage.rotation = angle;
          angleOfSealing = angle;
          elementImage.x = p1.x;
          elementImage.y = p1.y;
          sealingPosition = p1;
          this.selectedSegment = getSegment(p1);

          releaseEvents();
          initDialog();
          break;
        }
        else
        {
          elementImage.rotation = 0;
          angleOfSealing = 0;
          elementImage.x = cursorPosition.x;
          elementImage.y = cursorPosition.y;
        }
      }
    }

    private function initDialog()
    {
      dialogWnd = new EditWindowSealing("","","");
      parent1.addChild(dialogWnd);
      dialogWnd.x = 400;
      dialogWnd.y = 300;
      dialogWnd.addEventListener(DialogEvent.END_DIALOG, onEndDialog);
    }


    override protected function createObject(data:Object)
    {
      var p:Point;
      var angle:Number;
      sealingContainer = new SealingContainer(Frame.Instance, this.angleOfSealing);
      sealingContainer.x = this.sealingPosition.x;
      sealingContainer.y = this.sealingPosition.y;

      sealingContainer.horisontalReaction = data.hReaction;
      sealingContainer.verticalReaction = data.vReaction;
      sealingContainer.moment = data.moment;

      sealingContainer.segment = selectedSegment;
      sealingContainer.pointNumber = getPointNumber(sealingPosition);
      sealingContainer.setCoordOfSignatures();
      
      super.createObject(data);
    }

    private function getAngle(pointOnSegment:Point):Number
    {
      var seg:Segment;
      var p:Point;
      var angle:Number;
      for each (seg in segments)
      {
        if(pointOnSegment.equals(seg.firstScreenCoord))
        {
          p = seg.secondDecartCoord.subtract(seg.firstDecartCoord);
          break;
        }
        if(pointOnSegment.equals(seg.secondScreenCoord))
        {
          p = seg.firstDecartCoord.subtract(seg.secondDecartCoord);
          break;
        }
      }
      angle = CoordinateTransformation.decartToPolar(p).y;
      angle = angle * 180/Math.PI;
      return -angle;
    }

    private function getSegment(pointOnSegment:Point):Segment
    {
      var seg:Segment;
      for each (seg in segments)
      {
        if(pointOnSegment.equals(seg.firstScreenCoord))
        {
          return seg;
        }
        if(pointOnSegment.equals(seg.secondScreenCoord))
        {
          return seg;
        }
      }
      return null;
    }

    private function getPointNumber(pointOnSegment:Point):int
    {
      var seg:Segment;
      var pointNumber:int = 0;
      for each (seg in segments)
      {
        if(pointOnSegment.equals(seg.firstScreenCoord))
        {
           pointNumber = seg.firstPointNumber;
           break;
        }
        if(pointOnSegment.equals(seg.secondScreenCoord))
        {
           pointNumber = seg.secondPointNumber;
           break;
        }
      }
      return pointNumber;
    }

    override public function get result():*
    {
      return sealingContainer;
    }
  }
}