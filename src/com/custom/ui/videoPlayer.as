package com.custom.ui
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import org.osmf.events.LoaderEvent;
	
	public class videoPlayer extends MovieClip
	{
		
		private var loader:Loader = new Loader();
		
		private var _user:String;                                     //Auth user name
		private var _pass:String;                                    //Auth user password
		
		private var _host:String = "192.168.1.10";                                     //host server of stream
		private var _port:int = 80;                                      //port of stream
		private var _file:String= "/img/video.mjpeg";                                    //Location of MJPEG
		private var _start:int = 0;                                 //marker for start of jpg
		
		private var webcamSocket:Socket = new Socket();                //socket connection
		private var imageBuffer:ByteArray = new ByteArray();        //image holder
		
		/**
		 * Create's a new instance of the MJPEG class. Note that due a sandbox security problem, unless you can place a crossdomain.xml
		 * on the host server you will only be able to use this class in your AIR applications.
		 *
		 * @example import MJPEG;
		 *            var cam:MJPEG = new MJPEG("192.168.0.100", "/img/video.mjpeg", 80);
		 *            addChild(cam);
		 *
		 * @param    host:String | Host of the server. Do not include protocol
		 * @param    file:String | Path to the file on the server. Start with a forward slash
		 * @param    port:int    | Port of the host server;
		 * @param    user:String | User name for Auth
		 * @param    pass:String | User password for Auth
		 */
		public function videoPlayer($path:String)
		{
			super();
			_host = $path;
			init();
		}
		
		public function init():void {
			
			webcamSocket.addEventListener(Event.CONNECT, handleConnect);
			webcamSocket.addEventListener(ProgressEvent.SOCKET_DATA, handleData);
			webcamSocket.connect(_host, _port);
			loader.addEventListener(Event.INIT, sucesse);
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event):void {
				trace(event);
			});
			this.addChild(loader);
			loader.scaleX = 1.65; 
			loader.scaleY = 1.5;
//			loader.width = 1024;
//			loader.height = 668;
				
			
			
		}
		
		
		private function sucesse(event:Event):void {
			var t:LoaderInfo = event.currentTarget as LoaderInfo;
//			bitmapImage.source = t.content;
		}
		
		private function handleConnect(e:Event):void {
			// we're connected send a request
			var httpRequest:String = "GET " + _file + " HTTP/1.1\r\n";
			httpRequest += "Host: localhost:80\r\n";
//			if (_user != null && _pass != null) {
//				var source:String = String(_user + ":" + _pass);
//				var auth:String = Base64.encode(source);
//				httpRequest += "Authorization: Basic " + auth.toString() + "\r\n";    //NOTE THIS MAY NEEED TO BE EDITED TO WORK WITH YOUR CAM
//			}
			httpRequest += "Connection: keep-alive\r\n\r\n";
			webcamSocket.writeMultiByte(httpRequest, "us-ascii");
		}
		
		private function handleData(e:ProgressEvent):void {
			//trace("Got Data!" + e);
			// get the data that we received.
			
			// append the data to our imageBuffer
			webcamSocket.readBytes(imageBuffer, imageBuffer.length);
			//trace(imageBuffer.length);
			findImages()
//			while (findImages()) {
//				//donothing
//			}
			
			
		}
		
		
		private function findImages():Boolean {
			
			var x:int = _start;
			var startMarker:ByteArray = new ByteArray();
			var end:int = 0;
			var image:ByteArray;
			
			if (imageBuffer.length > 1) {
				if (_start == 0) {
					//Check for start of JPG
					for (x; x < imageBuffer.length - 1; x++) {
						
						// get the first two bytes.
						imageBuffer.position = x;
						imageBuffer.readBytes(startMarker, 0, 2);
						
						//Check for end of JPG
						if (startMarker[0] == 255 && startMarker[1] == 216) {
							_start = x;
							break;
						}
					}
				}
				for (x; x < imageBuffer.length - 1; x++) {
					// get the first two bytes.
					imageBuffer.position = x;
					imageBuffer.readBytes(startMarker, 0, 2);
					if (startMarker[0] == 255 && startMarker[1] == 217) {
						
						end = x;
						
						image = new ByteArray();
						imageBuffer.position = _start;
						imageBuffer.readBytes(image, 0, end - _start);
						
						displayImage(image);
						
						// truncate the imageBuffer
						var newImageBuffer:ByteArray = new ByteArray();
						
						imageBuffer.position = end;
						imageBuffer.readBytes(newImageBuffer, 0);
						imageBuffer = newImageBuffer;
						
						_start = 0;
						x = 0;
						return true;
					}
				}
			}
			
			return false;
		}
		
		
		private function displayImage(image:ByteArray):void {
			
			loader.loadBytes(image);
			
		}
		
		
		public function set pass(value:String):void {
			_pass = value;
		}
		
		
		public function set port(value:int):void {
			_port = value;
		}
		
		public function set host(value:String):void {
			_host = value;
		}
		
		public function set file(value:String):void {
			_file = value;
		}
	}
}