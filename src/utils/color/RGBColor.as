package utils.color
{
	public class RGBColor
	{
		private var _red:uint;
		private var _blue:uint;
		private var _green:uint;
		
		public static function hexStringToRGBColor( hex:String ):RGBColor      
		{
			hex = hex.toLowerCase();
			
			var l:int;
			
			if ( hex.indexOf("0x") > -1 )   
			{
				l   = hex.length - 2;   
				hex = hex.substr( hex.length - l, l );
			}
			if ( hex.indexOf("#") > -1 )    
			{
				l   = hex.length - 1;   
				hex = hex.substr( hex.length - l, l );
			}
			
			l = hex.length;
			
			if ( l > 6 ) 
			{
				hex = hex.substr(0,6);
			}
			
			return new RGBColor( parseInt( hex, 16 ) );               
		}
		
		public function RGBColor(color:uint=-1)
		{			
			if(color != -1)
			{
				this.color = color;  
			}
		}
		
		public function getARGB(alpha:Number):uint 
		{
			if(alpha < 0 || alpha > 1)
			{
				throw new Error("The alpha value expected must be between 0 and 1.");
				return;
			}
			
			var argb:uint = 0;
			argb += ((alpha*255)<<24);
			argb += color;
			
			return argb;
		}
		
		public function getHexString(useCardinal:Boolean=false):String
		{
			var value:String = "";
			value += red.toString(16);
			value += blue.toString(16);
			value += green.toString(16);
			
			return useCardinal ? "#" : "0x" + value.toUpperCase();
		}
		
		public function get color():uint
		{
			return red<<16 | green<<8 | blue;
		}
		
		public function set color(value:uint):void
		{
			red = (value & 0xFF0000) >> 16;
			blue = (value & 0x00FF00) >> 8;
			green = value & 0x000FF;
		}
		
		public function get red():uint
		{
			return _red;
		}
		
		public function set red(value:uint):void
		{
			if(value >= 0 && value <= 255)
			{
				_red = value;
			}
			else
			{
				throw new Error("The red value expected must be between 0 (0x00) and 255 (0xFF).");
			}
		}
		
		public function get blue():uint
		{
			return _blue;
		}
		
		public function set blue(value:uint):void
		{
			if(value >= 0 && value <= 255)
			{
				_blue = value;
			}
			else
			{
				throw new Error("The blue value expected must be between 0 (0x00) and 255 (0xFF).");
			}
		}
		
		public function get green():uint
		{
			return _green;
		}
		
		public function set green(value:uint):void
		{
			if(value >= 0 && value <= 255)
			{
				_green = value;
			}
			else
			{
				throw new Error("The gree value expected must be between 0 (0x00) and 255 (0xFF).");
			}
		}
		
	}
}