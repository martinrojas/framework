package com.application.commands
{
	import com.application.ui.slide.SlideViewState;
	import com.framework.commands.AbstractCommand;
	import com.framework.commands.ICommand;
	import com.framework.data.IApplicationData;
	import com.framework.events.ApplicationControllerEvent;
	
	/**
	 * Changes the UI state to DemoViewState()
	 * 
	 * @see ApplicationControllerEvent
	 */	
	public class SetSlideViewStateCommand extends AbstractCommand implements ICommand
	{
		public function SetSlideViewStateCommand(applicationData:IApplicationData)
		{
			super(applicationData);
		}
		
		public function execute(event:ApplicationControllerEvent):void
		{
			applicationData.previousUIState = applicationData.currentUIState;
			applicationData.currentUIState = new com.application.ui.slide.SlideViewState();
		}
	}
}