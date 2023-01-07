package
{
	import components.app.Application;
	
	import field.electric.ElectricField;
	
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Vector3D;
	import components.menus.SideMenu;
	
	import utils.assets.LibManager;
	import utils.font.FontManager;
	import utils.font.FontManagerEvent;
	
	public class Electrostatics extends Application
	{
		private var electricField:ElectricField;
		private var panel:SideMenu;
		
		public function Electrostatics()
		{
			super();
			backgroundColor = 0x0D0D0D;
			
			var fontsUrls:Array = [ 
				"assets/Arial.swf", 
				"assets/ArialBold.swf",
				"assets/HelveticaNeueUltraLight.swf", 
				"assets/HelveticaNeueLight.swf"
			];
			
			var fontManager:FontManager = new FontManager( true, fontsUrls );
			var libManager:LibManager = new LibManager( true, "assets/lib.swf" );
						
			FontManager.instance.addEventListener( FontManagerEvent.LOAD_COMPLETE, fontsLoaded );
			LibManager.instance.contentLoaderInfo.addEventListener( Event.COMPLETE, libLoaded );
		}
		
		override protected function preInitialize(event:Event):void
		{
			super.preInitialize(event);
			
			this.filters = [new BlurFilter(5,5,BitmapFilterQuality.HIGH)];
			statusBar.filters = this.filters;
		}
		
		protected function libLoaded(event:Event):void
		{
			if( FontManager.instance.loaded )
				init();
		}
		
		protected function fontsLoaded(event:Event):void
		{
			trace( FontManager.instance.fontDefinitions )
			
			if( LibManager.instance.loaded )
				init();
		}
		
		protected function init():void
		{			
			this.filters = null;
			statusBar.filters = null;
			
			statusBar.leftLabel = " ";
			statusBar.rightLabel = " ";
			statusBar.addEventListener( Event.ENTER_FRAME, onMove);
			
			electricField = new ElectricField();
			addChild( electricField );
			
			panel = new SideMenu();
			addChild( panel );
			
			for (var i:int = 0; i < 50; i++) 
			{
				electricField.createCharge( -2E-10, 200+8*i, 300);
				electricField.createCharge( +2E-10, 200+8*i, 400);
			}
			
			electricField.createCharge( -2E-10, 800, 350);
		}
		
		protected function onMove(event:Event):void
		{
			var efield:Vector3D = electricField.getFieldAt( mouseX, mouseY );
			statusBar.leftLabel = "Electric Field ( x= " + efield.x.toFixed(2) + ", y= " + (-efield.y).toFixed(2) + " )";		
		}
		
		override protected function onResize(event:Event):void
		{
			super.onResize(event);
		}
	}
}