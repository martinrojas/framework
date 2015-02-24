package com.framework.control
{
	import com.framework.commands.AbstractCommand;
	import com.framework.commands.ICommand;
	import com.framework.data.IApplicationData;
	import com.framework.events.ApplicationControllerEvent;
	
	import flash.utils.Dictionary;
	/**
	 * holds applicationData and a commands dictionary
	 * 
	 * @see IApplicationData
	 */	
	public class ApplicationController
	{
        private var _applicationData:IApplicationData;
        private var _commands:Dictionary;
        
		public function ApplicationController(applicationData:IApplicationData)
		{
			super();
			
            _applicationData = applicationData;
            _commands = new Dictionary();
		}
		
		public function executeCommand(command:ICommand, event:ApplicationControllerEvent):void
		{
			command.execute(event);
		}
		
		public function getCommandByEventType(eventType:String):Class
		{
			return _commands[eventType];
		}
		
		/**
		 * Adds event listener to the <code>Controller.eventDispatcher</code>
		 *  
		 * @param eventType
		 * @param commandClass
		 * 
		 */		
		public function registerCommand(eventType:String, commandClass:Class):void
		{
			Controller.eventDispatcher.addEventListener(eventType, controllerEventHandler, false, 0, true);
                
			_commands[eventType] = commandClass;
		}
		
		/**
		 * handles events and calls <code>executeCommand</code>
		 * 
		 * @param event <code>ApplicationControllerEvent</code>
		 * 
		 * @see executeCommand
		 */		
		private function controllerEventHandler(event:ApplicationControllerEvent):void
		{
			var commandClass:Class = getCommandByEventType(event.type);
			var command:AbstractCommand = AbstractCommand(new commandClass(_applicationData));
			
			executeCommand(ICommand(command), event);
		}
	}
}