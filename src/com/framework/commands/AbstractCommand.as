package com.framework.commands
{
    import com.framework.data.IApplicationData;
    
    public class AbstractCommand
    {
        private var _applicationData:IApplicationData;
        
        protected final function get applicationData():IApplicationData
        {
            return _applicationData;
        }
        
        public function AbstractCommand(applicationData:IApplicationData)
        {
            super();
            init(applicationData);
        }
        
        private function init(applicationData:IApplicationData):void
        {
            _applicationData = applicationData;
        }
    }
}