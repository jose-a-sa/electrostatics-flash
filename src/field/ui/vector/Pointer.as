package field.ui.vector
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	public class Pointer extends VectorFieldObject
	{
		private var _head:Shape;
		private var _container:Sprite;
		
		public function Pointer( vector:Vector3D = null )
		{
			super( vector );
			
			this.color = 0xFFFFFF;
			this.alpha = componentAlpha;
		}
		
		override protected function init():void
		{			
			_head = new Shape();
			
			drawHead();
			
			_container = new Sprite();
			_container.addChild(_head);
			addChild( _container );
		}
		
		protected function drawHead():void
		{
			_head.graphics.clear();
			_head.graphics.beginFill( color );
			_head.graphics.moveTo(-14/2, 7/2);
			_head.graphics.lineTo(14/2, 0);
			_head.graphics.lineTo(-14/2, -7/2);
			_head.graphics.lineTo(-14/2, 7/2);
			_head.graphics.endFill();
		}
		
		override protected function draw():void
		{				
			_container.rotation = Math.atan2( vector.y, vector.x) * 180/Math.PI;
			
			this.alpha = componentAlpha;
		}
		
		override public function set color(value:uint):void
		{
			super.color = value;
			drawHead();
			draw();
		}
	}
}