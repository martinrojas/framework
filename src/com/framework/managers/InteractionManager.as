package com.framework.managers
{
	import com.framework.control.Controller;
	import com.framework.data.IApplicationData;
	import com.framework.events.ApplicationControllerEvent;
	import com.framework.events.ApplicationDataEvent;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
    
    public class InteractionManager
    {
        public var AUTO_ENGAGEMENT_TIMER_DURATION:Number = 60000;
        
        public var AUTO_IDLE_TIMER_DURATION:Number = 60000;
        
        private var _applicationData:IApplicationData;
        
        private var _autoEngagementTimer:Timer;
        
        private var _autoIdleTimer:Timer;
        
        private var _stage:Stage;
        
        
        public function InteractionManager(stage:Stage, applicationData:IApplicationData)
        {
            super();
            
			_applicationData = applicationData;
			_stage = stage;

            
			Controller.eventDispatcher.addEventListener(ApplicationDataEvent.SET_APPLICATION_TIMEOUTS, init);
            Controller.logger.log("Interaction Manager Enabled");
        }
        
        private function autoEngagementTimerHandler(e:TimerEvent):void
        {
        	Controller.logger.log("Engagement timeout has fired");
        	
//            if (!(_applicationData.currentUIState is IdleViewState))
//            {
//            	restartTimers();
//				            	
//                Controller.eventDispatcher.dispatchEvent(
//                    new ApplicationControllerEvent(
//                        ApplicationControllerEvent.SET_IDLE_VIEW_STATE));
//            }
            
        }
        
        private function autoIdleTimerHandler(e:TimerEvent):void
        {
        	Controller.logger.log("Idle timeout has fired");
        	
//            if (_applicationData.currentUIState is EngagementViewState)
//            {
//            	resetTimers();
//            	
//                Controller.eventDispatcher.dispatchEvent(
//                    new ApplicationControllerEvent(
//                        ApplicationControllerEvent.SET_IDLE_VIEW_STATE));
//            }
            
        }
        
        private function init(e:ApplicationDataEvent):void
        {
			Controller.eventDispatcher.removeEventListener(ApplicationDataEvent.SET_APPLICATION_TIMEOUTS, init);
			
            initStage(_stage);
            initApplicationData(_applicationData);
			
			AUTO_ENGAGEMENT_TIMER_DURATION = Number(_applicationData.timeoutValues.SessionTimeout) * 1000;
            
            if(ExternalInterface.available)
            {
            	//ExternalInterface.addCallback("countdownQ1Kickoff", kickoffCountdownHandler);
            	//Controller.logger.log("Registered Countdown Kickoff Method with .NET");
            }
            
            initAutoEngagementTimer(new Timer(AUTO_ENGAGEMENT_TIMER_DURATION, 1));
            initAutoIdleTimer(new Timer(AUTO_IDLE_TIMER_DURATION, 1));
        }
        
        private function initApplicationData(applicationData:IApplicationData):void
        {
            _applicationData = applicationData;
                
            _applicationData.addEventListener(
                ApplicationDataEvent.CURRENT_USER_CHANGE, 
                userDataChangeHandler, 
                false, 
                0, 
                true);
        }
        
        private function initAutoEngagementTimer(autoEngagementTimer:Timer):void
        {
            _autoEngagementTimer = autoEngagementTimer;
            
            _autoEngagementTimer.addEventListener(
                TimerEvent.TIMER, 
                autoEngagementTimerHandler, 
                false, 
                0, 
                true);
        }
        
        private function initAutoIdleTimer(autoIdleTimer:Timer):void
        {
            _autoIdleTimer = autoIdleTimer;
            
            _autoIdleTimer.addEventListener(
                TimerEvent.TIMER, 
                autoIdleTimerHandler, 
                false, 
                0, 
                true);
        }
        
        private function initStage(stage:Stage):void
        {
            _stage = stage;
            
            _stage.addEventListener(
                KeyboardEvent.KEY_DOWN, 
                keyboardKeyDownHandler, 
                false, 
                0, 
                true);
                
            _stage.addEventListener(
                MouseEvent.CLICK, 
                stageMouseClickHandler, 
                false, 
                0, 
                true);
        }
        
        private function reportUserInteraction(interactionType:String):void
        {
			Controller.logger.log("User Interaction of type:" +interactionType + " Reported");
            
			restartTimers();
        }
        
        private function restartAutoIdleTimer():void
        {
            _autoIdleTimer.reset();
            _autoIdleTimer.start();
        }
        
        private function restartAutoEngagementTimer():void
        {
            _autoEngagementTimer.reset();
            _autoEngagementTimer.start();
        }

        private function resetTimers():void
        {
            _autoIdleTimer.reset();
            _autoEngagementTimer.reset();
        }
        
        private function restartTimers():void
        {
            restartAutoIdleTimer();
            restartAutoEngagementTimer();
        }
        
		private function keyboardKeyDownHandler(e:KeyboardEvent):void
        {            
            reportUserInteraction("keyboard");
        }
        
        private function stageMouseClickHandler(e:MouseEvent):void
        {
            reportUserInteraction("touch");
        }
        
        private function userDataChangeHandler(e:ApplicationDataEvent):void
        {
            reportUserInteraction("card scan");
        }
    }
}