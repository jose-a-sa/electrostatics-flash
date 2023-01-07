package utils.color
{
	import flash.display.BitmapData;

	public class ColorUtil
	{
		public static function blendColor( color:uint, into:uint=0xFFFFFFFF, factor:Number=0.5, blendAlpha:Boolean=false ) : uint
		{
			if( factor < 0 || factor > 1 ) factor = 0.5;
			var a1:uint = ( color >> 24 ) & 0xFF;
			var r1:uint = ( color >> 16 ) & 0xFF;
			var g1:uint = ( color >>  8 ) & 0xFF;
			var b1:uint = ( color >>  0 ) & 0xFF;
			var a2:uint = (  into >> 24 ) & 0xFF;
			var r2:uint = (  into >> 16 ) & 0xFF;
			var g2:uint = (  into >>  8 ) & 0xFF;
			var b2:uint = (  into >>  0 ) & 0xFF;
			var a3:uint = ( a1*factor + a2*(1-factor) ) & 0xFF;
			var r3:uint = ( r1*factor + r2*(1-factor) ) & 0xFF;
			var g3:uint = ( g1*factor + g2*(1-factor) ) & 0xFF;
			var b3:uint = ( b1*factor + b2*(1-factor) ) & 0xFF;
			
			return ( blendAlpha ? a3 << 24 : 0x0 ) | (r3<<16) | (g3<<8) | b3;
		}
	
		public static function rgbToXyz(color:uint):Object
		{
			var rgb:RGBColor = new RGBColor(color);
			
			//R from 0 to 255
			//G from 0 to 255
			//B from 0 to 255
			var r:Number = rgb.red/255;
			var g:Number = rgb.green/255;
			var b:Number = rgb.blue/255;
			
			if (r > 0.04045){ r = Math.pow((r + 0.055) / 1.055, 2.4); }
			else { r = r / 12.92; }
			if ( g > 0.04045){ g = Math.pow((g + 0.055) / 1.055, 2.4); }
			else { g = g / 12.92; }
			if (b > 0.04045){ b = Math.pow((b + 0.055) / 1.055, 2.4); }
			else {	b = b / 12.92; }
			
			r = r * 100;
			g = g * 100;
			b = b * 100;
			
			//Observer. = 2°, Illuminant = D65
			var xyz:Object = {x:0, y:0, z:0};
			xyz.x = r * 0.4124 + g * 0.3576 + b * 0.1805;
			xyz.y = r * 0.2126 + g * 0.7152 + b * 0.0722;
			xyz.z = r * 0.0193 + g * 0.1192 + b * 0.9505;
			
			return xyz;
			
		}
		
		public static function xyzToLab(X:Number, Y:Number, Z:Number ):Object
		{
			
			const REF_X:Number = 95.047; // Observer= 2°, Illuminant= D65
			const REF_Y:Number = 100.000; 
			const REF_Z:Number = 108.883; 
			
			var x:Number = X / REF_X;   
			var y:Number = Y / REF_Y;  
			var z:Number = Z / REF_Z;  
			
			if ( x > 0.008856 ) { x = Math.pow( x , 1/3 ); }
			else { x = ( 7.787 * x ) + ( 16/116 ); }
			if ( y > 0.008856 ) { y = Math.pow( y , 1/3 ); }
			else { y = ( 7.787 * y ) + ( 16/116 ); }
			if ( z > 0.008856 ) { z = Math.pow( z , 1/3 ); }
			else { z = ( 7.787 * z ) + ( 16/116 ); }
			
			var lab:Object = {l:0, a:0, b:0};
			lab.l = ( 116 * y ) - 16;
			lab.a = 500 * ( x - y );
			lab.b = 200 * ( y - z );
			
			return lab;
		}
		
		public static function labToXyz( l:Number, a:Number, b:Number ):Object
		{
			
			const REF_X:Number = 95.047; // Observer= 2°, Illuminant= D65
			const REF_Y:Number = 100.000; 
			const REF_Z:Number = 108.883; 
			
			var y:Number = (l + 16) / 116;
			var x:Number = a / 500 + y;
			var z:Number = y - b / 200;
			
			if ( Math.pow( y , 3 ) > 0.008856 ) { y = Math.pow( y , 3 ); }
			else { y = ( y - 16 / 116 ) / 7.787; }
			if ( Math.pow( x , 3 ) > 0.008856 ) { x = Math.pow( x , 3 ); }
			else { x = ( x - 16 / 116 ) / 7.787; }
			if ( Math.pow( z , 3 ) > 0.008856 ) { z = Math.pow( z , 3 ); }
			else { z = ( z - 16 / 116 ) / 7.787; }
			
			var xyz:Object = {x:0, y:0, z:0};
			xyz.x = REF_X * x;     
			xyz.y = REF_Y * y; 
			xyz.z = REF_Z * z; 
			
			return xyz;
		}
		
		public static function xyzToRgb(X:Number, Y:Number, Z:Number):Object
		{
			//X from 0 to  95.047      (Observer = 2°, Illuminant = D65)
			//Y from 0 to 100.000
			//Z from 0 to 108.883
			
			var x:Number = X / 100;        
			var y:Number = Y / 100;        
			var z:Number = Z / 100;        
			
			var r:Number = x * 3.2406 + y * -1.5372 + z * -0.4986;
			var g:Number = x * -0.9689 + y * 1.8758 + z * 0.0415;
			var b:Number = x * 0.0557 + y * -0.2040 + z * 1.0570;
			
			if ( r > 0.0031308 ) { r = 1.055 * Math.pow( r , ( 1 / 2.4 ) ) - 0.055; }
			else { r = 12.92 * r; }
			if ( g > 0.0031308 ) { g = 1.055 * Math.pow( g , ( 1 / 2.4 ) ) - 0.055; }
			else { g = 12.92 * g; }
			if ( b > 0.0031308 ) { b = 1.055 * Math.pow( b , ( 1 / 2.4 ) ) - 0.055; }
			else { b = 12.92 * b; }
			
			var rgb:Object = {r:0, g:0, b:0}
			rgb.r = Math.round( r * 255 );
			rgb.g = Math.round( g * 255 );
			rgb.b = Math.round( b * 255 );
			
			return rgb;
		}
		
		public static function rgbToLab(color:uint):Object
		{
			var xyz:Object = ColorUtil.rgbToXyz(color);
			return ColorUtil.xyzToLab(xyz.x, xyz.y, xyz.z);
		}
	}
}