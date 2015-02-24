package com.framework.data
{
	import com.framework.events.ApplicationDataEvent;
	import com.framework.ui.IUIState;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class ApplicationData extends EventDispatcher implements IApplicationData
	{	
		private var _currentUIState		:IUIState;
		private var _previousUIState	:IUIState;
		private var _applicationTheme	:String;
		private var _stage				:Stage;
		private var _activeSession		:Boolean;
		private var _xmlFileURLs		:Dictionary;
		private var _timeoutValues		:Dictionary;
		private var _copy				:Dictionary;
		private var _serverIP			:String; 
		private var	_demoMode			:Boolean;
//		private var
		
		public function ApplicationData():void
		{
			super();
			_xmlFileURLs = new Dictionary();
			_timeoutValues = new Dictionary();
			_copy = new Dictionary();
		}

		public function get applicationTheme():String
		{
			return _applicationTheme;
		}
		
		public function set applicationTheme(value:String):void
		{
			_applicationTheme = value;
		}
		
		public function get currentUIState():IUIState
		{
			return _currentUIState;
		}
		
		public function set currentUIState(value:IUIState):void
		{
			if (_currentUIState != null)
			{
				_currentUIState.dispose();
			}
			
			_currentUIState = value;
			
			dispatchEvent(new ApplicationDataEvent(ApplicationDataEvent.DISPOSE));
			
			dispatchEvent(new ApplicationDataEvent(ApplicationDataEvent.CURRENT_UI_STATE_CHANGE));
		}
		
		public function get previousUIState():IUIState
		{
			return _previousUIState;
		}
		
		public function set previousUIState(value:IUIState):void
		{			
			_previousUIState = value;
		}
		
		public function get xmlFileURLs():Dictionary
		{
			return _xmlFileURLs;
		}
		
		public function set xmlFileURLs(value:Dictionary):void
		{
			_xmlFileURLs = value;
		}
		
		public function get activeSession():Boolean
		{
			return _activeSession;
		}
		
		public function set activeSession(value:Boolean):void
		{
			_activeSession = value;
		}
		
		public function get stageReference():Stage
		{
			return _stage;
		}
		
		public function set stageReference(value:Stage):void
		{
			_stage = value;
		}
		
		public function get timeoutValues():Dictionary
		{
			return _timeoutValues;
		}
		
		public function set timeoutValues(value:Dictionary):void
		{
			_timeoutValues = value;
		}
		
		public function get copy():Dictionary
		{
			return _copy;
		}
		
		public function set copy(value:Dictionary):void
		{
			_copy = value;
		}

		public function get serverIP():String
		{
			return _serverIP;
		}

		public function set serverIP(value:String):void
		{
			_serverIP = value;
		}

		public function get demoMode():Boolean
		{
			return _demoMode;
		}

		public function set demoMode(value:Boolean):void
		{
			_demoMode = value;
		}


	}
}