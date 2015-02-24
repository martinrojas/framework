package com.framework.events
{
	import flash.events.Event;
	
	public class ApplicationDataEvent extends Event
	{
		public static const CONFIG_DATA_CHANGE:String = "configDataChange";
		public static const CURRENT_USER_CHANGE:String = "currentUserChange";
		public static const CURRENT_UI_STATE_CHANGE:String = "currentUIStateChange";
		public static const COPY_DATA_LOADED:String = "copyDataLoaded";
		public static const SET_APPLICATION_TIMEOUTS:String = "setApplicationTimeout";
		public static const DISPOSE:String = "dispose";
		
		public function ApplicationDataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new ApplicationDataEvent(type, bubbles, cancelable);
		}
	}
}