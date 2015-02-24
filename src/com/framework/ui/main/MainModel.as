package com.framework.ui.main
{	
	import com.framework.data.IApplicationData;
	import com.framework.events.ApplicationDataEvent;
	import com.framework.ui.AbstractModel;
	import com.framework.ui.IUIState;
		
	public class MainModel extends AbstractModel
	{	
		public function MainModel(applicationData:IApplicationData)
		{
			super(applicationData);
			init();
		}
		
		private function currentUIStateChangeHandler(e:ApplicationDataEvent):void
        {
            dispatchEvent(e.clone());
        }
		/**
		 * adds Event listener to for <code>CURRENT_UI_STATE_CHANGE</code>
		 * 
		 */        
        private function init():void
        {
            applicationData.addEventListener(ApplicationDataEvent.CURRENT_UI_STATE_CHANGE, currentUIStateChangeHandler, false, 0, true);
        }
	}
}