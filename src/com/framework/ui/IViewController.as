package com.framework.ui
{
	import com.framework.control.Controller;
	import com.framework.ui.IModel;
	
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
    
    public interface IViewController extends IEventDispatcher
    {
        function get dataProvider():IModel
        
        function set dataProvider(value:IModel):void;
		
		function get view():MovieClip;
        
		
		
		/********************************************/
		/***                 INIT                 ***/
		/********************************************/
		
		
		
		
		/********************************************/
		/***            CLICK HANDLERS            ***/
		/********************************************/
		
		/********************************************/
		/***               DISPOSE                ***/
		/********************************************/
		function dispose():void;
    }
}