package com.controllerFramework.commands
{
	import com.controllerFramework.data.IApplicationData;
	import com.controllerFramework.events.ApplicationControllerEvent;
	import com.controllerFramework.ui.program.ProgramViewState;
	
	public class SetProgramViewStateCommand extends AbstractCommand implements ICommand
	{
		public function SetProgramViewStateCommand(applicationData:IApplicationData)
		{
			super(applicationData);
		}
		
		public function execute(event:ApplicationControllerEvent):void
		{
			applicationData.previousUIState = applicationData.currentUIState;
			applicationData.currentUIState = new com.controllerFramework.ui.program.ProgramViewState(event.id);
		}
	}
}