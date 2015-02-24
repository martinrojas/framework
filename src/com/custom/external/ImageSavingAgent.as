package com.custom.external
{
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	/**
	 *This class was created to communicate with  custom Java application, in order to
	 * write images to disk via a socket connection between Flash and  custom external application 
	 * @author mlewis
	 * 
	 */	
	public class ImageSavingAgent
	{
		private var _dataSender:Socket;
		private var _dataPort:uint;
		private var _hostName:String;
		private var _imageByteArray:ByteArray;
		private var _encoder:JPGEncoder;
		
		public function ImageSavingAgent()
		{
			this._dataPort = 4444;
			this._hostName = 'localhost';
			this._dataSender = new Socket();
			this._encoder = new JPGEncoder(100);
		}
		
		/**
		 * Configures the socket connection listeners to the Java image saving utility and sends current image data in a ByteArray.
		 * @param data 
		 */		
		public function saveImage(data:BitmapData):void
		{
			this.configureDataListeners();
			var imageData:BitmapData = data;
			this._imageByteArray = this._encoder.encode(imageData);
			this._dataSender.connect(this._hostName, this._dataPort);
		}
		
		/**
		 * Called when this.onSaveImage() is called.  Configures all appropriate listeners for the socket connection to
		 * the Java image saving utility. 
		 */		
		private function configureDataListeners():void {
			this._dataSender.addEventListener(Event.CLOSE, onDataClose);
			this._dataSender.addEventListener(Event.CONNECT, onDataConnect);
			this._dataSender.addEventListener(IOErrorEvent.IO_ERROR, onDataIoError);
			this._dataSender.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onDataSecurityError);
		}
		
		/**
		 * Removes all listeners from the socket connection to Java image saving utility.
		 */		
		private function removeDataListeners():void {
			this._dataSender.removeEventListener(Event.CLOSE, onDataClose);
			this._dataSender.removeEventListener(Event.CONNECT, onDataConnect);
			this._dataSender.removeEventListener(IOErrorEvent.IO_ERROR, onDataIoError);
			this._dataSender.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onDataSecurityError);
			
		}
		
		/**
		 * This function removes all listeners from the Socket connection after all image data
		 * has been sent to the external Java application 
		 * @param e
		 * 
		 */		
		private function onDataClose(e:Event):void
		{
			this.removeDataListeners();
		}
		
		/**
		 * Called when the image saving socket connection dispatches Event.CONNECT. Immediately sends ByteArray containing BitmapData for the
		 * current image, flushes data out of the socket connection, and close it. 
		 * @param e 
		 */		
		private function onDataConnect(e:Event):void
		{
			this._dataSender.writeBytes(this._imageByteArray, 0, this._imageByteArray.length);
			this._dataSender.flush();
			this._dataSender.close();
		}
		
		private function onDataIoError(e:IOErrorEvent):void
		{
			//IOErrorEvent Handling
		}
		
		private function onDataSecurityError(e:SecurityErrorEvent):void
		{
			//SecurityErrorEvent Handling
		}
	}
}