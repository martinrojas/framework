package com.custom.external
{
	import com.adobe.crypto.MD5;
	import com.adobe.serialization.json.*;
	import com.framework.control.ApplicationController;
	import com.framework.control.Controller;
	import com.framework.data.ApplicationData;
	import com.framework.data.IApplicationData;
	import com.framework.events.ApplicationControllerEvent;
	import com.framework.events.ApplicationDataEvent;
	import com.framework.events.UIEvent;
	
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	import flash.utils.Dictionary;
	import flash.xml.XMLDocument;
	
	/**
	 * WebServiceManager - Processes web service _requests and returns JSON decoded data 
	 * @author cmilon
	 * 
	 */	
	public class WebServiceManager extends EventDispatcher
	{
		private static const GET:String = "GET";
		private static const POST:String = "POST";
		
		
		/***	service consts		***/
		
		public static const SECURITY_FEED:String 		= "/GetSecurityCameraUri";
		public static const RECENT_ACTIVITY:String 		= "/GetRecentActivity";
		public static const STATUS_LIST:String 			= "/GetStatusList";
		public static const ACTIVATE_PROGRAM:String		= "/ActivateProgram/";
		public static const SET_TEMPERATURE:String		= "/SetTemperature/";
		public static const ACTIVATE_SWITCH:String		= "/ActivateSwitch/";
		public static const ACTIVATE_BLINDS:String 		= "/SetBlinds/";
		public static const ACTIVATE_LOCK:String		= "/ActivateLock/";
		
		
		/***	order consts	***/
		private var _serviceIP:String = "192.168.1.16:9998"
		private var _serviceURL:String = "/DeviceService";
		private var _request:URLRequest;
		private var _loader:URLLoader;
		private var _xmlLoader:XmlLoader;
		private var _appData:IApplicationData;
		
		private var _data:Object;
		
		public function WebServiceManager():void 
		{
			super();
		}
		
		/**
		 * creates new web service dictionary if it does not exist already 
		 * 
		 */
		public function init(appData:IApplicationData):void
		{
			try{
				Controller.logger.log("Enter function init()");
				_appData = appData;
				_serviceIP = _appData.serverIP;
				
			}
			catch(e:Error)
			{
				Controller.logger.log( "Error in function init():" + e.errorID + "|" + e.message);
			}
		}
		
		
		
		
		/**
		 * initiates new web service _request
		 * @param method - HTTP _request method, defaults to "GET"
		 * 
		 */		
		public function call($service:String = STATUS_LIST):void
		{
			try
			{
				Controller.logger.log(this + " " + $service);
				data = null;
				
				_request = new URLRequest("http://" + _serviceIP + _serviceURL + $service);
				_request.method = URLRequestMethod.GET;
				_request.idleTimeout = 5000;
				
				_loader = new URLLoader();
				
				(!_loader.hasEventListener(Event.COMPLETE) ? _loader.addEventListener(Event.COMPLETE, _requestLoaded) : "");
				(!_loader.hasEventListener(IOErrorEvent.IO_ERROR) ? _loader.addEventListener(IOErrorEvent.IO_ERROR, _requestFailed) : "");
				(!_loader.hasEventListener(ProgressEvent.PROGRESS) ? _loader.addEventListener(ProgressEvent.PROGRESS, onProgressEvent) : "");
				(!_loader.hasEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS) ? _loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHTTPresponse) : "");
				
				_loader.load(_request);
			}
			catch(e:Error)
			{
				Controller.logger.log("Error making webservice call - " + e);
			}
		}
		
		private function onProgressEvent(e:ProgressEvent):void
		{
			Controller.logger.log(" onProgressEvent => " + e.toString());
		}
		
		private function onHTTPresponse(e:HTTPStatusEvent):void
		{
			try
			{
				
				_loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHTTPresponse);
				Controller.logger.log( "HTTP Response received");
			}
			catch(e:Error)
			{
				Controller.logger.log( "Error retrieving HTTP response - " + e);
			}
		}
		
		/**
		 * web service has responded, this data needs to be decoded as a JSON object 
		 * @param e
		 * 
		 */		
		private function _requestLoaded(e:Event):void
		{
			try
			{
				_loader.removeEventListener(ProgressEvent.PROGRESS, onProgressEvent);
				if (e.target.data)
				{
					Controller.logger.log( "Response contains data, attempting to parse");
					
					
					try
					{
						data = com.adobe.serialization.json.JSON.decode(e.target.data);
						Controller.logger.log( "Successfully decoded response data");
					}
					catch (e:Error)
					{
//						errorCode = "Error parsing webservice";
					}
					
					if (data && data.hasOwnProperty("errorCode"))
					{
//						errorCode = data.errorCode;
//						Controller.logManager.debug(this, "Webservice has responded with an error code - " + data.errorCode);
					}
					else
					{
//						if (_cacheTTLtimes[_service] > 0)
//						{
//							if (_service == GET_PRODUCT_FOR_CATEGORY && !data.hasOwnProperty("productCount"))
//							{
//								// don't store empty data
//							}
//							else
//							{
//								var key:String = MD5.hash(_serviceURL);
//								var cachedRequest:WebServiceRequest = new WebServiceRequest(_serviceURL, _cacheTTLtimes[_service], data, errorCode);
//								_cachedRequests[key] = cachedRequest;
//								_cacheRequestAmount++;
//							}
//						}
					}
					this.dispatchEvent(e);
				}
				_loader.removeEventListener(Event.COMPLETE, _requestLoaded);
				Controller.logger.log( "Webservice request has finished loaded");
			}
			catch(e:Error)
			{
				Controller.logger.log("Error loading webservice request - " + e);
			}
		}
		
		
		/**
		 * web service _request failed 
		 * @param e
		 * 
		 */		
		private function _requestFailed(e:Event):void
		{
			_loader.removeEventListener(ProgressEvent.PROGRESS, onProgressEvent);
			Controller.logger.log( "Webservice request has failed - " + e);
			this.dispatchEvent(e);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, _requestFailed);
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

	}
}