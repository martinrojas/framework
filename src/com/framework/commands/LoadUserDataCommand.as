package com.controllerFramework.commands
{
	import com.controllerFramework.control.Controller;
	import com.controllerFramework.data.IApplicationData;
	import com.controllerFramework.data.UserData;
	//import com.metlife.central.data.UserDataDeserializer;
	import com.controllerFramework.events.ApplicationControllerEvent;
	
	import flash.external.ExternalInterface;
	
	public class LoadUserDataCommand extends AbstractCommand implements ICommand
	{
		private var _ifCardUserData:String;
		
		private var _applicationData:IApplicationData;
		
		public function LoadUserDataCommand(applicationData:IApplicationData)
		{
			super(applicationData);
		}

		public function execute(e:ApplicationControllerEvent):void
        {
			if(ExternalInterface.available)
			{
				try {
					getExternalUserData();
				}
				catch(e:Error) {
					Controller.logger.log("External Interface unavailable" + e.message);
				}
			}
			else {
					getExternalUserData();
			}
        }
        
        private function getExternalUserData():void
        {
        	if(ExternalInterface.available)
        	{
        		try {        			
        			//var userData:String = ExternalInterface.call("CustomerGetByBarcode", applicationData.barCodeData);
        			//var userData:String = "CustomerId:76301003#Firstname:Kola#Lastname:Ashiru#Email:kashiru@gmail.com#AccountNo:0100000000001321#HomephoneNo:7703304152#PostalCode:30346#IsOver21:true#NotifyUserEvents:true#PrizeNotificationPreference:email#IsPostalCodeEligible:true#IsSplitSecondPrizeWinner:false#IsEnrolledForBigTimePrize:true#IsEnrolledForFourthQuarterGame:false#IsEligibleForFourthQuarter:true#";
        			var userData:String = "-1";
        			
        			if(userData != null)
        			{
        				var userDataParser:UserDataDeserializer = new UserDataDeserializer(userData);
        	
       		     		var user:UserData = userDataParser.getUser();
            
            			applicationData.currentUser = user;
           			}
        		}
        		catch(e:Error) {
        			Controller.logger.log("External Interface unavailable" + e.message);
        		}
        	}
        }
	}
}