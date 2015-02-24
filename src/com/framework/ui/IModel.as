package com.framework.ui
{
    import com.framework.data.IApplicationData;
    import com.framework.ui.IUIState;
    
    public interface IModel
    {
        function get currentUIState():IUIState
        
        function getApplicationData():IApplicationData;
    }
}