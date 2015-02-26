package com.application.ui.slide
{
    import com.framework.data.IApplicationData;
    import com.framework.ui.IModel;
    import com.framework.ui.IUIState;
    import com.framework.ui.IViewController;
    
    import flash.display.Sprite;
	
	public class SlideViewState implements IUIState
	{
		private var _slideModel:SlideModel;
    	
    	private var _slideViewController:SlideViewController;
    	
    	private var _view:Sprite;
		
		public function SlideViewState()
		{
			super();
		}
		
		public function dispose():void
        {
        	_slideViewController.dispose();
            _slideViewController = null;
            _slideModel = null;
        }

		public function handle(viewController:IViewController):void
		{
			_view = viewController.view;
            
			while (_view.numChildren)
        	{
        		_view.removeChildAt(0);
        	}

			var model:IModel = viewController.dataProvider;
			var applicationData:IApplicationData = model.getApplicationData();
			
			_slideModel = new SlideModel(applicationData);
			_slideViewController = new SlideViewController(_slideModel);
            
			_view.addChild(_slideViewController.view);
        }
	}
}