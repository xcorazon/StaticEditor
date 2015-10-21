package  pr1.Shapes{
	import pr1.Shapes.Sealing;
	import flash.geom.Point;
	
	public class MovableJoint extends Sealing {

		public function MovableJoint(color:uint = 0x0) {
			
			var width_op = 25;
			var height_op = 25;
			// заштриховываем нижнюю часть опоры
			this.graphics.clear();
			super.fillShtrih( new Point(-width_op/2, height_op),
						new Point(-width_op/2, height_op + 10),
						new Point(width_op/2, height_op + 10),
						new Point(width_op/2, height_op));
						
			// рисуем над штриховкой полосу			
			graphics.lineStyle(2, color, 1);
			graphics.moveTo(-width_op/2, height_op);
			graphics.lineTo(-4, height_op);

			graphics.moveTo(width_op/2, height_op);
			graphics.lineTo(4, height_op);
			
			// рисуем вертикальную линию
			graphics.moveTo(0, 4);
			graphics.lineTo(0, height_op - 4);
			
			// рисуем окружность в полосе
			graphics.beginFill(0xFFFFFF);
			graphics.drawCircle(0, height_op, 4);
			graphics.endFill();
			
			graphics.lineStyle(2, color, 1);
			graphics.beginFill(0xFFFFFF);
			graphics.drawCircle(0, 0, 4);
			graphics.endFill();
		}

	}
	
}
