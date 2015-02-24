package com.custom.ui
{
	import com.controllerFramework.control.Controller;
	import com.controllerFramework.events.UIEvent;
	import com.custom.external.WebServiceManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DeviceModal extends MovieClip
	{		
		
		private var _modal:deviceModal;
		private var _webName:String;
		private var toggle:ToggleButton;
		private var _tempTemp:int = 0;
		
		
		public function DeviceModal($type:String = "N/A", $room:String = "N/A", $device:String = "N/A", $state:String = "N/A")
		{
			super();
			
			_modal = new deviceModal();
			this.addChild(_modal);
			
//			setModal("N/A", "N/A", "N/A", "N/A")
			
		}
			
			
		public function setModal($type:String = "N/A", $room:String = "N/A", $device:String = "N/A", $state:String = "N/A", $name:String = "N/A"):void
		{
			_modal.deviceLbl.text = $device.toUpperCase();
			_modal.typeLbl.text = $type.toUpperCase();
			_modal.locationLbl.text = $room.toUpperCase();
			_modal.stattusLbl.text = $state.toUpperCase();
			_webName = $name;
			
			while (_modal.holder.numChildren)
			{
				_modal.holder.removeChildAt(0);
			}
			
			switch($type)
			{
				case "thermostat":
				{
					var slider:TempSlider = new TempSlider(11, 32, Number($state));
					
					_modal.bgNormal.visible = false;
					_modal.bgCamera.visible = false;
					_modal.bgTemp.visible = true;
					_modal.setTempBtn.visible = true;
					
					_modal.deviceLbl.x = 60;
					_modal.deviceLbl.y = 49.55;
					
					_modal.typeLbl.x = 60;
					_modal.typeLbl.y = 759;
					
					_modal.locationLbl.x = 60;
					_modal.locationLbl.y = 793;
					
					_modal.statusTitleLbl.x = 60;
					_modal.statusTitleLbl.y = 868;
					
					_modal.stattusLbl.x = 245;
					_modal.stattusLbl.y = 868;

					_modal.holder.addChild(slider);
					slider.addEventListener(UIEvent.TEMP_STATE_CHANGE, onTempChanged);
					_modal.setTempBtn.addEventListener(MouseEvent.MOUSE_DOWN, onSetTempHandler);
					break;
				}
					
				case "lock":
				{
					toggle = new ToggleButton($state);
					
					_modal.bgNormal.visible = true;
					_modal.bgCamera.visible = false;
					_modal.bgTemp.visible = false;
					_modal.setTempBtn.visible = false;
					
					_modal.deviceLbl.x = 60;
					_modal.deviceLbl.y = 49.55;
					
					_modal.typeLbl.x = 60;
					_modal.typeLbl.y = 394.15;
					
					_modal.locationLbl.x = 60;
					_modal.locationLbl.y = 453.15;
					
					_modal.statusTitleLbl.x = 60;
					_modal.statusTitleLbl.y = 545.95;
					
					_modal.stattusLbl.x = 245;
					_modal.stattusLbl.y = 545.95;

					toggle.setSwitchNames("LOCK", "UNLOCK");

					_modal.holder.addChild(toggle);
					toggle.addEventListener(MouseEvent.MOUSE_DOWN, onLockClicked);
					break;
				}
				case "blinds":
				{
					var blinBtn:blindButton = new blindButton();
					
					_modal.bgNormal.visible = true;
					_modal.bgCamera.visible = false;
					_modal.bgTemp.visible = false;
					_modal.setTempBtn.visible = false;
					
					_modal.deviceLbl.x = 60;
					_modal.deviceLbl.y = 49.55;
					
					_modal.typeLbl.x = 60;
					_modal.typeLbl.y = 394.15;
					
					_modal.locationLbl.x = 60;
					_modal.locationLbl.y = 453.15;
					
					_modal.statusTitleLbl.x = 60;
					_modal.statusTitleLbl.y = 545.95;
					
					_modal.stattusLbl.x = 245;
					_modal.stattusLbl.y = 545.95;
					
					
					_modal.holder.addChild(blinBtn);
					blinBtn.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, onBlindClicked);
					blinBtn.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, onBlindClicked);
					blinBtn.setBtn.addEventListener(MouseEvent.MOUSE_DOWN, onBlindClicked);
					break;
				}
				case "CAMERA":
				{
					
					_modal.bgNormal.visible = false;
					_modal.bgCamera.visible = true;
					_modal.bgTemp.visible = false;
					_modal.setTempBtn.visible = false;
					
					_modal.deviceLbl.x = 60;
					_modal.deviceLbl.y = 49.55;
					
					_modal.typeLbl.x = 60;
					_modal.typeLbl.y = 891;
					
					_modal.locationLbl.x = 60;
					_modal.locationLbl.y = 941;
					
					_modal.statusTitleLbl.x = 60;
					_modal.statusTitleLbl.y = 1025;
					
					_modal.stattusLbl.x = 245;
					_modal.stattusLbl.y = 1025;
					
					_modal.stattusLbl.text = "ONLINE";
					
					Controller.webService.addEventListener(Event.COMPLETE, onCameraComplete);
					Controller.webService.call(WebServiceManager.SECURITY_FEED);
					break;
				}
				default:
				{
					toggle = new ToggleButton($state);
					
					_modal.bgNormal.visible = true;
					_modal.bgCamera.visible = false;
					_modal.bgTemp.visible = false;
					_modal.setTempBtn.visible = false;
					
					_modal.deviceLbl.x = 60;
					_modal.deviceLbl.y = 49.55;
					
					_modal.typeLbl.x = 60;
					_modal.typeLbl.y = 394.15;
					
					_modal.locationLbl.x = 60;
					_modal.locationLbl.y = 453.15;
					
					_modal.statusTitleLbl.x = 60;
					_modal.statusTitleLbl.y = 545.95;
					
					_modal.stattusLbl.x = 245;
					_modal.stattusLbl.y = 545.95;

					toggle.setSwitchNames("ON", "OFF");
					_modal.holder.addChild(toggle);
					toggle.addEventListener(MouseEvent.MOUSE_DOWN, onSwitchClicked);
					break;
				}
			}
		}
		
		
		/********************************************/
		/***            CLICK HANDLERS            ***/
		/********************************************/
		private function onSwitchClicked(e:MouseEvent):void
		{
			var temp:String = toggle.onToggleClick();
			_modal.stattusLbl.text = temp;
			Controller.webService.call(WebServiceManager.ACTIVATE_SWITCH + _webName +"/"+ toggle.State);
			Controller.eventDispatcher.dispatchEvent(new UIEvent(UIEvent.DEVICE_STATE_CHANGE, toggle.State));
		}
		
		private function onLockClicked(e:MouseEvent):void
		{
			var temp:String = toggle.onToggleClick();
			_modal.stattusLbl.text = temp;
			Controller.webService.call(WebServiceManager.ACTIVATE_LOCK + _webName +"/"+ toggle.State);
			Controller.eventDispatcher.dispatchEvent(new UIEvent(UIEvent.DEVICE_STATE_CHANGE, toggle.State));
		}
		
		private function onTempChanged(e:UIEvent):void
		{
			_tempTemp = e.temp;
		}
		
		private function onSetTempHandler($evt:MouseEvent):void
		{
			
			_modal.stattusLbl.text = _tempTemp.toString();
			Controller.webService.call(WebServiceManager.SET_TEMPERATURE + _webName +"/"+ _tempTemp.toString());
			Controller.eventDispatcher.dispatchEvent(new UIEvent(UIEvent.DEVICE_STATE_CHANGE, toggle.State, _tempTemp));
		}

		private function onBlindClicked(e:MouseEvent):void
		{
			
			switch(e.currentTarget.name)
			{
				case "setBtn":
				{
					Controller.webService.call(WebServiceManager.ACTIVATE_BLINDS + _webName + "/Stop");
					break;
				}
					
				case "upBtn":
				{
					Controller.webService.call(WebServiceManager.ACTIVATE_BLINDS + _webName + "/Open");
					break;
				}
					
				case "downBtn":
				{
					Controller.webService.call(WebServiceManager.ACTIVATE_BLINDS + _webName + "/Close")	;
					break;
				}
			}
			
			
//			_modal.stattusLbl.text = temp;
//			Controller.webService.call(WebServiceManager.ACTIVATE_SWITCH + _webName +"/"+ toggle.State);
//			Controller.eventDispatcher.dispatchEvent(new UIEvent(UIEvent.DEVICE_STATE_CHANGE, toggle.State));
		}
	
		/********************************************/
		/***               WEB SERVICES           ***/
		/********************************************/
		private function onCameraComplete($evt:Event):void
		{
			Controller.webService.removeEventListener(Event.COMPLETE, onCameraComplete);
			Controller.logger.log(this + " Call Completed");
			
			var video:videoPlayer = new videoPlayer($evt.currentTarget.data);
			
			_modal.holder.addChild(video);
			
			
		}
	}
}