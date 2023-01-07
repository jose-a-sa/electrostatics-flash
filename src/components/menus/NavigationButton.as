package components.menus
{
	import components.text.InteractiveTextField;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.sampler.Sample;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import utils.ImageUtils;
	import utils.assets.LibManager;
	
	public class NavigationButton extends Sprite
	{		
		private var _direction:String = "up";
		private var _icon:Bitmap;
		private var _iconHolder:Sprite;
		private var _textField:InteractiveTextField
		
		public function NavigationButton()
		{
			super();
			init();
			this.buttonMode = true;
			invalidateHitArea();
			
			alpha = 0.7;
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			alpha = 1.0;
		}
		protected function onMouseOut(event:MouseEvent):void
		{
			removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			alpha = 0.7;
		}
		
		protected function invalidateHitArea():void
		{
			var s:Sprite = new Sprite();
			var r:Rectangle = getBounds(this);
			s.graphics.beginFill( 0x000000 );
			s.graphics.drawRect( r.x, r.y, r.width, r.height);
			s.graphics.endFill();

			this.hitArea = s;
		}
		
		protected function init():void
		{
			_iconHolder = new Sprite();
			_iconHolder.x = 18;
			_iconHolder.y = 23;
			addChild( _iconHolder );
		
			_icon = ImageUtils.renderToBitmap( new Bitmap(  LibManager.instance.getInstance("MetroArrow") as BitmapData ), 30, 30);
			_icon.x = -15; 
			_icon.y = -15; 
			_iconHolder.addChild( _icon );
			
			invalidateBtnDirection(direction);
			
			_textField = new InteractiveTextField();
			_textField.defaultTextFormat = new TextFormat("HelveticaNeue LT 25 UltLight", 32, 0x000000);
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.buttonMode = true;
			_textField.x = 33;
			addChild( _textField );
		}
		
		protected function invalidateBtnDirection(direction:String):void
		{
			var angle:Number;
			
			switch(direction)
			{
				case "up": angle = -90;
					break;
				case "left": angle = 180
					break;
				case "down": angle = 90;
					break;
				case "right": angle = 0; 
					break;
			}
			
			_iconHolder.rotation = angle;
		}
		
		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			_direction = value;
			invalidateBtnDirection(direction);
		}

		public function get label():String
		{
			return _textField.text;
		}

		public function set label(value:String):void
		{
			_textField.text = value;
			invalidateHitArea();
		}


	}
}