package com.custom.ui
{
	import flash.display.MovieClip;
	
	public class ActivityItem extends MovieClip
	{
		private var _item:activityItem;
		
		public function ActivityItem($name:String = "N/A", $desc:String = "N/A", $time:String = "12:00 PM EST")
		{
			super();
			_item = new activityItem();
			
			_item.bulb.visible = false;
			_item.nameLbl.text = $name; 
			_item.actionLbl.text = $desc;
			_item.timeLbl.text = $time;
			
			this.addChild(_item);
		}
	}
}