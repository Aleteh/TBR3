package 
{
    import flash.display.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;

    public class Utils extends Object
    {

        public function Utils()
        {
            return;
        }// end function

        public static function replaceWithValveComponent(param1:DisplayObjectContainer, param2:String, param3:Boolean = false) : MovieClip
        {
            var newObjectClass:Class;
            var disp:* = param1;
            var type:* = param2;
            var keepDimensions:* = param3;
            var parent:* = disp.parent;
            var oldX:* = disp.x;
            var oldY:* = disp.y;
            var oldWidth:* = disp.width;
            var oldHeight:* = disp.height;
            try
            {
                newObjectClass = getDefinitionByName(type) as Class;
            }
            catch (error:ReferenceError)
            {
                return null;
            }
            var newObject:* = new newObjectClass;
            newObject.x = oldX;
            newObject.y = oldY;
            if (keepDimensions)
            {
                newObject.width = oldWidth;
                newObject.height = oldHeight;
            }
            parent.removeChild(disp);
            parent.addChild(newObject);
            return newObject;
        }// end function

        public static function CreateLabel(param1:String, param2:String, param3:Function = null) : TextField
        {
            var _loc_4:* = new TextField();
            _loc_4.selectable = false;
            var _loc_5:* = new TextFormat();
            _loc_5.font = param2;
            _loc_5.color = 14540253;
            _loc_4.defaultTextFormat = _loc_5;
            _loc_4.text = param1;
            _loc_4.autoSize = TextFieldAutoSize.NONE;
            return _loc_4;
        }// end function

        public static function ItemNameToTexture(param1:String) : DisplayObject
        {
            var _loc_2:* = param1.replace("item_", "images\\items\\") + ".png";
            var _loc_3:* = new Loader();
            _loc_3.load(new URLRequest(_loc_2));
            return _loc_3;
        }// end function

        public static function Log(... args) : void
        {
            return;
        }// end function

        public static function LogError(param1:Error) : void
        {
            Log(param1.message);
            Log("\n" + param1.getStackTrace());
            return;
        }// end function

    }
}
