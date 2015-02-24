package com.controllerFramework.commands
{
	import com.controllerFramework.data.IApplicationData;
	import com.controllerFramework.events.ApplicationControllerEvent;
	import com.controllerFramework.ui.marketing.MarketingViewState;
	
	/**
	 * 
	 * Changes the UI state to MarketingViewState()
	 * 
	 * @see ApplicationControllerEvent
	 * 
	 */
	public class SetMarketingViewStateCommand extends AbstractCommand implements ICommand
	{
		public function SetMarketingViewStateCommand(applicationData:IApplicationData)
		{
			super(applicationData);
		}
		
		public function execute(event:ApplicationControllerEvent):void
		{
			applicationData.previousUIState = applicationData.currentUIState;
			applicationData.currentUIState = new com.controllerFramework.ui.marketing.MarketingViewState();
		}
	}
}