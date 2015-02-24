package com.custom.ui
{
	import com.controllerFramework.control.Controller;
	import com.controllerFramework.events.UIEvent;
	import com.custom.external.WebServiceManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DeviceButton extends MovieClip
	{
		//- PRIVATE & PROTECTED VARIABLES -------------------------------------------------------------------------
		
		private var _deviceButton:deviceButton;
//		private var _modal:DeviceModal;
		private var _type:String;
		private var _deviceName:String;
		
		//- PUBLIC VARIABLES ---------------------------------------------------------------------------
		
		public static const TEMP:String = "thermostat";
		public static const PLUG:String = "PLUG";
		public static const LOCK:String = "lock";
		public static const CAMERA:String = "CAMERA";
		public static const BULB:String = "switch";
		public static const DIMMER:String = "DimmerSwitch";
		
		public function DeviceButton($type:String = CAMERA, $room:String = "N/A", $device:String = "N/A", $state:Boolean = false, $webName:String = "N/A", $category:String = "0")
		{
			super();			
			_deviceButton = new deviceButton();
			_type = $type;
			if($type == BULB) 
			{
				(($category == "0") ? _type = PLUG : _type = $type);
			}
			setType();
			_deviceButton.roomName.text	= $room;
			_deviceButton.device.text = $device;
			setState($state);
			_deviceName = $webName;
			
			
			
			this.addChild(_deviceButton);
		}
		
		public function setType():void
		{
			switch(_type)
			{
				case TEMP:
				{
					_deviceButton.temp.visible = true;
					_deviceButton.plug.visible = false;
					_deviceButton.lock.visible = false;
					_deviceButton.camera.visible = false;
					_deviceButton.bulb.visible = false;
					break;
				}
					
				case LOCK:
				{
					_deviceButton.temp.visible = false;
					_deviceButton.plug.visible = false;
					_deviceButton.lock.visible = true;
					_deviceButton.camera.visible = false;
					_deviceButton.bulb.visible = false;
					break;
				}
				case CAMERA:
				{
					_deviceButton.temp.visible = false;
					_deviceButton.plug.visible = false;
					_deviceButton.lock.visible = false;
					_deviceButton.camera.visible = true;
					_deviceButton.bulb.visible = false;
					
					break;
				}
				case BULB:
				{
					_deviceButton.temp.visible = false;
					_deviceButton.plug.visible = false;
					_deviceButton.lock.visible = false;
					_deviceButton.camera.visible = false;
					_deviceButton.bulb.visible = true;
					break;
				}
				case DIMMER:
				{
					_deviceButton.temp.visible = false;
					_deviceButton.plug.visible = false;
					_deviceButton.lock.visible = false;
					_deviceButton.camera.visible = false;
					_deviceButton.bulb.visible = true;
					break;
				}
				default:
				{
					
					_deviceButton.temp.visible = false;
					_deviceButton.plug.visible = true;
					_deviceButton.lock.visible = false;
					_deviceButton.camera.visible = false;
					_deviceButton.bulb.visible = false;
					break;
				}
			}
		}
		
		public function setState($bool:Boolean):void
		{
			if (_type == LOCK)
			{
				if ($bool)
				{
					_deviceButton.state.text = "LOCK";
				}
				else
				{
					_deviceButton.state.text = "UNLOCK";
				}
			}
			else 
			{
				if ($bool)
				{
					_deviceButton.state.text = "ON";
				}
				else
				{
					_deviceButton.state.text = "OFF";
				}
			}
		}
		
		public function setTemp($num:String):void
		{
			_deviceButton.state.text = $num;
		}
		
		public function addListener():void
		{
			Controller.eventDispatcher.addEventListener(UIEvent.DEVICE_STATE_CHANGE, onStateChange);
		}
		
		public function removeListener():void
		{
			if (Controller.eventDispatcher.hasEventListener(UIEvent.DEVICE_STATE_CHANGE))
				{
					Controller.eventDispatcher.removeEventListener(UIEvent.DEVICE_STATE_CHANGE, onStateChange);
				}
		}
		
		private function onStateChange ($evt:UIEvent):void
		{
			if ($evt.temp != 0)
			{
				setTemp($evt.temp.toString());
			}
			else
			{
				setState($evt.id);
			}
			
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get device():deviceButton
		{
			return _deviceButton;
		}

		public function set device(value:deviceButton):void
		{
			_deviceButton = value;
		}

		public function get deviceName():String
		{
			return _deviceName;
		}

		public function set deviceName(value:String):void
		{
			_deviceName = value;
		}
		
		
		
	}
}