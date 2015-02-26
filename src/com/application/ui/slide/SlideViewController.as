package com.application.ui.slide
{
	import com.custom.ui.SlideHolder;
	import com.framework.control.Controller;
	import com.framework.ui.IModel;
	import com.framework.ui.IViewController;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class SlideViewController extends EventDispatcher implements IViewController
	{
		private var _dataProvider:SlideModel;
		
        private var _view:SlideView;
		
		private var _slider:SlideHolder;

		public function get dataProvider():IModel
        {
            return _dataProvider;
        }
        
        public function set dataProvider(value:IModel):void
        {
            if (value != null)
            {
                _dataProvider = SlideModel(value);
                updateView();
            }
        }
        
        public function get view():MovieClip
        {
            if (_view == null)
            {
                _view = new SlideView();
            }
            return _view;
        }
		
		public function SlideViewController($dataProvider:SlideModel = null)
		{
			super();
            init($dataProvider);
		}

                               
        /********************************************/
        /***                 INIT                 ***/
        /********************************************/
        
        private function init(dataProvider:SlideModel):void
        {
			this.dataProvider = dataProvider;
            
			_slider = new SlideHolder();
			_slider.x = 0;
			_slider.y = 0; 
			view.addChild(_slider);
			
			
			
			view.addEventListener(MouseEvent.CLICK, slideClickHandler);
        }
        
        
        /********************************************/
        /***            CLICK HANDLERS            ***/
        /********************************************/
        
		private function slideClickHandler(e:MouseEvent):void
        {
			
//				Controller.eventDispatcher.dispatchEvent(
//					new ApplicationControllerEvent(
//						ApplicationControllerEvent.SET_DEMO_VIEW_STATE));
			
        }
		
		
		/********************************************/
		/***          DISPOSE HANDLERS            ***/
		/********************************************/
		
        public function dispose():void
        {
			
        	if(view.hasEventListener(MouseEvent.CLICK))
        	{
				view.removeEventListener(MouseEvent.CLICK, slideClickHandler);
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