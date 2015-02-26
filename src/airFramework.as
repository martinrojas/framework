package
{
	
	import com.application.commands.SetIdleViewStateCommand;
	import com.application.commands.SetSlideViewStateCommand;
	import com.framework.commands.SetPreviousViewStateCommand;
	import com.framework.commands.StartupCommand;
	import com.framework.control.ApplicationController;
	import com.framework.control.Controller;
	import com.framework.data.ApplicationData;
	import com.framework.events.ApplicationControllerEvent;
	import com.framework.events.ApplicationDataEvent;
	import com.framework.managers.InteractionManager;
	import com.framework.ui.main.MainModel;
	import com.framework.ui.main.MainViewController;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	
	[SWF(backgroundColor="0xFFFFFF")]
	public class airFramework extends Sprite
	{
		private var _applicationController:ApplicationController;
		
		private var _applicationData:ApplicationData;
		
		private var _mainModel:MainModel;
		
		private var _mainViewController:MainViewController;
		
		private var _interactionManager:InteractionManager;
		
		
		public function airFramework()
		{
			super();
			
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
//			this.scaleX = 0.5;
//			this.scaleY = 0.5;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * function called once initialized and has been added to the stage.
		 * init() registers commands, initializes <code>ApplicationData, ApplicationController,
		 * InterationManager, MainModel, MainViewController</code>, and add <code>MainView</code> to stage.
		 * 
		 * @param e <code>ADDED_TO_STAGE</code> event
		 * 
		 * @see initBarCodeScanner
		 * @see registerCommands
		 * @see Controller
		 */	
		private function init (e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init); 
			
			_applicationData = new ApplicationData();
			_applicationController = new ApplicationController(_applicationData);
			_interactionManager = new InteractionManager(stage, _applicationData);
			
			_applicationData.stageReference = stage;
			
			registerCommands();
			
			_mainModel = new MainModel(_applicationData);
			_mainViewController = new MainViewController(_mainModel);
			
			addChild(_mainViewController.view);
			
			addChild(Controller.logger);
			
			
			Controller.eventDispatcher.addEventListener(ApplicationDataEvent.COPY_DATA_LOADED, onCopyDataLoaded);
			
			
			Controller.eventDispatcher.dispatchEvent(
				new ApplicationControllerEvent(
					ApplicationControllerEvent.STARTUP));
			
		}
		
		/**
		 * registers<code>STARTUP, SET_IDLE_VIEW_STATE, SET_ENGAGEMENT_VIEW_STATE, SET_MIRROR_VIEW_STATE, SET_PHOTO_ALBUM_VIEW_STATE, SET_CAM_CONFIG_VIEW_STATE</code> in applicationController
		 * 
		 * @see ApplicationController
		 */	
		private function registerCommands ():void
		{
			_applicationController.registerCommand(ApplicationControllerEvent.STARTUP, StartupCommand);
			
			//			_applicationController.registerCommand(ApplicationControllerEvent.LOAD_COPY_DATA, LoadCopyDataCommand);
			
			_applicationController.registerCommand(ApplicationControllerEvent.SET_PREVIOUS_VIEW_STATE, SetPreviousViewStateCommand);
			
			_applicationController.registerCommand(ApplicationControllerEvent.SET_IDLE_VIEW_STATE, SetIdleViewStateCommand);
			
			_applicationController.registerCommand(ApplicationControllerEvent.SET_SLIDE_VIEW_STATE, SetSlideViewStateCommand);
			
			//			_applicationController.registerCommand(ApplicationControllerEvent.SET_MARKETING_VIEW_STATE, SetMarketingViewStateCommand);
			
			//			_applicationController.registerCommand(ApplicationControllerEvent.SET_PROGRAM_VIEW_STATE, SetProgramViewStateCommand);
			
			//			_applicationController.registerCommand(ApplicationControllerEvent.SET_SCENERIO_VIEW_STATE, SetScenerioViewStateCommand);
			
			//			_applicationController.registerCommand(ApplicationControllerEvent.SET_ENERGY_VIEW_STATE, SetEnergyViewStateCommand);
		}
		
		
		private function onCopyDataLoaded(e:ApplicationDataEvent):void
		{
			Controller.eventDispatcher.removeEventListener(ApplicationDataEvent.COPY_DATA_LOADED, onCopyDataLoaded);
			
			Controller.eventDispatcher.dispatchEvent(
				new ApplicationControllerEvent(
					ApplicationControllerEvent.SET_IDLE_VIEW_STATE));
		}
		
		
		
	}
}