package utils.color
{

	public class ColorDifferenceAlgorithm
	{
		private static const A:Number = 0.30;
		private static const B:Number = 0.59;
		private static const C:Number = 0.11;
		
		public static const SIMPLE:Function = function(color1:uint, color2:uint):Number
		{
			var c1:RGBColor = new RGBColor(color1);
			var c2:RGBColor = new RGBColor(color2);
			
			var value:Number = Math.sqrt( 
				Math.pow( A*(c2.red-c1.red), 2) + 
				Math.pow( B*(c2.green-c1.green), 2) + 
				Math.pow( C*(c2.blue-c1.blue), 2)
			);
			
			var maxValue:Number = Math.sqrt( (A*A + B*B + C*C) * Math.pow(255,2) );
			
			return 1 - value/maxValue;
		}
			
		public static const CIE76:Function = function(color1:uint, color2:uint):Number
		{
			var c1:Object = ColorUtil.rgbToLab(color1);
			var c2:Object = ColorUtil.rgbToLab(color2);
				
			var value:Number = Math.sqrt( 
				Math.pow( c2.l-c1.l, 2) + 
				Math.pow( c2.a-c1.a, 2) + 
				Math.pow( c2.b-c1.b, 2)
			);
			
			return value;
		}
			
		public static const CIE94:Function = function( color1:uint, color2:uint):Number
		{
			var c1:RGBColor = new RGBColor(color1);
			var c2:RGBColor = new RGBColor(color2);
			
			var value:Number = Math.sqrt( 
				Math.pow( A*(c2.red-c1.red), 2) + 
				Math.pow( B*(c2.green-c1.green), 2) + 
				Math.pow( C*(c2.blue-c1.blue), 2)
			);
			
			var maxValue:Number = Math.sqrt( (A*A + B*B + C*C) * Math.pow(255,2) );
			
			return 1 - value/maxValue;
		}
	}
}