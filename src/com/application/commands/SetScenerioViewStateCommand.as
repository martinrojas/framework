package com.controllerFramework.commands
{
	import com.controllerFramework.data.IApplicationData;
	import com.controllerFramework.events.ApplicationControllerEvent;
	import com.controllerFramework.ui.scenario.ScenerioViewState;

	/**
	 * Changes the UI state to IdleViewState()
	 * 
	 * @see ApplicationControllerEvent
	 */	
	public class SetScenerioViewStateCommand extends AbstractCommand implements ICommand
	{
		
		public function SetScenerioViewStateCommand(applicationData:IApplicationData)
		{
			super(applicationData);
		}

 		public function execute(e:ApplicationControllerEvent):void
        {
			applicationData.previousUIState = applicationData.currentUIState;
			applicationData.currentUIState = new com.controllerFramework.ui.scenario.ScenerioViewState();
        }
	}
}