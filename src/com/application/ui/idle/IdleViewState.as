package com.application.ui.idle
{
    import com.framework.data.IApplicationData;
    import com.framework.ui.IModel;
    import com.framework.ui.IUIState;
    import com.framework.ui.IViewController;
    
    import flash.display.Sprite;
	
	public class IdleViewState implements IUIState
	{
		private var _idleModel:IdleModel;
    	
    	private var _idleViewController:IdleViewController;
    	
    	private var _view:Sprite;
		
		public function IdleViewState()
		{
			super();
		}
		
		public function dispose():void
        {
        	_idleViewController.dispose();
            
            _idleViewController = null;
            _idleModel = null;
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
			
			_idleModel = new IdleModel(applicationData);
			_idleViewController = new IdleViewController(_idleModel);
            
			_view.addChild(_idleViewController.view);
        }
	}
}