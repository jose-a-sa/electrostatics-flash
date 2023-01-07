package components.menus
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class SideButton extends SimpleButton
	{
		private var _up:Sprite;
		private var _down:Sprite;
		private var _over:Sprite;
		
		public function SideButton()
		{
			_up = createState( 0xFFFFFF, 0xEEEEEE, 0.1);
			_down = createState( 0xFFFFFF, 0xEEEEEE, 0.4);
			_over = createState( 0xFFFFFF, 0xEEEEEE, 0.7);
			
			super(_up, _down, _over, _up);
		}
		
		public function flipHorizontal():void
		{
			scaleX *= -1;
		}
		
		private function createState(lineColor:uint, fillColor:uint, fillAlpha:Number):Sprite
		{
			var result:Sprite = new Sprite();
			result.graphics.lineStyle( 1, lineColor);
			result.graphics.beginFill( fillColor, fillAlpha );
			result.graphics.moveTo( 4, 20);
			result.graphics.lineTo( -4, 0 );
			result.graphics.lineTo( 4, -20 );
			result.graphics.lineTo( 4, 20 );
			result.graphics.endFill();
			return result;
		}
	}
}