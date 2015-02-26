package com.framework.commands
{
	import com.framework.commands.AbstractCommand;
	import com.framework.commands.ICommand;
	import com.framework.control.Controller;
	import com.framework.data.IApplicationData;
	import com.framework.events.ApplicationControllerEvent;
	import com.framework.events.ApplicationDataEvent;
	import com.custom.external.XmlLoader;
	
	import flash.events.*;
	
	public class LoadCopyDataCommand extends AbstractCommand implements ICommand
	{
		private var _xmlLoader:XmlLoader;
		
		public function LoadCopyDataCommand(applicationData:IApplicationData)
		{
			super(applicationData); 
		}
		
		public function execute(event:ApplicationControllerEvent):void
		{   
			_xmlLoader = new XmlLoader();
			_xmlLoader.loadNewXml(event.id);
			_xmlLoader.addEventListener(Event.COMPLETE, onXmlLoaderComplete);
		}
		
		private function onXmlLoaderComplete(e:Event):void 
		{
			_xmlLoader.removeEventListener(Event.COMPLETE, onXmlLoaderComplete);
			
			var copyXml:XML = _xmlLoader.returnXML();
			
			var key:String = new String();
			var counter:int = 0;

			for (var i:int=0; copyXml.textItem[i] != undefined; i++) 
			{
				key = String(copyXml.textItem[i].@id);
				applicationData.copy[key] = copyXml.textItem[i];
			}
			
			Controller.eventDispatcher.dispatchEvent(
				new ApplicationDataEvent(
					ApplicationDataEvent.COPY_DATA_LOADED));
		}
	}
}