package pr1.razmers
{
  import flash.display.*;

  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.events.Event;
  import pr1.razmers.RazmerShape;
  import pr1.Balka;
  import pr1.Sheme;
  import pr1.EditEvent1;
  import pr1.windows.EditWindow4;
  import pr1.geometriya.FlatGeom;

  public class Razmer extends SimpleButton
  {
    private static const DELTA:int = 10;  // необходимая разница в пикселях для выравнивания
    private static const RADIUS:Number = 8;
    public  static const CREATE_COMPLETE:String = "createComplete";
    public  static const CREATE_CANCEL:String = "create cancel";
    private var balka:Balka;
    private var sheme:Sheme;

    private var razmerName:String = "";
    private var razmerValue:String = "";

    private var firstPoint:int; // номер первой точки размера
    private var secondPoint:int;  // номер второй точки размера

    private var firstMoveMark:Shape;    // маркер приближения курсора к точке
                // при начальном движении мыши по экрану
    private var secondMoveMark:Shape;   // маркер приближения курсора к точке
                // при втором движении мыши по экрану

    private var firstPointCoord:Point;  // координаты первой точки размера
    private var secondPointCoord:Point; // координаты второй точки размера
    private var h:int;      // высота размерной линии

    var shape:Sprite;     // отображаемый размер
    private var isChanged:int = 0;    // для функции mouseMove, если в первый раз

    private var isActive:Boolean; // позволяет или не позволяет редактировать нагрузку
    private var tempShape:Sprite; // переменная для временного хранения различных форм отрисовки силы

    public var wnd:EditWindow4;   // окно для редактирования нагрузки

    public function Razmer(b:Balka, s:Sheme):void
    {
      isChanged = 0;
      balka = b;
      sheme = s;
      balka.stage.addEventListener(MouseEvent.CLICK, firstClick);
      balka.stage.addEventListener(MouseEvent.MOUSE_MOVE, firstMove);
      firstMoveMark = new Shape();
      balka.addChild(firstMoveMark);
      sheme.addEventListener(Sheme.CHANGE_BUTTON, cancelCreation);
    }

    private function firstMove(e:MouseEvent)
    {
      var p1:Point = new Point(e.stageX, e.stageY);
      var p:Point = balkaClose(p1.x, p1.y);
      if(p != null)
      {
        firstMoveMark.graphics.clear();
        firstMoveMark.graphics.lineStyle(2, 0x0000ff);
        firstMoveMark.graphics.drawCircle(p.x, p.y, 2);
      }
      else
      {
        firstMoveMark.graphics.clear();
      }

    }

    private function firstClick(e:MouseEvent)
    {
      var forces:Array = balka.forces;
      var p:Point;
      var x = e.stageX;
      var y = e.stageY
      var l,dx,dy:Number;
      p = balkaClose(x, y);

      if(p == null) return;


      //firstPoint = i;
      firstPointCoord = p;
      balka.stage.removeEventListener(MouseEvent.CLICK, firstClick);
      balka.stage.removeEventListener(MouseEvent.MOUSE_MOVE, firstMove);

      balka.removeChild(firstMoveMark);
      firstMoveMark = null;

      balka.stage.addEventListener(MouseEvent.CLICK, secondClick);
      balka.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);

      secondMoveMark = new Shape();
      balka.addChild(secondMoveMark);
  }

    private function mouseMove(e:MouseEvent)
    {
      var p:Point = new Point(e.stageX, e.stageY);

      var p1:Point = balkaClose(p.x, p.y);

      if(p1 != null)
      {
        secondMoveMark.graphics.clear();
        secondMoveMark.graphics.lineStyle(2, 0x0000ff);
        secondMoveMark.graphics.drawCircle(p1.x, p1.y, 2);
      }
      else
      {
        secondMoveMark.graphics.clear();
      }

      if(isChanged)
      {
        balka.removeChild(shape);
        shape = new RazmerShape("", firstPointCoord, p, 40, 0x0);
        balka.addChild(shape);
      }
      else
      {
        shape = new RazmerShape("", firstPointCoord, p, 40, 0x0);
        balka.addChild(shape);
        isChanged++;
      }
    }

    private function secondClick(e:MouseEvent)
    {
      var forces:Array = balka.forces;
      var p:Point;
      var x = e.stageX;
      var y = e.stageY;
      var l,dx,dy:Number;

      p = balkaClose(x,y);

      if(p == null || p == firstPointCoord) return;


      //secondPoint = i;
      secondPointCoord = p;
      balka.stage.removeEventListener(MouseEvent.CLICK, secondClick);
      balka.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
      balka.stage.addEventListener(MouseEvent.CLICK, thirdClick);
      balka.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove2);

      balka.removeChild(secondMoveMark);
      secondMoveMark = null;

      isChanged++;
    }

    private function thirdClick(e:MouseEvent)
    {
      balka.stage.removeEventListener(MouseEvent.CLICK, thirdClick);
      balka.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove2);

      downState      = new RazmerShape("",firstPointCoord, secondPointCoord, h, 0xff0000);
      overState      = new RazmerShape("",firstPointCoord, secondPointCoord, h, 0x0000ff);
      upState        = new RazmerShape("",firstPointCoord, secondPointCoord, h, 0x0);
      hitTestState   = new RazmerShape("",firstPointCoord, secondPointCoord, h, 0x0,true);

      // создаем окно для ввода данных
      wnd = new EditWindow4(razmerValue, razmerName);
      wnd.addEventListener(EditEvent1.END_EDIT, receiveDataFromWindow);

      sheme.addChild(wnd);
      wnd.x = 400;
      wnd.y = 200;
      // передаем сообщение о создании окна вверх по списку отображения
      var edit:EditEvent1 = new EditEvent1(EditEvent1.BEGIN_EDIT, true, true, wnd);
      dispatchEvent(edit);
    }

    public function receiveDataFromWindow(e:EditEvent1)
    {
      // получаем данные из окна
      var wnd = e.wnd;
      razmerValue = wnd.value;
      razmerName = wnd.razmer;
      trace("razmerName", razmerName);

        wnd.removeEventListener(EditEvent1.END_EDIT, receiveDataFromWindow);
        balka.removeChild(shape);
        sheme.removeChild(wnd);
        sheme.removeEventListener(Sheme.CHANGE_BUTTON, cancelCreation);
        addEventListener(MouseEvent.CLICK, mouseClick);
      // убираем слушатель события завершения редактирования данных в окне
      if(razmerValue.length != 0)
      {
        downState      = new RazmerShape(razmerName,firstPointCoord, secondPointCoord, h, 0xff0000);
        overState      = new RazmerShape(razmerName,firstPointCoord, secondPointCoord, h, 0x0000ff);
        upState        = new RazmerShape(razmerName,firstPointCoord, secondPointCoord, h, 0x0);
        hitTestState   = new RazmerShape(razmerName,firstPointCoord, secondPointCoord, h, 0x0, true);
        tempShape    = new RazmerShape(razmerName,firstPointCoord, secondPointCoord, h, 0x0, true);

        dispatchEvent(new Event(Razmer.CREATE_COMPLETE));
      }
      else
      {
        dispatchEvent(new Event(Razmer.CREATE_CANCEL));
      }
    }

    private function mouseMove2(e:MouseEvent)
    {
      var p:Point = new Point(e.stageX, e.stageY);
      h = int(p.y - firstPointCoord.y);

      balka.removeChild(shape);
      shape = new RazmerShape("", firstPointCoord, secondPointCoord, h, 0x0);
      balka.addChild(shape);

    }
    // в случае отмены редактирования (на панели была нажата другая кнопка)
    // удаляем обработчики событий и сам объект
    private function cancelCreation(e:Event)
    {
      sheme.removeEventListener(Sheme.CHANGE_BUTTON, cancelCreation);
      if(firstMoveMark != null)
      {
        balka.stage.removeEventListener(MouseEvent.MOUSE_MOVE, firstMove);
        balka.removeChild(firstMoveMark);
        firstMoveMark = null;
      }
      if(isChanged == 0)
      {
        balka.stage.removeEventListener(MouseEvent.CLICK, firstClick);
      }
      else if(isChanged == 1)
      {
        balka.stage.removeEventListener(MouseEvent.CLICK, secondClick);
        balka.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
        balka.removeChild(shape);
        balka.removeChild(secondMoveMark);
        secondMoveMark = null;
      }
      else if (isChanged == 2)
      {
        balka.stage.removeEventListener(MouseEvent.CLICK, thirdClick);
        balka.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove2);
        balka.removeChild(shape);
      }
      dispatchEvent(new Event(Razmer.CREATE_CANCEL));
    }

    // проверка имеется ли такой размер в массиве размеров
    private function isRazmerInArray(i1:int, i2:int):Boolean
    {
      var razm:Array = balka.razmer;
      var a1,a2:int;

      for(var i in razm)
      {
        trace(i);
        a1 = razm[i].first;
        trace("a1= ",a1,' i1= ',i1);
        a2 = razm[i].second;
        trace("a2= ",a2,' i2= ',i2);
        if( (a1==i1 && a2==i2)||(a2==i1 && a1==i2))
          return true;
      }
      return false;
    }
    // функция редактирования объекта когда он активен
    private function mouseClick(e:MouseEvent)
    {
      // создаем окно для ввода данных
      wnd = new EditWindow4(razmerValue, razmerName);
      wnd.addEventListener(EditEvent1.END_EDIT, changeRazmer);
      sheme.addChild(wnd);
      wnd.x = 400;
      wnd.y = 200;
      // передаем сообщение о создании окна вверх по списку отображения
      var edit:EditEvent1 = new EditEvent1(EditEvent1.BEGIN_EDIT, true, true, wnd);
      dispatchEvent(edit);
      wnd.addEventListener(EditWindow4.DELETE_OBJECT, deleteEventListener);
    }

    private function changeRazmer(e:EditEvent1)
    {
      var wnd = e.wnd;
      razmerValue = wnd.value;
      razmerName = wnd.razmer;
      trace("razmerName", razmerName);
      // убираем слушатель события завершения редактирования данных в окне
      wnd.removeEventListener(EditEvent1.END_EDIT, changeRazmer);
      wnd.removeEventListener(EditWindow4.DELETE_OBJECT, deleteEventListener);
      sheme.removeChild(wnd);
      downState      = new RazmerShape(razmerName,firstPointCoord, secondPointCoord, h, 0xff0000);
      overState      = new RazmerShape(razmerName,firstPointCoord, secondPointCoord, h, 0x0000ff);
      upState        = new RazmerShape(razmerName,firstPointCoord, secondPointCoord, h, 0x0);
      hitTestState   = new RazmerShape(razmerName,firstPointCoord, secondPointCoord, h, 0x0, true);
      tempShape    = new RazmerShape(razmerName,firstPointCoord, secondPointCoord, h, 0x0, true);
      dispatchEvent(new Event(Razmer.CREATE_COMPLETE));
    }

    private function deleteEventListener(e:Event)
    {
      balka.removeRazmer(this);
      sheme.removeChild(wnd);
      wnd.removeEventListener(EditEvent1.END_EDIT, changeRazmer);
      wnd.removeEventListener(EditWindow4.DELETE_OBJECT, deleteEventListener);
      removeEventListener(MouseEvent.CLICK, mouseClick);
      sheme.dispatchEvent(new Event(Sheme.CHANGE_BUTTON));
    }

    // возвращает номер первой точки соединенной с размером
    public function get first():int
    {
      return firstPoint;
    }

    // возвращает номер второй точки соединенной с размером
    public function get second():int
    {
      return secondPoint;
    }

    // возвращает координаты первой точки размера
    public function get firstCoord():Point{
      return firstPointCoord;
    }

    // возвращает координаты второй точки размера
    public function get secondCoord():Point
    {
      return secondPointCoord;
    }

    public function activate():void {
      isActive = true;
      hitTestState = tempShape;
    }

    public function deactivate():void
    {
      isActive = false;
      //tempShape = upState;
      hitTestState   = null;
    }

    // возвращает имя размера
    public function getName():String
    {
      return razmerName;
    }

    // возвращает значение размера
    public function getValue():String
    {
      return razmerValue;
    }

    // проверка наличия рядом балки или составляющих ее элементов
    private function balkaClose(x:Number, y:Number):Point
    {
      // проверяем находится ли точка на отрезке

      var p:Point = new Point(x,y);
      var p1:Point = new Point(x,y);

      var b:Boolean = false;


      // проверяем силы
      var forces:Array = balka.forces;
      for( var i in forces)
      {
        if(FlatGeom.dPoint(p, forces[i].getCoord()) < DELTA)
        {
          b = true;
          p1 = forces[i].getCoord();
          return p1;
        }
      }
      // проверяем моменты
      forces = balka.moments;
      for( i in forces)
      {
        if(FlatGeom.dPoint(p, forces[i].getCoord()) < DELTA)
        {
          b = true;
          p1 = forces[i].getCoord()
          return p1;
        }
      }

      // проверяем распределенные нагрузки
      forces = balka.ql;
      for( i in forces)
      {
        if(FlatGeom.dPoint(p, forces[i].getCoord1()) < DELTA)
        {
          b = true;
          p1 = forces[i].getCoord1()
          return p1;
        }
        if(FlatGeom.dPoint(p, forces[i].getCoord2()) < DELTA)
        {
          b = true;
          p1 = forces[i].getCoord2()
          return p1;
        }
      }
      // проверяем опоры
      forces = balka.opora;
      for( i in forces)
      {
        if(FlatGeom.dPoint(p, forces[i].getCoord()) < DELTA)
        {
          b = true;
          p1 = forces[i].getCoord()
          return p1;
        }
      }
      return null;//p1;
    }
  }
}