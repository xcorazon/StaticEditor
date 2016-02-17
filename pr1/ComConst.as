package  pr1
{

  public class ComConst {
    // номера точек положительных и отрицательных направлений осей координат
    public static const OX_PLUS:int = 0;
    public static const OX_MINUS:int = 1;
    public static const OY_PLUS:int = 2;
    public static const OY_MINUS:int = 3;
    public static const FORCE_FROM:int = 4; // сила направлена наружу, от отрезка
    public static const FORCE_TO:int = 5; // сила направлена к отрезку.
    // глобальные события
    public static const LOCK_ALL:String = "Lock all elements";
    public static const DELETE_ELEMENT:String = "Delete force event";
    public static const CHANGE_ELEMENT:String = "Change element";

    // url запросы на получение имени файла, отправки изображения и отправки данных
    public static const URL_GET_NAME:String = "http://teormeh.com/index.php?option=com_statr&task=get_name";
    public static const URL_SEND_BITMAP:String = "http://teormeh.com/index.php?option=com_statr&task=save_png&name=";
    public static const URL_SEND_XML:String = "http://teormeh.com/index.php?option=com_statr&task=save_xml&name=";

    // то же самое если необходимо тестирование
    /*
    public static const URL_GET_NAME:String = "http://teormeh/index.php?option=com_statr&task=get_name";
    public static const URL_SEND_BITMAP:String = "http://teormeh/index.php?option=com_statr&task=save_png&name=";
    public static const URL_SEND_XML:String = "http://teormeh/index.php?option=com_statr&task=save_xml&name=";
    */
  }

}
