﻿package com.custom.external{	import flash.events.*;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.xml.*;		public class XmlLoader extends EventDispatcher {				private var xmlData:XML;		private var xmlLoader:URLLoader;				public function XmlLoader():void {			xmlLoader = new URLLoader;					}				/**		 * Called when there is an error loading an xml file		 * @param e		 */				private function ioError(e:IOErrorEvent):void {			//IOErrorEvent handling		}				/**		 * Called when {@link URLLoader xmlLoader} dispatches Event.COMPLETE		 * @param e		 */				private function xmlLoaded(e:Event):void {			xmlData = new XML(e.target.data);			dispatchEvent(new Event(Event.COMPLETE));		}				/**		 * Returns xml file that has been loaded		 * @return xmlData		 */				public function returnXML():XML {			return xmlData;		}				/**		 * Restarts the loading process with the given string value		 * @param xmlURL 		 */				public function loadNewXml(xmlURL:String):void {			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioError);			xmlLoader.load(new URLRequest(xmlURL));		}	}}