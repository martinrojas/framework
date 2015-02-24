package com.framework.commands
{
	import com.framework.data.IApplicationData;
	import com.framework.events.ApplicationControllerEvent;
	
	public class SetPreviousViewStateCommand extends AbstractCommand implements ICommand
	{
		public function SetPreviousViewStateCommand(applicationData:IApplicationData)
		{
			super(applicationData);
		}
		
		public function execute(event:ApplicationControllerEvent):void
		{
			applicationData.currentUIState = applicationData.previousUIState;
		}
	}
}