package utils.assets
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class LibManager extends Loader
	{
		public static var instance:LibManager;
		
		
		public function LibManager( staticStore:Boolean=false, url:String="", context:LoaderContext=null ):void
		{
			super();
			
			if(url)
				load( new URLRequest(url), context );
			
			if(staticStore)
				LibManager.instance = this;
		}
		
		public function get loaded():Boolean 
		{
			return (this.content != null);
		}
		
		public function getInstance(className:String):*
		{
			var SymbolClass:Class = getDefinition(className);
			
			return (SymbolClass) ? new SymbolClass() : null;
		}
		
		public function getDefinition(className:String):Class 
		{
			return loaded ? this.contentLoaderInfo.applicationDomain.getDefinition(className) as Class : null;
		} 
	}
}