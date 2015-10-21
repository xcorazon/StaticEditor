package pr1 {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*; //TextField;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	import pr1.forces.QForce;
	import pr1.forces.PForce;
	import pr1.forces.MForce;
	import pr1.razmers.Razmer;
	import pr1.windows.EditWindow;
	
	public class Balka extends Sprite {
		// константы для редактирования нагрузок и размеров
		public static const NO_CHANGE:int = 0;	// нагрузка P
		public static const P_CHANGE:int = 1;	// нагрузка P
		public static const Q_CHANGE:int = 2;	// нагрузка Q
		public static const M_CHANGE:int = 3;	// нагрузка M
		public static const L_CHANGE:int = 4;	// линейный размер
		public static const O_CHANGE:int = 5;	// добавление и изменение положения опор
		
		private var element:int;		// текущий редактируемый элемент
							// принимает значения выше приведенных констант
		private var qForces:Array;
		private var pForces:Array;
		private var mForces:Array;
		private var razmers:Array;
		
		private var opora1:Opora1;
		private var opora2:Opora2;
		private var opora3:Opora3;
		
		private var unknownReactions:int = 0;
		
		private var numValidQForces:int;
		private var numValidPForces:int;
		
		private var otrezok:Array; 			//координаты отрезка содержащего силы, опоры, размеры
		
		
		public function Balka():void {
			
			otrezok = new Array( new Point(150, 200), new Point(650, 200));
			createBalka();
			
			razmers = new Array();
			pForces = new Array();
			mForces = new Array();
			qForces = new Array();
			opora1 = null;
			opora2 = null;
			opora3 = null;
			otrezok = new Array( new Point(150, 200), new Point(650, 200));						
		}
		// функция которая изменяет активность редактируемых элементов
		public function changeActiveElement(element:int):void {
			this.element = element;
			switch(element) {
				case NO_CHANGE:
					deactivateQForces();
					deactivatePForces();
					deactivateMForces();
					deactivateRazmer();
					break;
				case P_CHANGE:
					deactivateQForces();
					deactivateMForces();
					deactivateRazmer();
					activatePForces();
					break;
				case Q_CHANGE:
					activateQForces();
					deactivateMForces();
					deactivatePForces();
					deactivateRazmer();
					break;
				case M_CHANGE:
					deactivateQForces();
					activateMForces();
					deactivatePForces();
					deactivateRazmer();
					break;
				case L_CHANGE:
					deactivateQForces();
					deactivateMForces();
					deactivatePForces();
					activateRazmer();
					break;
			}
		}
		
		private function createBalka():void {
			
			var line:Shape = new Shape();
						
			line.graphics.lineStyle(2);
			line.graphics.moveTo(otrezok[0].x, otrezok[0].y);
			line.graphics.lineTo(otrezok[1].x, otrezok[1].y);
			addChild(line);
		}
		
		
		
		// получить масив нагрузок
		public function get forces():Array {
			return pForces;
		}
		// получить масив моментов
		public function get moments():Array {
			return mForces;
		}
		// получить распределенные нагрузки
		public function get ql():Array {
			return qForces;
		}
		// получить массив размеров
		public function get razmer():Array {
			return razmers;
		}
		//получить массив пор
		public function get opora():Array {
			var a:Array = new Array();
			if(opora1 != null) a.push(opora1);
			if(opora2 != null) a.push(opora2);
			if(opora3 != null) a.push(opora3);
			
			return a;
		}
		
		// функции добавления и удаления размеров из массива размеров
		public function addRazmer(razm:Razmer):void {
			razmers.push(razm);
			addChild(razm);
		}
		
		public function removeRazmer(razm:Razmer):void {
			var i:int = razmers.indexOf(razm);
			trace("удаляем размер номер ",i)
			razmers.splice(i,1);
			removeChild(razm);
		}
		// функции добавления и удаления нагрузки P
		public function addPForce(force:PForce):void {
			pForces.push(force);
			addChild(force);
		}
		
		public function removePForce(force:PForce):void {
			var i:int = pForces.indexOf(force);
			trace("удаляем силу номер ",i)
			pForces.splice(i,1);
			removeChild(force);
		}
		
		// функции добавления и удаления нагрузки M
		public function addMForce(force:MForce):void {
			mForces.push(force);
			addChild(force);
		}
		
		public function removeMForce(force:MForce):void {
			var i:int = mForces.indexOf(force);
			trace("удаляем силу номер ",i)
			mForces.splice(i,1);
			removeChild(force);
		}
		
		// функции добавления и удаления нагрузки Q
		public function addQForce(force:QForce):void {
			qForces.push(force);
			addChild(force);
		}
		
		public function removeQForce(force:QForce):void {
			var i:int = qForces.indexOf(force);
			trace("удаляем силу номер ",i)
			qForces.splice(i,1);
			removeChild(force);
		}
		
		// функции добавления и удаления опор на(с) экран(а)
		public function addOpora(opora):void {
			if(opora is Opora3){
				opora3 = opora;
				addChild(opora3);
				unknownReactions +=3;
			} else if(opora is Opora2){
				opora2 = opora;
				addChild(opora2);
				unknownReactions +=2;
			} else if( opora is Opora1){
				opora1 = opora;
				addChild(opora1);
				unknownReactions++;
			}
		}
		
		public function removeOpora(opora):void {
			if(opora is Opora3){
				removeChild(opora3);
				opora3 = null;
				unknownReactions -=3;
			} else if(opora is Opora2){
				removeChild(opora2);
				opora2 = null;
				unknownReactions -=2;
			} else if( opora is Opora1){
				removeChild(opora1);
				opora1 = null;				
				unknownReactions--;
			}
		}
		
		// возвращает координаты балки на экране в виде 
		// массива точек (Points)
		public function get balkaCoords():Array {
			return otrezok;
		}
		// возвращает число неизвестных нагрузок
		public function get numReactions():int {
			return unknownReactions;
		}
		// сделать на время нагрузки недоступными
		public function deactivateForces():void {
					deactivatePForces();
					deactivateQForces();
					deactivateMForces();
					deactivateRazmer();
					deactivateOpora();
		}
		
		// сделать нагрузки доступными
		public function activateForces():void {
					activatePForces();
					activateQForces();
					activateMForces();
					activateRazmer();
					activateOpora();
		}
		
		// сделать на время нагрузки недоступными
		private function deactivateQForces():void {
			for (var q in qForces){
				qForces[q].deactivate();
			}
		}
		
		// сделать нагрузки доступными
		private function activateQForces():void {
			for(var q in qForces){
				qForces[q].activate();
			}
		}
		
		// сделать на время нагрузки недоступными
		private function deactivatePForces():void {
			for (var p in pForces){
				pForces[p].deactivate();
			}
		}
		
		// сделать нагрузки доступными
		private function activatePForces():void {
			for (var p in pForces){
				pForces[p].activate();
			}	
		}
		
		// сделать на время нагрузки недоступными
		private function deactivateMForces():void {
			for (var m in mForces){
				mForces[m].deactivate();
			}
		}
		
		// сделать нагрузки доступными
		private function activateMForces():void {
			for (var m in mForces){
				mForces[m].activate();
			}
		}
		
		// сделать размеры недоступными для редактирования
		private function deactivateRazmer():void {
			for (var m in razmer){
				razmer[m].deactivate();
			}
		}
		
		// сделать размеры доступными для редактирования
		private function activateRazmer():void {
			for (var m in razmer){
				razmer[m].activate();
			}
		}
		
		// сделать опоры недоступными для редактирования
		private function deactivateOpora():void {
			if(opora1 != null)	opora1.deactivate();
			if(opora2 != null)	opora2.deactivate();
			if(opora3 != null)	opora3.deactivate();

		}
		
		// сделать опоры доступными для редактирования
		private function activateOpora():void {
			if(opora1 != null)	opora1.activate();
			if(opora2 != null)	opora2.activate();
			if(opora3 != null)	opora3.activate();
		}
		
		public function deleteNenuzhnieRazmeri(){
			var r:Razmer;
			var element:*;
			var first:Boolean;
			var second:Boolean;
			var a:Array = new Array();
			for ( var i in this.razmers){
				first = false;
				second = false;
				
				r = this.razmers[i];
				// проверяем сконцентрированные нагрузки
				for each ( element in this.forces){
					
					if(r.firstCoord == element.getCoord()) first = true;
					if(r.secondCoord == element.getCoord()) second = true;
					if(first && second) break;
				}
				if( first && second) continue;
				// проверяем распределенные на грузки
				for each (element in this.ql) {
					if(r.firstCoord == element.getCoord1() || r.firstCoord == element.getCoord2())
						first = true;
					if(r.secondCoord == element.getCoord1() || r.secondCoord == element.getCoord2())
						second = true;
					if(first && second) break;
				}
				if( first && second) continue;
				// проверяем моменты
				for each (element in this.moments){
					if(r.firstCoord == element.getCoord()) first = true;
					if(r.secondCoord == element.getCoord()) second = true;
					if(first && second) break;
				}
				if( first && second) continue;
				// проверяем опоры
				for each (element in this.opora){
					if(r.firstCoord == element.getCoord()) first = true;
					if(r.secondCoord == element.getCoord()) second = true;
					if(first && second) break;
				}
				// если хотябы одна точка размера не привязана к нагрузке или опоре
				// то удаляем этот размер
				if(!(first && second)) a.push(r);
			}
			for each ( i in a){
				this.removeRazmer(i);
			}
		}
	}
}