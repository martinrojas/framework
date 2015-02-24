package com.custom
{
	import com.framework.control.Controller;
	import com.framework.events.ApplicationControllerEvent;

	public class HealthStatusReporter
	{
		private var _currentDate:Date;
		private var _loggingStatement:String;
		
		
		/**
		 * NetKey logger. This will recieved log statement, append timesptamp, and send tthrough socket connection
		 * 
		 */
		public function HealthStatusReporter()
		{
			_currentDate = new Date();
			
		}
		
		public function log(str:String, logger:Boolean = false):void
		{
			_currentDate = new Date();
			_loggingStatement = '<log timestamp="'+ _currentDate +'">'+ str + '</log>';
			
			if (logger) Controller.logger.log(str);
			Controller.eventDispatcher.dispatchEvent(new ApplicationControllerEvent(ApplicationControllerEvent.HEALTH_STATUS_LOGGER, _loggingStatement));
			
		}
		
	}
}