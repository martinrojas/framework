package com.framework.ui.main
{
    import com.framework.events.ApplicationDataEvent;
    import com.framework.ui.IModel;
    import com.framework.ui.IUIState;
    import com.framework.ui.IViewController;
    
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    public class MainViewController extends EventDispatcher implements IViewController
    {
        private var _dataProvider:MainModel;
        private var _view:MainView;
        
        public function get dataProvider():IModel
        {
            return _dataProvider;
        }
        
        public function set dataProvider(value:IModel):void
        {
            if (value != null)
            {
                _dataProvider = MainModel(value);
                
                if (_dataProvider.hasEventListener(ApplicationDataEvent.CURRENT_UI_STATE_CHANGE))
                {
                    _dataProvider.removeEventListener( ApplicationDataEvent.CURRENT_UI_STATE_CHANGE, currentUIStateChangeHandler);
                }
                _dataProvider.addEventListener(ApplicationDataEvent.CURRENT_UI_STATE_CHANGE, currentUIStateChangeHandler);
                
                updateView();
            }
        }
        
        public function get view():MovieClip
        {
            if (_view == null)
            {
                _view = new MainView();
            }
            return _view;
        }
        
        public function MainViewController(dataProvider:MainModel = null)
        {
            super();
            init(dataProvider);
        }
        
        private function currentUIStateChangeHandler(e:ApplicationDataEvent):void
        {
            if (dataProvider != null)
            {
                var currentUIState:IUIState = dataProvider.currentUIState;
                currentUIState.handle(this);
            }
        }
        
        private function init(dataProvider:MainModel):void
        {
            this.dataProvider = dataProvider;
			/*
            view.addEventListener(
            	Event.ADDED_TO_STAGE, 
            	viewAddedToStageHandler, 
            	false, 
            	0, 
            	true);
            */
        }
        
        private function updateView():void
        {
            
        }
        
        private function viewAddedToStageHandler(event:Event):void
        {
            
        }
		
		public function dispose():void
		{
			
		}
    }
}