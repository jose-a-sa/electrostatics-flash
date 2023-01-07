package components.menus
{
	import com.greensock.TweenMax;
	
	import components.app.Application;
	import components.text.InteractiveTextField;
	
	import field.electric.ElectricField;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SideMenu extends Sprite
	{
		private var _hidden:Boolean = true;
		private var _backgroundColor:uint = 0xEEEEEE;
		private var _backgroundAlpha:Number = 1;
		private var _background:Sprite;
		private var _panelWidth:Number = 230;
		
		private var _header:Sprite;
		private var _title:InteractiveTextField;
		private var _upNavBtn:NavigationButton;
		private var _downNavBtn:NavigationButton;
		
		private var _sideButton:SideButton;
		
		public var electricField:ElectricField;
		
		private var _currentPanelTitle:String = "";
		private var _prevPanelTitle:String = "";
		private var _nextPanelTitle:String = "";
		
		public function SideMenu()
		{
			super();
			
			init();
			initHeader();
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function init():void
		{
			_background = new Sprite();
			_background.filters = [new GlowFilter(0xCCCCCC, 0.6, 6, 6, 1.2, BitmapFilterQuality.HIGH)];
			addChild( _background );
			
			_sideButton = new SideButton();
			addChild( _sideButton );
			
			_sideButton.addEventListener( MouseEvent.CLICK, sideBtnClick );
		}
		
		protected function initHeader():void
		{
			_header = new Sprite();
			addChild( _header );
			
			var textFormat:TextFormat = new TextFormat( "HelveticaNeue LT 45 Light", 38, 0x000000 );
			textFormat.leading = 0;
			
			_title = new InteractiveTextField()
			_title.autoSize = TextFieldAutoSize.LEFT;
			_title.x = 5;
			_title.y = 40;
			_title.defaultTextFormat = textFormat;
			_title.text = _currentPanelTitle;
			_header.addChild( _title );
			
			_upNavBtn = new NavigationButton();
			_upNavBtn.direction = "up";
			_upNavBtn.label = _prevPanelTitle;
			_upNavBtn.x = 5;
			_upNavBtn.y = 5;
			_header.addChild(_upNavBtn);
			
			_downNavBtn = new NavigationButton();
			_downNavBtn.direction = "down";
			_downNavBtn.label = _nextPanelTitle;
			_downNavBtn.x = 5;
			_downNavBtn.y = 82;
			_header.addChild(_downNavBtn);
		}
		
		protected function drawBackground():void
		{
			_background.graphics.clear();
			_background.graphics.beginFill( _backgroundColor, _backgroundAlpha );
			_background.graphics.drawRect( 0, 0, _panelWidth, Application.applicationHeight );
			_background.graphics.endFill();
		}
		
		protected function onAddedToStage(event:Event):void
		{
			drawBackground();
			
			this.x = hidden ? Application.applicationWidth+6 : Application.applicationWidth+6 - _panelWidth;
			this.y = 0;
			
			_sideButton.x = -15;
			_sideButton.y = Application.applicationHeight/2;
			
			stage.addEventListener( Event.RESIZE, onResize );
		}
		
		protected function onResize(event:Event):void
		{
			drawBackground();
			
			_sideButton.y = Application.applicationHeight/2;
			
			if( !TweenMax.isTweening(this) )
				this.x = hidden ? Application.applicationWidth+6 : Application.applicationWidth+6 - _panelWidth;
		}
		
		
		protected function sideBtnClick(event:MouseEvent):void
		{
			_sideButton.flipHorizontal();
			
			hidden ? show() : hide();
		}
		
		public function hide():void
		{
			if(!_hidden)
				TweenMax.to( this, 0.5, {
					x: Application.applicationWidth+6,
					onComplete: function():void { _hidden=true; }
				});
		}
		
		public function show():void
		{
			if(_hidden)
				TweenMax.to( this, 0.5, {
					x: Application.applicationWidth+6 - _panelWidth, 
					onComplete: function():void { _hidden=false; }
				});
		}
		
		public function get hidden():Boolean
		{
			return _hidden;
		}
	}
}