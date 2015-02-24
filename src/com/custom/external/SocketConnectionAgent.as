package com.custom.external
{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class SocketConnectionAgent
	{
		private var _dataSender:Socket;
		private var _dataPort:uint;
		private var _hostName:String;
		
		public function SocketConnectionAgent(dataPort:Number, hostName:String)
		{
			this._dataPort = dataPort;
			this._hostName = hostName;
			this._dataSender = new Socket();
		}
		
		public function writeObject(data:Object):void
		{
			this._dataSender.writeObject(data);
			this._dataSender.flush();
		}
		
		private function configureDataListeners():void {
			this._dataSender.addEventListener(Event.CLOSE, onDataClose);
			this._dataSender.addEventListener(Event.CONNECT, onDataConnect);
			this._dataSender.addEventListener(IOErrorEvent.IO_ERROR, onDataIoError);
			this._dataSender.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onDataSecurityError);
			this._dataSender.addEventListener(ProgressEvent.SOCKET_DATA, onProgressEvent);
		}
		
		private function removeDataListeners():void {
			this._dataSender.removeEventListener(Event.CLOSE, onDataClose);
			this._dataSender.removeEventListener(Event.CONNECT, onDataConnect);
			this._dataSender.removeEventListener(IOErrorEvent.IO_ERROR, onDataIoError);
			this._dataSender.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onDataSecurityError);
			this._dataSender.removeEventListener(ProgressEvent.SOCKET_DATA, onProgressEvent);
		}
		
		private function onDataClose(e:Event):void
		{
			this.removeDataListeners();
		}
		
		private function onDataConnect(e:Event):void
		{
			//Connection handling
		}
		
		private function onDataIoError(e:IOErrorEvent):void
		{
			//IOErrorEvent Handling
		}
		
		private function onDataSecurityError(e:SecurityErrorEvent):void
		{
			//SecurityErrorEvent Handling
		}
		
		private function onProgressEvent(e:ProgressEvent):void
		{
			//ProgressEvent Handling
		}
	}
}