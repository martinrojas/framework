package com.custom.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.errors.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.URLRequest;

	public class BitmapObj extends MovieClip {
		
		private var imgLoader:Loader;
		private var imgBitmap:Bitmap;
		private var objID:String;
		private var objX:Number;
		private var objY:Number;
		
		public function BitmapObj(_assetURL:String, _objName:String="", _objX:Number=0, _objY:Number=0):void 
		{
			super();
			imgLoader = new Loader();
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, displayObj);
			
			objID = _objName; 
			objX = _objX;
			objY = _objY;

			imgLoader.load(new URLRequest(_assetURL));
		}
		
		/**
		 * Called when {@link Loader imgLoader} dispatches Event.COMPLETE.  Creates a new Bitmap() with Loader data.
		 * @param e 
		 */		
		private function displayObj(e:Event):void 
		{
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, displayObj);
			imgBitmap = Bitmap(imgLoader.content);
			imgLoader.unload();
			imgBitmap.x = objX;
			imgBitmap.y = objY;
			addChild(imgBitmap);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get id():String {
			return objID;
		}
		
		public function get imageData():BitmapData {
			return imgBitmap.bitmapData;
		}
	}
}