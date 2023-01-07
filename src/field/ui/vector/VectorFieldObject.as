package field.ui.vector
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	public class VectorFieldObject extends Sprite
	{
		private var _vector:Vector3D;
		private var _color:uint;
		
		protected var minDrawLength:Number;
		protected var maxDrawLength:Number;
		protected var relativized:Boolean;
		
		public function VectorFieldObject( vector:Vector3D = null )
		{
			super();
			
			init();
			
			if(vector)
				this.vector = vector;
			else
				this.vector = new Vector3D();
			
			relativize( 50, 10 );
		}
		
		protected function init():void
		{
			
		}
		
		protected function draw():void
		{
			
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
			draw();
		}
		
		public function get vector():Vector3D
		{
			return _vector;
		}
		
		public function set vector(value:Vector3D):void
		{
			_vector = value;
			draw();
		}
		
		public function get relativizedVector():Vector3D
		{
			var relativeLength:Number = Math.sqrt( 0.1*vector.length );
			
			if(relativeLength < minDrawLength)
				relativeLength = minDrawLength;
			else if(relativeLength > maxDrawLength)
				relativeLength = maxDrawLength;
			
			return new Vector3D(
				relativeLength * vector.x/vector.length,
				relativeLength * vector.y/vector.length
			);
		}
		
		public function relativize(maxLength:Number, minLength:Number):void
		{
			maxDrawLength = maxLength;
			minDrawLength = minLength;
			relativized = true;
			draw();
		}
		public function derelativize():void
		{
			maxDrawLength = int.MAX_VALUE;
			minDrawLength = 0;
			relativized = false;
			draw();
		}
		
		protected function get componentAlpha():Number
		{
			var minAlpha:Number = 0.2;
			var alpha:Number = minAlpha + (1-minAlpha) * (relativizedVector.length-minDrawLength)/(maxDrawLength-minDrawLength);
			
			if(alpha < minAlpha)
				alpha = minAlpha;
			else if(alpha > 1)
				alpha = 1;
			
			if(relativized)
				return alpha;
			else
				return 1;
		}
	}
}