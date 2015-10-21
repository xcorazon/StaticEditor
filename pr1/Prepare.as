package pr1 {
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.utils.ByteArray;
	import pr1.forces.*;
	// опора с одной реакцией
	public class Prepare {
		
		private var balka:Balka;
		
		private var pointsArray:Array;	/* массив точек приложения нагрузок 
		   в этом массиве хранятся координаты каждой точки на балке
		   из него будет формироваться массив в выходной файл
		*/
		private var filePointVozd:ByteArray;
		
		
		// конструктор класса 
		public function Prepare(balka:Balka) {
			
			this.balka = balka;
		}
		
		// функция проверяет связаны ли размеры со всеми нагрузками и опорами
		public function checkRazmers(withMoments:Boolean = false):Boolean {
			// withMoments - проверка размеров с моментами если true и без если false
			var retVal:Boolean = true;
			for each (var op:* in balka.opora){
				// проверяем сконцентрированные нагрузки
				for each ( var p in balka.forces){
					if( !fromPointToPoint( op.getCoord(), p.getCoord(), new Array() )) return false;
				}
				// проверяем распределенные нагрузки
				for each ( var q in balka.ql){
					if( !fromPointToPoint( op.getCoord(), q.getCoord1(), new Array() )) return false;
					if( !fromPointToPoint( op.getCoord(), q.getCoord2(), new Array() )) return false;
				}
				// проверяем моменты
				if(withMoments){
					for each ( var m in balka.moments){
						if( !fromPointToPoint( op.getCoord(), m.getCoord(), new Array() )) return false;
					}
				}
			}
			return true;
		}
		
		// проверка размерной цепи от одной точки до другой
		private function fromPointToPoint(point1:Point, point2:Point, a:Array):Boolean {
			
			var razmers:Array = balka.razmer;
			
			// проверяем имеется ли хоть одна точка в массиве а[]
			// если имеется то поиск начал ходить по кругу и на выход подаем
			// сообщение false (размер не найден)
			for each (var p:Point in a){
				if(p.x == point1.x) return false;
				if(p.x == point2.x) return false;
			}
			
			// ищем размер с совпадением обоих точек
			for each( var r:* in razmers){
				if(point1.x == r.firstCoord.x && point2.x == r.secondCoord.x) return true;
				if(point2.x == r.firstCoord.x && point1.x == r.secondCoord.x) return true;
			}
			
			
			// добавляем точку p1 в массив а[]
			// ищем точку p2 по цепочке размеров
			var naideno:Boolean = false;
			a.push(point1);
			for each (r in razmers){
				if(r.firstCoord.x == point1.x){
					if(fromPointToPoint(r.secondCoord, point2, a)){
						a.pop();
						return true;
					}
				}
				if(r.secondCoord.x == point1.x){
					if(fromPointToPoint(r.firstCoord, point2, a)){
						a.pop();
						return true;
					}
				}
			}
			a.pop()
			// добавляем точку p2 в массив а[]
			// ищем точку p1 по цепочке размеров
			a.push(point2)
			for each (r in razmers){
				if(r.firstCoord.x == point2.x){
					if(fromPointToPoint(r.secondCoord, point1, a)){
						a.pop();
						return true;
					}
				}
				if(r.secondCoord.x == point2.x){
					if(fromPointToPoint(r.firstCoord, point1, a)){
						a.pop();
						return true;
					}
				}
			}
			a.pop();
			// возвращаем результат ничего не найдено
			return false;
		}
		
		// получить растровое изображение из векторного
		public function getBitmap():BitmapData {
			var width:uint =800 * 2.5;
			var height:uint = 400 * 2.5;
			var bmp1:BitmapData = new BitmapData(width, height, false, 0xffffffff);
			
			var m:Matrix = new Matrix();
			m.scale(2.5, 2.5);
			bmp1.draw(balka, m, null, null, null, true);
			var rect:Rectangle = new Rectangle(0,0,0,0);
			rect.left = bmp1.width -1;
			rect.top = bmp1.height-1;
			rect.right = 0;
			rect.bottom = 0;
			
			var c = false;
			var d:uint = 0;
			for(var y:uint = 0; y <= bmp1.height-1; y++){
				for(var x:uint = 0; x <= bmp1.width-1; x++){
					d = bmp1.getPixel32(x,y);
					if(bmp1.getPixel32(x,y) != 0xffffffff){
						rect.top = Math.min(y, rect.top);
						rect.left = Math.min(x, rect.left);
						c = true
						break;
					}
				}
				if(c) break;
			}
			
			for(y = rect.top; y <= bmp1.height-1; y++){
				for(x = 0; x <= bmp1.width-1; x++){
					if(bmp1.getPixel32(x,y) != 0xffffffff){
						rect.left = Math.min(x, rect.left);
						rect.right = Math.max(x,rect.right);
						rect.bottom = Math.max(y, rect.bottom);
					}
				}
			}
			rect.top -= 10;
			rect.left -= 10;
			rect.right += 10;
			rect.bottom += 10;
			//var rect:Rectangle = bmp1.getColorBoundsRect(0xffffffff, 0xffffffff, true);
			
			var bmp2:BitmapData = new BitmapData(rect.width, rect.height, false, 0xffff0000);
			bmp2.copyPixels(bmp1, rect, new Point(0,0));
			bmp1.dispose();
			return bmp2;
		}
		
		// функция проверяет достаточно ли опор содержит балка для решения
		// если да то на выходе значение true
		// если нет то false
		public function checkNumOpor():Boolean {
			return Boolean(balka.numReactions == 3);
		}
		
		
		// создаем ByteArray с выходными данными
		public function createOutputData():ByteArray {
			var outArr:ByteArray = new ByteArray();
			var t:Array = new Array(4);
			
			getPointsArray();
			
			outArr.length = 16;			// размер структуры main_struc
			outArr.writeUnsignedInt(521);
			outArr.position = 0;
			for(var z=3;z>=0;z--) t[z]=outArr.readByte();
			outArr.position = 0;
			for(z=0;z<=3;z++) outArr.writeByte(t[z]);
			
			var pos = outArr.position;
			var numForces:uint = 0;
			var forces:ByteArray = new ByteArray();
			
			// получаем массив всех сил (включая неизвестные)
			
			// добавляем реакции опор
			for each (var f in balka.opora){
				if( f is Opora3){
					forces.writeBytes(getUnkMStructure(f.getName(),f.getCoord()));
					forces.writeBytes(getUnkPStructure(f.getName()+"x", f.getCoord(), 0, 3));
					forces.writeBytes(getUnkPStructure(f.getName()+"y", f.getCoord(), 90, 4));
					numForces+=3;
				} else if( f is Opora2){
					forces.writeBytes(getUnkPStructure(f.getName()+"x", f.getCoord(), 0, 3));
					forces.writeBytes(getUnkPStructure(f.getName()+"y", f.getCoord(), 90, 4));
					numForces+=2;
				} else {
					forces.writeBytes(getUnkPStructure(f.getName(), f.getCoord(), 90, 4));
					numForces+=1;
				}
			}
			// добавляем сконцентрированные нагрузки
			for each ( f in balka.forces){
				forces.writeBytes(getPStructure(f));
				numForces++;
			}
			// добавляем распределенные нагрузки
			for each ( f in balka.ql){
				forces.writeBytes(getQStructure(f));
				numForces++;
			}
			// добавляем моменты
			for each ( f in balka.moments){
				forces.writeBytes(getMStructure(f));
				numForces++;
			}
			outArr.writeByte(numForces);
			outArr.position+=3;
			outArr.writeByte(16);
			outArr.position++;
			// записываем число точек
			outArr.writeByte(pointsArray.length);
			outArr.position+=3;
			outArr.writeShort(16 + forces.length);
			outArr.position-=2;
			t[0] = outArr.readByte();
			t[1] = outArr.readByte();
			outArr.position-=2;
			outArr.writeByte(t[1]);
			outArr.writeByte(t[0]);			
			outArr.writeBytes(forces);
			
			var pVozd:ByteArray = new ByteArray();
			
			for ( var i in pointsArray){
				pVozd.writeBytes(getPointVozd(i));
			}
			outArr.writeBytes(pVozd);
			
			return outArr;
		}
		// получить массив точек воздействия сил и опор 
		private function getPointsArray() {
			// число точек воздействия меньше или равно числу известных нагрузок
			// и опор вместе взятых
			
			// составляем массив точек
			var a:Array = new Array();
			for each( var f in balka.forces){
				a.push(f.getCoord());
			}
			for each( f in balka.moments){
				a.push(f.getCoord());
			}
			for each( f in balka.ql){
				a.push(f.getCoord1());
				a.push(f.getCoord2());
			}
			for each(f in balka.opora){
				a.push(f.getCoord());
			}
			
			// удаляем одинаковые точки
			var i1:int = 0;
			var i2:int;
			while( i1< a.length -1){
				i2 = i1 + 1;
				while(i2 < a.length){
					// если нашли совпадение
					if( a[i1].x == a[i2].x && a[i1].y == a[i2].y){
						a.splice(i2, 1);	// то удаляем совпавший элемент
					} else {
						i2++;		// иначе переходим к следующему элементу
					}
				}
				i1++;
			}
			pointsArray = a;
			sortPoints();
		}
		
		// сортируем массив точек по возрастанию
		private function sortPoints(){
			var p:Point;
			for( var i=0; i<pointsArray.length; i++){
				p = pointsArray[i];
				for(var k = i+1; k<pointsArray.length; k++){
					if(p.x > pointsArray[k].x){
						pointsArray[i] = pointsArray[k];
						pointsArray[k] = p;
						p = pointsArray[i];
					}
				}
			}
		}
		
		// получаем все размеры в которых учавствует данная точка
		private function getRazmersWithThisPoint(p:Point):Array {
			var a:Array = new Array();
			var tmp1, tmp2;
			for each (var r in balka.razmer){
				
				if( p.x == r.firstCoord.x || p.x  == r.secondCoord.x) a.push(r);
			}
			
			return a;
		}
		
		// получаем ByteArray для одной точки
		private function getPointVozd( num:uint ):ByteArray {
			
			var pointVozd:ByteArray = new ByteArray();
			pointVozd.length = 100;
			// первые 4 байта номер точки в текстовом виде
			pointVozd.writeMultiByte( String(num), /*"cp866"*/"us-ascii");
			pointVozd.writeByte(0);
			pointVozd.writeByte(0);
			pointVozd.writeByte(0);
			// следующие 6 байт - номера точек до которых имеются размеры
			var p = pointVozd.position;
			pointVozd.writeUnsignedInt(0xffffffff); 
			pointVozd.writeShort(0xffff);
			pointVozd.position = p;
			// получаем массив размеров
			var r:Array = getRazmersWithThisPoint(pointsArray[num]);
			var tmp:*;
			// заполняем номерами соседних точек
			for(var i=0; i<r.length; i++){
				if(r[i].firstCoord.x != pointsArray[num].x){
					tmp = getPointIndex(r[i].firstCoord);	//pointsArray.indexOf(r[i].firstCoord);
					pointVozd.writeByte(tmp);//( pointsArray.indexOf(r[i].firstCoord));
				} else {
					tmp =getPointIndex(r[i].secondCoord);	// pointsArray.indexOf(r[i].secondCoord);
					pointVozd.writeByte(tmp);//( pointsArray.indexOf(r[i].secondCoord));	
				}
			}
			p+=6;
			pointVozd.position = p;

			var p1 = p;
			// записываем обозначения размеров
			for each (i in r){
				pointVozd.writeMultiByte( String(i.getName()), /*"cp866"*/"us-ascii");
				p1 +=5;
				pointVozd.position = p1;
			}
			// обнуляем следующие записи
			// они относятся к численным значениям размеров
			pointVozd.position = p + 30;
			p +=30;
			// определяем 
			for each (i in r){
				if(num > pointsArray.indexOf(i.firstCoord) || num > pointsArray.indexOf(i.secondCoord)){
					pointVozd.writeMultiByte("-" + i.getValue(), /*"cp866"*/"us-ascii");
				} else {
					pointVozd.writeMultiByte( i.getValue(), /*"cp866"*/"us-ascii");
				}
				p += 10;
				pointVozd.position = p;
			}
			pointVozd.position = 0;
			return pointVozd;
		}
		
		private function getPointIndex(p:Point):int {
			for (var i:int=0; i< pointsArray.length; i++){
				if(p.x == pointsArray[i].x) return i;
			}
			return -1;
		}
		
		
		// получаем ByteArray для нагрузки P
		private function getPStructure(f:PForce):ByteArray {
			var forceStructure:ByteArray = new ByteArray();
			// заполняем весь массив нулями
			forceStructure.length = 38;
			forceStructure.writeByte(1 | 4);   // 1 - обозначает P_FORCE
			var p = forceStructure.position;
			forceStructure.writeMultiByte( String(f.getName()), /*"cp866"*/"us-ascii");
			p+=5;
			forceStructure.position = p;
			forceStructure.writeMultiByte( String(f.getIndex()),/*"cp866"*/"us-ascii");
			p+=5;
			forceStructure.position = p;
			forceStructure.writeMultiByte(String(f.getValue()),/*"cp866"*/"us-ascii");		// здесь может быть ошибка из-за большого значения нагрузки
																				// ЧИСЛО НЕ ДОЛЖНО ПРЕВЫШАТЬ 10 СИМВОЛОВ
			p+=10;
			forceStructure.position = p;
			forceStructure.writeMultiByte( String(f.getAngleName()),/*"cp866"*/"us-ascii");
			p+=4;
			forceStructure.position = p;
			forceStructure.writeMultiByte( String(f.getAngle()), /*"cp866"*/"us-ascii");
			p+=10;
			forceStructure.position = p;
			forceStructure.writeByte(f.getChetvert());
			forceStructure.writeByte( getPointIndex(f.getCoord()) );
			return forceStructure;
		}
		
		// получаем ByteArray для нагрузки M
		private function getMStructure(f:MForce):ByteArray {
			var forceStructure:ByteArray = new ByteArray();
			// заполняем весь массив нулями
			forceStructure.length = 38;
			forceStructure.writeByte(0 | 4);   // 0 - обозначает M_FORCE
			var p = forceStructure.position;
			forceStructure.writeMultiByte(f.getName(), /*"cp866"*/"us-ascii");
			p+=5;
			forceStructure.position = p;
			forceStructure.writeMultiByte(f.getIndex(),/*"cp866"*/"us-ascii");
			p+=5;
			forceStructure.position = p;
			forceStructure.writeMultiByte(String(f.getValue()),/*"cp866"*/"us-ascii");		// здесь может быть ошибка из-за большого значения нагрузки
																				// ЧИСЛО НЕ ДОЛЖНО ПРЕВЫШАТЬ 10 СИМВОЛОВ
			p+=24;
			forceStructure.position = p;

			forceStructure.writeByte( getPointIndex(f.getCoord()) );
			return forceStructure;
		}
		
		// получаем ByteArray для нагрузки q
		private function getQStructure(f:QForce):ByteArray {
			var forceStructure:ByteArray = new ByteArray();
			// заполняем весь массив нулями
			forceStructure.length = 38;
			forceStructure.writeByte(2 | 4);   // 2 - обозначает q_FORCE
			var p = forceStructure.position;
			forceStructure.writeMultiByte(f.getName(), /*"cp866"*/"us-ascii");
			p+=5;
			forceStructure.position = p;
			forceStructure.writeMultiByte(f.getIndex(),/*"cp866"*/"us-ascii");
			p+=5;
			forceStructure.position = p;
			forceStructure.writeMultiByte(String(f.getValue()),/*"cp866"*/"us-ascii");		// здесь может быть ошибка из-за большого значения нагрузки
																				// ЧИСЛО НЕ ДОЛЖНО ПРЕВЫШАТЬ 10 СИМВОЛОВ
			p+=25;
			forceStructure.position = p;

			forceStructure.writeByte( getPointIndex(f.getCoord1()) );
			forceStructure.writeByte( getPointIndex(f.getCoord2()) );
			return forceStructure;
		}
		
		// получаем ByteArray для неизвестного момента 
		private function getUnkMStructure(index:String, pt:Point):ByteArray {
			var forceStructure:ByteArray = new ByteArray();
			// заполняем весь массив нулями
			forceStructure.length = 38;
			forceStructure.writeByte(0);   // 0 - обозначает M_FORCE
			var p = forceStructure.position;
			forceStructure.writeMultiByte("M", /*"cp866"*/"us-ascii");
			p+=5;
			forceStructure.position = p;
			forceStructure.writeMultiByte(index,/*"cp866"*/"us-ascii");
			p+=30;
			forceStructure.position = p;
			
			
			forceStructure.writeByte( getPointIndex(pt) );
			return forceStructure;
		}
		
		// получаем ByteArray для неизвестной нагрузки R 
		private function getUnkPStructure(index:String, pt:Point, angle:Number, chetvert:int):ByteArray {
			var forceStructure:ByteArray = new ByteArray();
			// заполняем весь массив нулями
			forceStructure.length = 38;
			forceStructure.writeByte(1);   // 1 - обозначает P_FORCE
			var p = forceStructure.position;
			forceStructure.writeMultiByte("R", /*"cp866"*/"us-ascii");
			p+=5;
			forceStructure.position = p;
			forceStructure.writeMultiByte(index, /*"cp866"*/"us-ascii");
			
			p+=19;
			
			forceStructure.position = p;
			forceStructure.writeMultiByte(String(angle), /*"cp866"*/"us-ascii");
			p+=10;
			forceStructure.position = p;
			forceStructure.writeByte(chetvert);
			
			
			forceStructure.writeByte( getPointIndex(pt) );
			return forceStructure;
		}
	}
}