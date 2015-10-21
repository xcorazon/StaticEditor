package pr1.razmers {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.JointStyle;
	import flash.geom.Point;
	import flash.text.*;
	
	public class RazmerShape extends Sprite {
		
		private static const COLOR:int = 0x00bbff;
		
		private static var a_x:Array = [0,-20, -15, -20, 0];
		private static var a_y:Array = [0,  4,   0,  -4, 0];
		
		
		public function RazmerShape(text:String, point1:Point, point2:Point, h:int, color:int, hit:Boolean = false){

			// text - размерная надпись
			// point1 - координата первой точки
			// point2 - координата второй точки
			// h - высота размера ( расстояние между point1 и началом стрелки, dy)
			var strelki:Shape = new Shape();
			// отрисовываем вертикальные боковые линии
			strelki.graphics.moveTo(point1.x, point1.y);
			var dy:Number;
			if(h>0) {dy=4;}
			else {dy = -4;}
			
			var y_end:Number = point1.y + h + dy;
			
			strelki.graphics.lineStyle(1, color ,1 ,false ,"normal" ,null ,JointStyle.MITER);
			if(!hit){
				strelki.graphics.lineTo(point1.x, y_end);
				strelki.graphics.moveTo(point2.x, point2.y);
				strelki.graphics.lineTo(point2.x, y_end);
			}
			var x, y:Number;
			var p:Point;
			
			if(point2.x < point1.x){
				p = point1;
				point1 = point2;
				point2 = p;
			}
			
			p = new Point(point2.x, y_end - dy);
			// отрисовка правой стрелки
			strelki.graphics.lineStyle(1, color ,1 ,false ,"normal" ,null ,JointStyle.MITER);
			strelki.graphics.beginFill(color);
			strelki.graphics.moveTo(p.x-1, p.y);

			for( var i = 1; i <= 4; i++) {
				strelki.graphics.lineTo(p.x-1 + a_x[i], p.y + a_y[i]);
			}
			strelki.graphics.endFill();
			
			var angle:Number = Math.PI;
			
			// отрисовка левой стрелки
			p = new Point(point1.x+1, y_end - dy);
			strelki.graphics.lineStyle(1, color ,1 ,false ,"normal" ,null ,JointStyle.MITER);
			strelki.graphics.beginFill(color);
			
			strelki.graphics.moveTo(p.x, p.y);
			
			for( i = 1; i <= 4; i++) {
				//преобразовываем координаты каждой точки стрелки
				x = a_x[i]*Math.cos(angle) - a_y[i]*Math.sin(angle);
				y = a_x[i]*Math.sin(angle) + a_y[i]*Math.cos(angle);
				strelki.graphics.lineTo(p.x + x, p.y - y);
			}
			strelki.graphics.endFill();
			
			// проводим горизонтальную линию
			strelki.graphics.moveTo(p.x, p.y);
			strelki.graphics.lineTo(point2.x-2, p.y);
			addChild(strelki);
			//добавляем текст
			var nadpis:TextField = new TextField();
			var txtFormat:TextFormat = new TextFormat("Times New Roman", 18, 0x0, true);
			txtFormat.italic = true;
			nadpis.defaultTextFormat = txtFormat;
			nadpis.text = text;
			nadpis.height = nadpis.textHeight + 4;
			nadpis.width = nadpis.textWidth + 5;
			nadpis.multiline = false;
			nadpis.x = (point2.x + point1.x)/2 - nadpis.width/2;
			nadpis.y = point1.y + h - nadpis.height;
			addChild(nadpis);
		}
	
	}

}