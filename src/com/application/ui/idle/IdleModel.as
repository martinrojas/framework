package com.application.ui.idle
{
	import com.framework.data.IApplicationData;
	import com.framework.events.ApplicationDataEvent;
	import com.framework.ui.AbstractModel;
	
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	public class IdleModel extends AbstractModel
	{
		public function IdleModel(applicationData:IApplicationData)
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
		
		public function get demoMode():Boolean
		{
			return applicationData.demoMode;
		}
		
		public function get stageReference():Stage
		{
			return applicationData.stageReference;
		}
		
		public function get copy():Dictionary
		{
			return applicationData.copy;
		}
	}
}