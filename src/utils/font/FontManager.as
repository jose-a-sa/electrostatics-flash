package utils.font
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.Font;
	
	[Event(type="utils.font.FontManagerEvent", name="FontManagerEvent::singleLoadComplete")]
	[Event(type="utils.font.FontManagerEvent", name="FontManagerEvent::loadComplete")]
	
	public class FontManager extends EventDispatcher
	{
		public static var instance:FontManager;
		
		private var _urls:Vector.<String>;
		private var _fontLoaders:Vector.<Loader>;
		private var _fontDefinitions:Vector.<String>;
		private var _fontLoadedStates:Vector.<Boolean>;
		
		private var _loadComplete:Boolean = false;
		
		public function FontManager( staticStore:Boolean=false, urls:Array=null, context:LoaderContext=null ):void
		{
			super();
			
			_fontDefinitions = new Vector.<String>();
			
			if(urls)
				loadFonts( urls, context );
				
			if(staticStore)
				FontManager.instance = this;
		}
		
		public function get fontDefinitions():Vector.<String>
		{
			return _fontDefinitions;
		}

		public function loadFonts( urls:Array, context:LoaderContext=null ):void
		{
			_loadComplete = false;
			_urls = Vector.<String>(urls);
			_fontLoaders = new Vector.<Loader>();
			_fontLoadedStates = new Vector.<Boolean>();
			
			for( var i:uint = 0; i < _urls.length; i++)
			{
				var loader:Loader = new Loader();
				loader.load( new URLRequest(_urls[i]), context );
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, fontLoadComplete ) 
				_fontLoaders.push(loader);
				_fontLoadedStates[i] = false;
			}
		}
		
		protected function fontLoadComplete(event:Event):void
		{
			var loader:Loader = LoaderInfo(event.currentTarget).loader;
			var index:uint = _fontLoaders.indexOf( loader );
			var url:String = _urls[ index ];
			
			var fontDef:String = url.search("/") == -1 ?
				url.slice( 0 , url.lastIndexOf(".") ) : 
				url.slice( url.lastIndexOf("/")+1 , url.lastIndexOf(".") );
			
			_fontLoadedStates[ index ] = true;
			
			if( _fontDefinitions.indexOf(fontDef) == -1 )
				_fontDefinitions.push( fontDef );
					
			var FontClass:Class = loader.contentLoaderInfo.applicationDomain.getDefinition( fontDef ) as Class;
			Font.registerFont(FontClass);
			
			var eventObj:FontManagerEvent = new FontManagerEvent(FontManagerEvent.SINGLE_LOAD_COMPLETE);
			eventObj.fontClass = FontClass;
			this.dispatchEvent( eventObj );
			
			var completeBool:Boolean = true;
			
			for (var i:int = 0; i < _fontLoadedStates.length; i++)
				completeBool &&= _fontLoadedStates[i];
			
			if( completeBool )
			{
				_loadComplete = true;
				var eventObjComplete:FontManagerEvent = new FontManagerEvent(FontManagerEvent.LOAD_COMPLETE);
				this.dispatchEvent( eventObjComplete );
			}
		}
		
		public function get loaded():Boolean
		{
			return _loadComplete;
		}
		
		public function get registeredFonts():Array
		{
			return Font.enumerateFonts();
		}
	}
}