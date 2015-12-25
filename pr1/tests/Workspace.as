package  pr1.tests {
  import flash.display.Sprite;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.*;
  import pr1.Snap;
  
  public class Workspace extends Sprite {
    
    private var snap1:Snap;
    
    public function Workspace() {
      // constructor code
    }
    
    public function set snap(s:Snap){
      snap1 = s;
    }
    
    public function get snap():Snap {
      return snap1;
    }
    
    // получить растровое изображение из векторного
    public function getBitmap():BitmapData {
      var width:uint =800 * 3;  // масштаб растра больше чем матрицы масштабирования для запаса
      var height:uint = 600 * 3;
      var bmp1:BitmapData = new BitmapData(width, height, false, 0xffffffff);
      
      var m:Matrix = new Matrix();
      m.scale(2.5, 2.5);
      m.translate(200,200);
      bmp1.draw (this, m, null, null, null, true);
      var rect:Rectangle = new Rectangle(0,0,0,0);
      rect.left = bmp1.width-1;
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

  }
  
}
