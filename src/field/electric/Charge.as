package field.electric
{	
	import components.app.Application;
	import components.text.InteractiveTextField;
	
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Charge extends Sprite
	{
		protected static const NEUTRAL:Array = [ 0xFFFFFF, 0xF2F2F2, 0x4D4D4D ];
		protected static const POSITIVE:Array = [ 0xFF0000, 0xED2323, 0x661F1F ];
		protected static const NEGATIVE:Array = [ 0x0000FF, 0x2323ED, 0x1F1F66 ];
		
		protected var _circle:Sprite;
		private var _lines:Shape;
		private var _coulomb:Number;
		private var _currentCharge:Array;
		private var _inputField:InteractiveTextField;
		private var _id:String;
		
		public function Charge( coulomb:Number = 0  )
		{
			super();
			
			_circle = new Sprite();
			addChild( _circle );
			
			_lines = new Shape();
			_circle.addChild( _lines );
			
			this.coulomb = coulomb;
			_circle.doubleClickEnabled = true;
			_circle.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			_circle.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_circle.addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClick);
			
			_circle.buttonMode = true;
			
			_circle.filters = getFilters();
			
			_inputField = new InteractiveTextField();
			_inputField.defaultTextFormat = new TextFormat( "Arial", 10, 0xFFFFFF );
			_inputField.autoSize = TextFieldAutoSize.LEFT;
			_inputField.enableEdit = true;
			_inputField.hightlighting = true;
			_inputField.x = 3;
			_inputField.y = 3;
			_inputField.maxChars = 20;
			_inputField.text = " ";
			addChild( _inputField );
		}
		
		protected function mouseDoubleClick(event:MouseEvent):void
		{
			_inputField.focus();
			_inputField.setSelection(0,0);
			if( _inputField.text == " " )
				_inputField.text = "";
		}
		
		protected function draw():void
		{
			var size:Number = (this.coulomb != 0) ? 20 + 0.6 * Math.log(Math.abs(this.coulomb))/Math.log(10) : 15;
			
			if( size < 10)
				size = 10;
			
			var fillType:String = GradientType.RADIAL;
			var colors:Array = _currentCharge.slice(1,3);
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(size, size, 0, -size/2, -size/2);
			var spreadMethod:String = SpreadMethod.PAD;
			
			_circle.graphics.clear();
			_circle.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);        
			_circle.graphics.drawCircle( 0, 0, size/2);
			_circle.graphics.endFill();
			
			
			_lines.graphics.clear();
			
			if( _currentCharge == NEGATIVE ||  _currentCharge == POSITIVE )
			{
				_lines.graphics.lineStyle( 1, _currentCharge[2] );
				_lines.graphics.moveTo( -size/5, 0);
				_lines.graphics.lineTo( size/5+1, 0);
				
				if( _currentCharge == POSITIVE )
				{
					_lines.graphics.moveTo( 0, -size/5);
					_lines.graphics.lineTo( 0, size/5+1);
				}
				
				_lines.graphics.endFill();
				_lines.blendMode = BlendMode.DARKEN;
			} 
		}
		
		protected function handleColors():void
		{
			if( this.coulomb > 0 )
			{
				_currentCharge = POSITIVE;
			}
			else if( this.coulomb < 0 )
			{
				_currentCharge = NEGATIVE;
			}
			else
			{
				_currentCharge = NEUTRAL;
			}
		}
		
		public function get coulomb():Number
		{
			return _coulomb;
		}
		
		public function set coulomb(value:Number):void
		{
			if(_coulomb != value)
			{
				_coulomb = value;
				handleColors();
				draw();
			}
		}
		
		protected function mouseOverHandler(event:MouseEvent):void
		{
			_circle.filters = getFilters(event.type);
			_circle.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			_circle.filters = getFilters(event.type);
			_circle.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			_circle.filters = getFilters(event.type);
			
			this.startDrag( false, Application.applicationDrawBounds);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onChargeMove);
			//CursorManager.setMoveCursor();
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			_circle.filters = getFilters(event.type);
			
			this.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onChargeMove);
			//CursorManager.removeMoveCursor();
		}
		
		protected function onChargeMove(ebvent:MouseEvent):void
		{
			var event:Event = new Event("chargeMove");
			this.dispatchEvent(event);
		}
		
		private function getFilters(event:String=""):Array
		{
			if(event == MouseEvent.MOUSE_DOWN)
				return null;
			
			var color:uint = _currentCharge[0];
			var alpha:Number = 0.65;
			var blur:Number = (coulomb == 0) ? 2.5 : 18 + 0.8 * Math.log(Math.abs(this.coulomb))/Math.log(10); 
			var strength:Number = (event == MouseEvent.MOUSE_OVER) ? 0.8 : 1.2;
			var quality:int = BitmapFilterQuality.HIGH;
			
			if( blur < 2 )
				blur = 2;
			
			return [ new GlowFilter( color, alpha, blur, blur, strength, quality) ];
		}
		
		override public function toString():String
		{
			return "Charge " + id + " = " + coulomb.toString() + " C";
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
			_inputField.text = id;
		}

	}
}