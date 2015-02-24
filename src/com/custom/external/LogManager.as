package com.custom.external
{
	import com.adobe.air.logging.FileTarget;
	import com.controllerFramework.control.Controller;
	import com.controllerFramework.data.IApplicationData;
	
	import flash.filesystem.File;
	import flash.utils.getDefinitionByName;
	
	import mx.controls.FileSystemList;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;

	public class LogManager
	{
		/***	constants	***/
		public static const LOCAL_LOG_DIR:String =  "/LCKioskConfiguration/logs/";
		public static const LOG_BASE_FILENAME:String =  "_MSKioskUI.txt";
		public static const TERMINAL_LOGGING_ON:String = "terminalLoggingOn";
		public static const FILE_LOGGING_ON:String = "fileLoggingOn";
		public static const HEALTH_STATUS_LOGGING_ON:String = "healthStatusLoggingOn";
		public static const LOGGING_DEBUG_ON:String = "loggingDebugOn";
		public static const LOGGING_INFO_ON:String = "loggingInfoOn";
		public static const LOGGING_ERROR_ON:String = "loggingErrorOn";
		public static const LOGGING_LOW_LEVEL_ON:String = "loggingLowLevelOn";
		public static const TRUE:String = "true";
		public static const FALSE:String = "false";
		public static const INFO:String = "info";
		public static const ERROR:String = "error";
		public static const DEBUG:String = "debug";
		public static const LOW_LEVEL:String = "lowLevel";
		public static const ALL:String = "all";
		public static const TTL:Number = 30; // time to live in days
		
		/***	private state vars	***/
		private var _terminalLoggingEnabled:Boolean;
		private var _fileLoggingEnabled:Boolean;
		private var _healthStatusLoggingEnabled:Boolean;
		private var _loggingDebugEnabled:Boolean;
		private var _loggingInfoEnabled:Boolean;
		private var _loggingErrorEnabled:Boolean;
		private var _loggingLowLevelEnabled:Boolean;
		
		/***	private vars	***/
		private var _logger:ILogger;
		private var _logFile:FileTarget;
		private var _logTrace:TraceTarget;
		private var _currentLogType:String;
		private var _logTypes:Array;
		
		public function LogManager()
		{
		}
		
		public function init(appData:IApplicationData):void
		{
			_terminalLoggingEnabled = (appData.logValues[TERMINAL_LOGGING_ON] == TRUE ? true : false);
			_fileLoggingEnabled = (appData.logValues[FILE_LOGGING_ON] == TRUE ? true : false);
			_healthStatusLoggingEnabled = (appData.logValues[HEALTH_STATUS_LOGGING_ON] == TRUE ? true : false);
			_loggingDebugEnabled = (appData.logValues[LOGGING_DEBUG_ON] == TRUE ? true : false);
			_loggingInfoEnabled = (appData.logValues[LOGGING_INFO_ON] == TRUE ? true : false);
			_loggingErrorEnabled = (appData.logValues[LOGGING_ERROR_ON] == TRUE ? true : false);
			_loggingLowLevelEnabled = (appData.logValues[LOGGING_LOW_LEVEL_ON] == TRUE ? true : false);
			initLogger();
		}
		
		private function initLogger():void
		{
			/***	create log type array		***/
			_logTypes = new Array();
			(_loggingDebugEnabled ? _logTypes.push(DEBUG) : "");
			(_loggingInfoEnabled ? _logTypes.push(INFO) : "");
			(_loggingErrorEnabled ? _logTypes.push(ERROR) : "");
			(_loggingLowLevelEnabled ? _logTypes.push(LOW_LEVEL) : "");
			
			/***	determine whether we should save to file or perform standard traces		***/
			if (_fileLoggingEnabled)
			{
				/***	create timestamp and file		***/
				var date:Date = new Date();
				var dateStr:String = date.getUTCDate() + "_" + Number(date.getUTCMonth()+1) + "_" + date.getFullYear() + "-" + date.getHours() + "." + date.getMinutes();
				var filePath:String = File.documentsDirectory.nativePath + LOCAL_LOG_DIR + dateStr + LOG_BASE_FILENAME;
				var file:File = new File(filePath);
				
				/***	set log file options		***/
				_logFile = new FileTarget(file);
				_logFile.includeDate = true;
				_logFile.includeTime = true;
				_logFile.includeCategory = true;
				_logFile.includeLevel = true; 

				Log.addTarget(_logFile);
			}
			else
			{
				/***	create standard trace logger	***/
				_logTrace = new TraceTarget();
				_logTrace.includeDate = true;
				_logTrace.includeTime = true;
				_logTrace.includeCategory = true;
				_logTrace.includeLevel = true; 
				
				Log.addTarget(_logTrace);
			}
			
			cleanUpLogDirectory();
		}
		
		public function cleanUpLogDirectory():void
		{
			var today:Number = new Date().time*(.0000001157); // convert to days
			var filePath:String = File.documentsDirectory.nativePath + LOCAL_LOG_DIR;
			var file:File = new File(filePath);
			
			if (file.exists)
			{
				var files:Array = file.getDirectoryListing();
				
				for (var i:uint = 0; i < files.length; i++)
				{
					var fileDate:Number = File(files[i]).creationDate.getTime()*(.0000001157); // convert to days
					var diff:Number = today-fileDate;
	
					if (today-fileDate > TTL && files[i].name.indexOf(LOG_BASE_FILENAME) > 0)
					{
						try
						{
							File(files[i]).deleteFile();
						}
						catch (e:Error)
						{
							trace("Error (" + e + ") deleting file: " + files[i].name);
						}
					}
				}
			}
		}
		
		public function log(referenceClass:*, message:String = ""):void
		{
			_currentLogType = INFO.toUpperCase();
			createLog(referenceClass,message,INFO);
		}
		
		public function error(referenceClass:*, error:String = ""):void
		{
			_currentLogType = ERROR.toUpperCase();
			createLog(referenceClass,error,ERROR);			
		}
		
		public function debug(referenceClass:*, message:String = ""):void
		{
			_currentLogType = DEBUG.toUpperCase();
			createLog(referenceClass,message,DEBUG);
		}
		
		public function low(referenceClass:*, message:String = ""):void
		{
			_currentLogType = LOW_LEVEL.toUpperCase();
			createLog(referenceClass,message,LOW_LEVEL);
		}
		
		private function createLog(referenceClass:*, message:String = "", type:String = INFO):void
		{
			if (_logTypes && _logTypes.indexOf(type) >= 0 && referenceClass)
			{
				try
				{
					
					var classAsString:String = convertClassToString(referenceClass);
					_logger = Log.getLogger(classAsString);
					
					if (type == INFO)
					{
						_logger.info(message);
					}
					else if (type == ERROR)
					{
						_logger.error(message);
					}
					else if (type == LOW_LEVEL)
					{
						_logger.debug(message);
					}
					else
					{
						_logger.debug(message);
					}
					
					if (_terminalLoggingEnabled)
					{
						logToTerminal(classAsString, message);
					}
					
					if (_healthStatusLoggingEnabled)
					{
						logToHealthStatus(classAsString, message);
					}
					
				}
				catch (e:Error)
				{
					trace("Error logging message - " + e);
				}	
			}
		}
		
		
		private function logToTerminal(className:String, message:String = ""):void
		{
			try
			{
				Controller.logger.log("["+ _currentLogType + "] " + className + ": " + message);
			}
			catch (e:Error)
			{
				trace("Error ("+ e +") logging to terminal logger");
			}
		}
		
		private function logToHealthStatus(className:String, message:String = ""):void
		{
			try
			{
				Controller.healthStatusReporter.log("["+ _currentLogType + "] " + className + ": " + message);
			}
			catch (e:Error)
			{
				trace("Error ("+ e +") logging to health status logger");
			}
		}
		
		private function convertClassToString(classRef:*):String
		{
			try 
			{
				var input:String = classRef.toString();
				var returnStr:String = input.replace("[object ","");
				returnStr = returnStr.replace("]","");
				return returnStr;
			}
			catch (e:Error)
			{
				return "error";
			}
			
			return "error";
		}
	}
}
