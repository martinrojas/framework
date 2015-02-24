package com.framework.ui
{
    import com.framework.data.IApplicationData;
    
    import flash.events.EventDispatcher;
    import com.framework.ui.IModel;
    import com.framework.ui.IUIState;
    
    public class AbstractModel extends EventDispatcher implements IModel
    {
        private var _applicationData:IApplicationData;
        
        protected final function get applicationData():IApplicationData
        {
            return _applicationData;
        }
        
        public function get currentUIState():IUIState
        {
            return applicationData.currentUIState;
        }
        
        public function AbstractModel(applicationData:IApplicationData)
        {
            super();
            init(applicationData);
        }
        
        public function getApplicationData():IApplicationData
        {
            return applicationData;
        }
        
        private function init(applicationData:IApplicationData):void
        {
            _applicationData = applicationData;
        }
    }
}