package com.framework.commands
{
    import com.framework.control.Controller;
    import com.framework.data.IApplicationData;
    import com.framework.events.ApplicationControllerEvent;
    import com.framework.events.ApplicationDataEvent;
    
    import flash.events.Event;
    

	/**
	 * command executed at start up of the application, also checks for a .NET interface 
	 * 
	 */    
    public class StartupCommand extends AbstractCommand implements ICommand
    {
//    	private static const READY_TIMER:Timer = new Timer(100, 0);
		
		private static const APPLICATION_CONFIG_URL:String = "applicationConfig.xml";
    	
		private static const KEY_XML_COPY:String = "copy";
//		private static const KEY_XML_ASSETS:String = "assets";
//		private static const KEY_XML_KEYBOARD:String = "keyboard";
		
		
        public function StartupCommand(applicationData:IApplicationData)
        {
            super(applicationData);
        }
        
        public function execute(event:ApplicationControllerEvent):void
        {   
        	//READY_TIMER.addEventListener(TimerEvent.TIMER, checkDotNetReady);
        	//READY_TIMER.start();
			
			Controller.xmlLoader.addEventListener(Event.COMPLETE, onApplicationConfigLoadComplete);
			Controller.xmlLoader.loadNewXml(APPLICATION_CONFIG_URL);
            
        }
		
		private function onApplicationConfigLoadComplete(e:Event):void
		{
			Controller.xmlLoader.removeEventListener(Event.COMPLETE, onApplicationConfigLoadComplete);
			
			var applicationConfigXML:XML = Controller.xmlLoader.returnXML();
			var i:int;
			
			
			for (i = 0; applicationConfigXML.xmlFiles.xmlFile[i] != undefined; i++)
			{
				applicationData.xmlFileURLs[String(applicationConfigXML.xmlFiles.xmlFile[i].@id)] = applicationConfigXML.xmlFiles.xmlFile[i];
			}
			
			for (i = 0; applicationConfigXML.timeoutValues.timeoutValue[i] != undefined; i++)
			{
				applicationData.timeoutValues[String(applicationConfigXML.timeoutValues.timeoutValue[i].@id)] = applicationConfigXML.timeoutValues.timeoutValue[i];
			}
			
			applicationData.serverIP = applicationConfigXML.serverIPs.serverIP[0];
			applicationData.demoMode = (applicationConfigXML.modes.mode[0] == "true") ? true : false;
			
			Controller.webService.init(applicationData);
			Controller.eventDispatcher.dispatchEvent(new ApplicationDataEvent(ApplicationDataEvent.SET_APPLICATION_TIMEOUTS));
			
//			TEMP - skiping copy load to idle view state load
			Controller.eventDispatcher.dispatchEvent(
				new ApplicationControllerEvent(
					ApplicationControllerEvent.SET_IDLE_VIEW_STATE));
			
			
//			Controller.eventDispatcher.dispatchEvent(
//				new ApplicationControllerEvent(
//					ApplicationControllerEvent.LOAD_COPY_DATA, applicationData.xmlFileURLs[KEY_XML_COPY]));
			
			
		}
        
    }
}