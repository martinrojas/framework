package com.application.commands
{
	import com.application.ui.idle.IdleViewState;
	import com.framework.commands.AbstractCommand;
	import com.framework.commands.ICommand;
	import com.framework.data.IApplicationData;
	import com.framework.events.ApplicationControllerEvent;

	/**
	 * Changes the UI state to IdleViewState()
	 * 
	 * @see ApplicationControllerEvent
	 */	
	public class SetIdleViewStateCommand extends AbstractCommand implements ICommand
	{
		
		public function SetIdleViewStateCommand(applicationData:IApplicationData)
		{
			super(applicationData);
		}

 		public function execute(e:ApplicationControllerEvent):void
        {
			applicationData.previousUIState = applicationData.currentUIState;
			applicationData.currentUIState = new com.application.ui.idle.IdleViewState();
        }
	}
}