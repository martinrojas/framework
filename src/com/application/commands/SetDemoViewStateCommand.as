package com.controllerFramework.commands
{
	import com.controllerFramework.data.IApplicationData;
	import com.controllerFramework.events.ApplicationControllerEvent;
	import com.controllerFramework.ui.demo.DemoViewState;
	
	/**
	 * Changes the UI state to DemoViewState()
	 * 
	 * @see ApplicationControllerEvent
	 */	
	public class SetDemoViewStateCommand extends AbstractCommand implements ICommand
	{
		public function SetDemoViewStateCommand(applicationData:IApplicationData)
		{
			super(applicationData);
		}
		
		public function execute(event:ApplicationControllerEvent):void
		{
			applicationData.previousUIState = applicationData.currentUIState;
			applicationData.currentUIState = new com.controllerFramework.ui.demo.DemoViewState();
		}
	}
}