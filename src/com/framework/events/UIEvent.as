package com.framework.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class UIEvent extends Event
	{
		
		public static const DEVICE_STATE_CHANGE:String = "DeviceStateChange";
		public static const TEMP_STATE_CHANGE:String = "TempStateChange";
		
		public var displayObject:DisplayObject;
		public var id:Boolean;
		public var temp:int;

		public function UIEvent(type:String, _id:Boolean = false, _temp:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
//			this.displayObject = _displayObject;
			this.id = _id;
			this.temp = _temp;
		}

		override public function clone():Event
		{
			return new UIEvent(type, this.id, this.temp, bubbles, cancelable);
		}
	}
}