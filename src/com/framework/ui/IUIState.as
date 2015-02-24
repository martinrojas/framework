package com.framework.ui
{
	import com.framework.ui.IViewController;
	import com.framework.data.IApplicationData;
	import com.framework.ui.IModel;

    public interface IUIState
    {
    	function dispose():void;
    	
        function handle(viewController:IViewController):void;
    }
}