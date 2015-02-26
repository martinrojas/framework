package com.application.ui.slide
{
	import com.framework.data.IApplicationData;
	import com.framework.events.ApplicationDataEvent;
	import com.framework.ui.AbstractModel;
	
	import flash.display.Stage;
	
	public class SlideModel extends AbstractModel
	{
		public function SlideModel(applicationData:IApplicationData)
		{
			super(applicationData);
			
			init();
		}

		private function configDataChangeHandler(e:ApplicationDataEvent):void
        {
            dispatchEvent(e.clone());
        }
        
        private function init(e:ApplicationDataEvent = null):void
        {
            //applicationData.addEventListener(ApplicationDataEvent.CONFIG_DATA_CHANGE, configDataChangeHandler, false, 0, true);
        }
		
		public function get stageReference():Stage
		{
			return applicationData.stageReference;
		}
	}
}