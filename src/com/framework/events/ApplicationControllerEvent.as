package com.framework.events
{
	import flash.events.Event;
	
	public class ApplicationControllerEvent extends Event
	{
		public static const LOAD_USER_DATA:String = "loadUserData";
		public static const LOAD_COPY_DATA:String = "loadCopyData";

		public static const STARTUP:String = "startup";
		
		public static const SET_PREVIOUS_VIEW_STATE:String = "setPreviousViewState";
		public static const SET_IDLE_VIEW_STATE:String = "setIdleViewState";
		public static const SET_SLIDE_VIEW_STATE:String = "setSlideViewState";

		
		public static const DISPOSE:String = "dispose";
		public static const HEALTH_STATUS_LOGGER:String = "healthStatusLogger";

		public var id:String;
		
		public function ApplicationControllerEvent(type:String, _id:String = "", bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.id = _id;
		}

		override public function clone():Event
		{
			return new ApplicationControllerEvent(type, this.id, bubbles, cancelable);
		}
	}
}