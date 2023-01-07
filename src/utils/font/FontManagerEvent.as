package utils.font
{
	import flash.events.Event;
	
	public class FontManagerEvent extends Event
	{
		public static const SINGLE_LOAD_COMPLETE:String = "FontManagerEvent::singleLoadComplete";
		public static const LOAD_COMPLETE:String = "FontManagerEvent::loadComplete";
		
		public var fontClass:Class;
		
		public function FontManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var eventObj:FontManagerEvent = new FontManagerEvent(type, bubbles, cancelable);
			eventObj.fontClass = fontClass;
			return eventObj;
		}
	}
}