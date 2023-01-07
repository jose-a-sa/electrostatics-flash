package field.ui.vector
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	public class Arrow extends VectorFieldObject
	{		
		private var _vector:Vector3D;
		private var _arrow:Shape;
		private var _color:uint;
		
		public function Arrow( vector:Vector3D = null )
		{
			super( vector );
			
			this.color = 0xFFFFFF;
			this.alpha = componentAlpha;
		}
		
		override protected function init():void
		{			
			_arrow = new Shape();
			addChild(_arrow);
		}
		
		override protected function draw():void
		{	
			var cos0:Number = vector.x/vector.length;
			var sin0:Number = vector.y/vector.length;
			
			var drawLength:Number = relativized ? 
				vector.length :
				relativizedVector.length ;
			
			var b:Number = 5;
			var h:Number = drawLength - 8;
			
			_arrow.graphics.clear();
			_arrow.graphics.lineStyle( 1, color );
			
			_arrow.graphics.moveTo( drawLength*cos0, drawLength*sin0);
			_arrow.graphics.lineTo( h*cos0 - b*sin0, h*sin0 + b*cos0);
			_arrow.graphics.moveTo( drawLength*cos0, drawLength*sin0);
			_arrow.graphics.lineTo( h*cos0 + b*sin0, h*sin0 - b*cos0);
			
			_arrow.graphics.moveTo(0, 0);
			_arrow.graphics.lineTo( drawLength*cos0, drawLength*sin0);
			
			this.alpha = componentAlpha;
		}
	}
}