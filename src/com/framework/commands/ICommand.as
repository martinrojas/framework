package com.framework.commands
{
    import com.framework.events.ApplicationControllerEvent;
    
    public interface ICommand
    {
        function execute(event:ApplicationControllerEvent):void;
    }
}