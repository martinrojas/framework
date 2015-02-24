package com.custom.external
{	
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	/**
	 * This class is to be used an example of creating an XMLSocket connection and receiving information from
	 * an external source.  A successful connection will receive data from an external source in the form of
	 * an XML object, and that data can be parsed for further use.  Here the host and port names are just examples. 
	 * @author mlewis
	 * 
	 */	
	public class XMLSocketAgent extends EventDispatcher
	{
		private var _smileIndex:Number;
		private var _connection:XMLSocket;
		private var _hostName:String;
		private var _hostPort:uint;
		
		private var _areConnectionListenersConfigured:Boolean;
		
		public function XMLSocketAgent()
		{
			this._areConnectionListenersConfigured = false;
			this._hostName = 'localhost';
			this._hostPort = 4242;
			this._connection = new XMLSocket();
		}
		
		/**
		 * Called when this.engage() is called.  Configures all the appropriate listeners for the xml socket connection.
		 */		
		private function configureListeners():void
		{
			if (!this._areConnectionListenersConfigured) {
				this._connection.addEventListener(DataEvent.DATA, onData);
				this._connection.addEventListener(Event.CLOSE, onClose);
				this._connection.addEventListener(Event.CONNECT, onConnect);
				this._connection.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
				this._connection.addEventListener(ProgressEvent.PROGRESS, onProgress);
				this._connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				this._areConnectionListenersConfigured = true;
			}
		}
		
		/**
		 * Removes all listeners from the xml socket connection.
		 */		
		private function removeListeners():void
		{
			if (this._areConnectionListenersConfigured) {
				this._connection.removeEventListener(DataEvent.DATA, onData);
				this._connection.removeEventListener(Event.CLOSE, onClose);
				this._connection.removeEventListener(Event.CONNECT, onConnect);
				this._connection.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
				this._connection.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				this._connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				this._areConnectionListenersConfigured = false;
			}
		}
		
		/**
		 * A public function that, when called, initiates a connection to an external application through
		 * the specified host and port names.  As well as configures the appropriate listeners to handle the
		 * events dispatch by the XMLSocket connection.
		 */		
		public function engage():void
		{
			this._connection.connect(this._hostName, this._hostPort);
			configureListeners();
		}
		
		/**
		 * Closes the xml socket connection to Fraunhafer facial recognition software. 
		 */		
		public function disengage():void
		{
			this._connection.close();
			removeListeners();
		}
		
		/**
		 * This function handles data received from the external application through the XMLSocket connection.
		 * @param e 
		 */		
		private function onData(e:DataEvent):void
		{
			//Handle data here
			//e.data will return the XML that has been received
		}
		
		private function onClose(e:Event):void
		{ 
			//Handle connection close success here
		}
		
		private function onConnect(e:Event):void
		{
			//Handle connection connect success here
		}
		
		private function onIoError(e:IOErrorEvent):void
		{
			//IOErrorEvent handling
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			//ProgressEvent handling
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			//SecurityErrorEvent handling
		}
	}
}