package com.application.ui.idle
{
	import com.custom.ui.ToggleButton;
	import com.framework.control.Controller;
	import com.framework.data.ApplicationData;
	import com.framework.events.ApplicationControllerEvent;
	import com.framework.events.ApplicationDataEvent;
	import com.framework.events.UIEvent;
	import com.framework.ui.IModel;
	import com.framework.ui.IViewController;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class IdleViewController extends EventDispatcher implements IViewController
	{
		private var _dataProvider:IdleModel;
		
        private var _view:IdleView;

		public function get dataProvider():IModel
        {
            return _dataProvider;
        }
        
        public function set dataProvider(value:IModel):void
        {
            if (value != null)
            {
                _dataProvider = IdleModel(value);
                updateView();
            }
        }
        
        public function get view():MovieClip
        {
            if (_view == null)
            {
                _view = new IdleView();
            }
            return _view;
        }
		
		public function IdleViewController($dataProvider:IdleModel = null)
		{
			super();
            init($dataProvider);
		}

                               
        /********************************************/
        /***                 INIT                 ***/
        /********************************************/
        
        private function init(dataProvider:IdleModel):void
        {
			this.dataProvider = dataProvider;
            
            
			if(dataProvider.demoMode)
			{
				view.scenerio2Btn.visible = false;
				view.learn2Btn.visible = false;
				
				view.demoBtn.addEventListener(
					MouseEvent.CLICK, 
					demoClickHandler, 
					false, 
					0, 
					true);
				
				view.learnBtn.addEventListener(
					MouseEvent.CLICK, 
					learnClickHandler, 
					false, 
					0, 
					true);
				
				view.scenarioBtn.addEventListener(
					MouseEvent.CLICK,
					scenerioClickHandler,
					false,
					0,
					true);
				
			}
			
			else
			{
				
				view.demoBtn.visible = false;
				view.scenarioBtn.visible = false;
				view.learnBtn.visible = false;
				
				view.learn2Btn.addEventListener(
					MouseEvent.CLICK, 
					learnClickHandler, 
					false, 
					0, 
					true);
				
				view.scenerio2Btn.addEventListener(
					MouseEvent.CLICK,
					scenerioClickHandler,
					false,
					0,
					true);
			}
				
			
						
        }
        
        private function idleViewFrameHandler():void
        {
        	//var view:IdleView = IdleView(view);
        	
        	//addFrameBehaviour(view.gametimeFace, END, null);
        	
        	//view.gotoAndStop(END);
        }
        
        /********************************************/
        /***            CLICK HANDLERS            ***/
        /********************************************/
        
		private function demoClickHandler(e:MouseEvent):void
        {
			var view:IdleView = IdleView(view);
			
				Controller.eventDispatcher.dispatchEvent(
					new ApplicationControllerEvent(
						ApplicationControllerEvent.SET_DEMO_VIEW_STATE));
			
        }
		
		private function learnClickHandler(e:MouseEvent):void
		{
			var view:IdleView = IdleView(view);
			
			Controller.eventDispatcher.dispatchEvent(
				new ApplicationControllerEvent(
					ApplicationControllerEvent.SET_MARKETING_VIEW_STATE));
			
		}
		
		private function scenerioClickHandler(e:MouseEvent):void
		{
			var view:IdleView = IdleView(view);
			
			Controller.eventDispatcher.dispatchEvent(
				new ApplicationControllerEvent(
					ApplicationControllerEvent.SET_SCENERIO_VIEW_STATE));
			
		}
		
		/********************************************/
		/***            CLICK HANDLERS            ***/
		/********************************************/
		
        public function dispose():void
        {
			var view:IdleView = IdleView(view);
			
        	if(view.demoBtn.hasEventListener(MouseEvent.CLICK))
        	{
				view.demoBtn.removeEventListener(MouseEvent.CLICK, demoClickHandler);
        	}
			if(view.learnBtn.hasEventListener(MouseEvent.CLICK))
			{
				view.learnBtn.removeEventListener(MouseEvent.CLICK, learnClickHandler);
			}
        	
        	while (view.numChildren)
            {
                view.removeChildAt(0);
            }
        	
        	Controller.logger.log("Method dispose() called on IdleViewController");
        }
        
        private function updateView():void
        {
            
        }
	}
}