package com.framework.data
{
    import com.framework.ui.IUIState;
    
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Stage;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
   
    public interface IApplicationData extends IEventDispatcher
    {   
		function get xmlFileURLs():Dictionary;
		
		function set xmlFileURLs(value:Dictionary):void;
		
		function get timeoutValues():Dictionary;
		
		function set timeoutValues(value:Dictionary):void;
		
        function get currentUIState():IUIState;
        
        function set currentUIState(value:IUIState):void;
          
		function get previousUIState():IUIState;
		
		function set previousUIState(value:IUIState):void;
		
        function get activeSession():Boolean;
        
        function set activeSession(value:Boolean):void;
        
        function get stageReference():Stage;
        
        function set stageReference(value:Stage):void;
		
		function get copy():Dictionary;
		
		function set copy(value:Dictionary):void;
		
		function get serverIP():String;
		
		function set serverIP(value:String):void;
		
		function get demoMode():Boolean;
		
		function set demoMode(value:Boolean):void;
    }
}