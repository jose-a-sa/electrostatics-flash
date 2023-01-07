package components.text
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class InteractiveTextField extends TextField
	{
		private var _enableEdit:Boolean = false;
		private var _hoverState:Boolean = false;
		private var _focusState:Boolean = false;
		private var _hightlighting:Boolean = false;
		private var _acceptEmptyText:Boolean = true;
		private var _buttonMode:Boolean = false;
		
		public function InteractiveTextField()
		{
			super();
			
			initFormat();
			
			if(enableEdit)
				addEventListener( FocusEvent.FOCUS_IN, textFocusIn );
			
			addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
			addEventListener( MouseEvent.CLICK, mouseClickHandler );
			addEventListener( FocusEvent.FOCUS_OUT, textFocusOut );
		}

		public function get acceptEmptyText():Boolean
		{
			return _acceptEmptyText;
		}

		public function set acceptEmptyText(value:Boolean):void
		{
			_acceptEmptyText = value;
		}

		protected function initFormat():void
		{
			invalidateAlpha();
			selectable = false;
			embedFonts = true;
			antiAliasType = AntiAliasType.ADVANCED;
		}
		
		protected function invalidateAlpha():void
		{
			if( !_hightlighting || _hoverState || _focusState )
				alpha = 1;
			else
				alpha = 0.7;
		}
		
		protected function mouseClickHandler(event:MouseEvent):void
		{
			focus();
			
			if(!enableEdit)
				Mouse.cursor = MouseCursor.ARROW;
			
			if(buttonMode && _hoverState)
				Mouse.cursor = MouseCursor.BUTTON;
			
			invalidateAlpha();
		}
		
		protected function textFocusIn(event:FocusEvent):void
		{
			_focusState = true;
			
			if(enableEdit)
			{
				type = TextFieldType.INPUT;
				setSelection( text.length, text.length); 
				selectable = true;
			}
			
			addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{			
			switch(event.keyCode)
			{
				case Keyboard.ENTER:
					unfocus();
					break;
			}
		}
		
		protected function textFocusOut(event:FocusEvent):void
		{				
			removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			
			_focusState = false;
			
			type = TextFieldType.DYNAMIC;
			selectable = false;
				
			if(!_acceptEmptyText && enableEdit)
				if(text.length == 0)
					focus();
			
			invalidateAlpha();
		}
		
		protected function mouseOverHandler(event:MouseEvent):void
		{				
			_hoverState = true;
			
			if(!enableEdit)
				Mouse.cursor = MouseCursor.ARROW;
			
			if(buttonMode)
				Mouse.cursor = MouseCursor.BUTTON;
			
			invalidateAlpha();
			
			addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
		}
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			_hoverState = false;
			
			Mouse.cursor = MouseCursor.AUTO;
			
			invalidateAlpha();
			
			removeEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
		}
		
		public function focus():void
		{
			stage.focus = this;
			this.setSelection(0,this.length);
			if( this.text == " " )
				this.text = "";
		}
		
		public function unfocus():void
		{
			if(stage.focus == this) 
				stage.focus = null;
		}
		
		public function get enableEdit():Boolean
		{
			return _enableEdit;
		}
		
		public function set enableEdit(value:Boolean):void
		{
			_enableEdit = value;
			
			if(enableEdit)
				addEventListener( FocusEvent.FOCUS_IN, textFocusIn );
			else
				removeEventListener( FocusEvent.FOCUS_IN, textFocusIn );
		}
		
		public function get hightlighting():Boolean
		{
			return _hightlighting;
		}
		
		public function set hightlighting(value:Boolean):void
		{
			_hightlighting = value;
			
			invalidateAlpha();
		}

		public function get buttonMode():Boolean
		{
			return _buttonMode;
		}

		public function set buttonMode(value:Boolean):void
		{
			_buttonMode = value;
			
			if(_hoverState && buttonMode)
				Mouse.cursor = MouseCursor.BUTTON;
		}

	}
}