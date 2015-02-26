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
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
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
            
//			var my_square:Shape = new Shape();
//			my_square.graphics.beginFill(0xce1326,1);
//			my_square.graphics.drawRect(0,0,dataProvider.stageReference.fullScreenWidth,dataProvider.stageReference.fullScreenHeight);
//			view.addChildAt(my_square, 0);
			
			view.idea_txt.text = dataProvider.copy["idleViewTitleIdea"];
			
			view.addEventListener(MouseEvent.CLICK, slideClickHandler);
						
        }
        
        
        /********************************************/
        /***            CLICK HANDLERS            ***/
        /********************************************/
        
		private function slideClickHandler(e:MouseEvent):void
        {
			
				Controller.eventDispatcher.dispatchEvent(
					new ApplicationControllerEvent(
						ApplicationControllerEvent.SET_SLIDE_VIEW_STATE));
			
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