package com.controllerFramework.commands
{
    import com.controllerFramework.data.IApplicationData;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    
    public class AbstractURLLoaderCommand extends AbstractCommand
    {
        public function AbstractURLLoaderCommand(applicationData:IApplicationData)
        {
            super(applicationData);
        }
        
        protected function addURLLoaderEventHandlers(urlLoader:URLLoader):void
        {
            urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
        }
        
        protected function removeURLLoaderEventHandlers(urlLoader:URLLoader):void
        {
            urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
            urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
            urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
        }
        
        protected function urlLoaderCompleteHandler(e:Event):void
        {
            var urlLoader:URLLoader = URLLoader(e.target);
            
            removeURLLoaderEventHandlers(urlLoader);
        }
        
        protected function urlLoaderIOErrorHandler(e:IOErrorEvent):void
        {
            var urlLoader:URLLoader = URLLoader(e.target);
            
            removeURLLoaderEventHandlers(urlLoader);
        }
        
        protected function urlLoaderSecurityErrorHandler(e:SecurityErrorEvent):void
        {
            var urlLoader:URLLoader = URLLoader(e.target);
            
            removeURLLoaderEventHandlers(urlLoader);
        }
    }
}