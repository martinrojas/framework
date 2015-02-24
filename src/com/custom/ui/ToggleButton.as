package com.custom.ui
{
	import com.controllerFramework.control.Controller;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	
	public class ToggleButton extends MovieClip
	{
		private var _state:Boolean;
		protected var _toggleButton:toggleButton;
		
		private static const ON_POSITION:int = 344.95;
		private static const OFF_POSITION:int = 124;
		
		public function ToggleButton(initialState:String = "ON")
		{
			super();
			_toggleButton = new toggleButton();
			if (initialState == "ON" || initialState == "LOCK")
			{
				_state = true;
				TweenLite.to(_toggleButton.Switch, 0.5, {x:ON_POSITION});
			}
			else
			{
				_state = false;
				TweenLite.to(_toggleButton.Switch, 0.5, {x:OFF_POSITION});
			}
			this.addChild(_toggleButton);
//			this.addEventListener(MouseEvent.MOUSE_DOWN, onToggleClick);
			
		}
		
		/********************************************/
		/***         EVENT LISTENERS              ***/
		/********************************************/	
		
		public function onToggleClick():String
		{
			_state = !_state;
			if(_state){
				TweenLite.to(_toggleButton.Switch, 0.5, {x:ON_POSITION});
				return _toggleButton.Switch.onState.text;
			}else{
				TweenLite.to(_toggleButton.Switch, 0.5, {x:OFF_POSITION});
				return _toggleButton.Switch.offState.text;
			} 
			
		}
		
		
		/********************************************/
		/***         SETTERS / GETTERS            ***/
		/********************************************/	
		public function get State():Boolean
		{
			return _state;
		}

		public function set State(value:Boolean):void
		{
			_state = value;
		}
		
		public function setSwitchNames($on:String = "ON", $off:String = "OFF"):void
		{
			_toggleButton.Switch.onState.text = $on;
			_toggleButton.Switch.offState.text = $off;
		}
	}
}