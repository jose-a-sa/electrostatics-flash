package components.app
{
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.errors.InvalidSWFError;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import components.text.InteractiveTextField;
	
	public class StatusBar extends Sprite
	{		
		protected var leftTextField:InteractiveTextField;
		protected var rightTextField:InteractiveTextField;
		
		public function StatusBar()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.RESIZE, onResize);
		}
		
		protected function onResize(event:Event):void
		{
			invalidateTexts();
		}
		
		protected function draw():void
		{
			graphics.clear();
			
			var fillMatrix:Matrix = new Matrix();
			fillMatrix.createGradientBox( stage.stageWidth, 24, -Math.PI/2);
			
			graphics.beginGradientFill(
				GradientType.LINEAR,
				[ 0xFFFFFF-0xE2E2E2, 0xFFFFFF-0xD9D9D9 ],
				[ 1, 1 ],
				[ 0, 255 ],
				fillMatrix,
				SpreadMethod.PAD
			);
			graphics.drawRect( 0, 0, stage.stageWidth, 24 );
			graphics.endFill();
			
			var strokeMatrix:Matrix = new Matrix();
			strokeMatrix.createGradientBox( stage.stageWidth-3, 22, -Math.PI/2);
			
			graphics.lineStyle( 1 );
			graphics.lineGradientStyle(
				GradientType.LINEAR,
				[ 0xFFFFFF-0xEAEAEA, 0xFFFFFF-0xBEBEBE ],
				[ 1, 1 ],
				[ 0, 255 ],
				strokeMatrix,
				SpreadMethod.PAD
			);
			graphics.drawRect( 1, 1, stage.stageWidth-3, 22 );
		}
		
		protected function onAddedToStage(event:Event):void
		{
			draw();
			initFields();
			stage.addEventListener(Event.RESIZE, onStageResize );
		}
		
		protected function initFields():void
		{
			var textFormat:TextFormat = new TextFormat( "Arial", 11, 0xFFFFFF);
			
			leftTextField = new InteractiveTextField();
			leftTextField.defaultTextFormat = textFormat;
			leftTextField.autoSize = TextFieldAutoSize.LEFT;
			//leftTextField.hightlighting = true;
			addChild( leftTextField );
			
			rightTextField = new InteractiveTextField();
			rightTextField.defaultTextFormat = textFormat;
			rightTextField.autoSize = TextFieldAutoSize.LEFT;
			//rightTextField.hightlighting = true;
			addChild( rightTextField );
		}
		
		protected function onStageResize(event:Event):void
		{
			draw();
			invalidateTexts();
			this.y = stage.stageHeight -24;
		}
		
		protected function invalidateTexts():void
		{
			leftTextField.x = 10;
			leftTextField.y = this.height/2 - leftTextField.height/2;
			
			rightTextField.x = stage.stageWidth - rightTextField.width - 10;
			rightTextField.y = this.height/2 - leftTextField.height/2;
		}
		
		public function get leftLabel():String
		{
			return leftTextField.text;
		}
		public function set leftLabel(value:String):void
		{
			leftTextField.text = value;
			invalidateTexts();
		}
		public function get rightLabel():String
		{
			return rightTextField.text;
		}
		public function set rightLabel(value:String):void
		{
			rightTextField.text = value;
			invalidateTexts();
		}
	}
}