package com.framework.control
{
	import com.framework.services.LogTerminal;
	import com.custom.HealthStatusReporter;
	import com.custom.external.WebServiceManager;
	import com.custom.external.XmlLoader;
	
	import flash.events.EventDispatcher;

	/**
	 *  Contains static variables <code>_eventDispatcher, _logger</code>
	 *  
	 * @see EventDispatcher
	 * @see LogTerminal
	 */	
	public class Controller
	{
		private static var _eventDispatcher:EventDispatcher;
		
		private static var _xmlLoader:XmlLoader;
		
		private static var _logger:LogTerminal;
		
		private static var _healthStatusReporter:HealthStatusReporter;
		
		private static var _webService:WebServiceManager;
        
        public static function get eventDispatcher():EventDispatcher
        {
            if (!_eventDispatcher)
            {
                _eventDispatcher = new EventDispatcher();
            }
            
            return _eventDispatcher;
        }
        
		public static function get logger():LogTerminal
		{
			if(!_logger)
        	{
        		_logger = new LogTerminal();
        	}
        	return _logger;
		}
		
		
		public static function get xmlLoader():XmlLoader
		{
			if(!_xmlLoader)
			{
				_xmlLoader = new XmlLoader();
			}
			return _xmlLoader;
		}

		public static function get webService():WebServiceManager
		{
			if(!_webService)
			{
				_webService = new WebServiceManager();
			}
			return _webService;
		}

		public static function set webService(value:WebServiceManager):void
		{
			_webService = value;
		}

	}
}