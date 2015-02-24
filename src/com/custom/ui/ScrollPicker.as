package com.custom.ui
{
	import com.controllerFramework.control.Controller;
	import com.controllerFramework.events.UIEvent;
	import com.caurina.transitions.*;
	// TODO change from caurina to greensock
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.custom.ui.ScrollText;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	
	[Embed(source="assets/ScrollPicker.swf", symbol="ScrollPicker")]
	
	public class ScrollPicker extends MovieClip
	{
		public var scrollerView:MovieClip;
		public var glassOverlay:MovieClip;
		
		private var _prevMousePos:Number;
		private var _velocityStartPos:Number;
		private var _velocityStartTime:int;
		private var _pickerValues:Array;
		private var _selectedValue:String;
		
		private static const ITEM_HEIGHT:uint = 30;
		private static const SELECTED_HEIGHT:uint = 60;
		
		override public function get height():Number
		{
			return 176;	
		}
		
		public function ScrollPicker(objects:Array)
		{
			_pickerValues = objects;
			for (var i:uint = 0; i < _pickerValues.length; i++)
			{
				var scrollItems:ScrollText = new ScrollText(_pickerValues[i]);
				scrollItems.y = i * ITEM_HEIGHT;
				scrollerView.addChild(scrollItems);
			}
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			scrollerView.y = SELECTED_HEIGHT;
			
			glassOverlay.selectedOverlay.alpha = 0; 
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if (Tweener.isTweening(scrollerView))
			{
//				Tweener.removeAllTweens();
				Tweener.pauseTweens(scrollerView);
			}
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			_velocityStartTime = flash.utils.getTimer();
			_velocityStartPos = mouseY;
			_prevMousePos = mouseY;
			
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var yPosDiff:Number = mouseY - _prevMousePos;
			_prevMousePos = mouseY;
			scrollerView.y += yPosDiff;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			if (stage.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			if (stage.hasEventListener(MouseEvent.MOUSE_UP))
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			var velocity:Number = this.calculateVelocity();
			
			
			if (scrollerView.y > SELECTED_HEIGHT )
			{
				Tweener.addTween(scrollerView, {y:SELECTED_HEIGHT, time:.6, transition:"easeOutCubic", onComplete:onTweenComplete});
			}
			else if (scrollerView.y < 96-scrollerView.height)
			{
				Tweener.addTween(scrollerView, {y:96-scrollerView.height, time:.6, transition:"easeOutCubic", onComplete:onTweenComplete});
			}
			else
			{
				var tweenEndPosition:Number;
				tweenEndPosition = (velocity * 75) + scrollerView.y;
				if (tweenEndPosition > SELECTED_HEIGHT)
				{
					Tweener.addTween(scrollerView, {y:SELECTED_HEIGHT, time:.6, transition:"easeOutBack", onComplete:onTweenComplete});
				}
				else if (tweenEndPosition < 96-scrollerView.height)
				{
					Tweener.addTween(scrollerView, {y:96-scrollerView.height, time:.6, transition:"easeOutBack", onComplete:onTweenComplete});
				}
				else
				{
					var pos:int = Math.ceil(tweenEndPosition / ITEM_HEIGHT);
					Tweener.addTween(scrollerView, {y:(pos * ITEM_HEIGHT), time:.6, transition:"easeOutCubic", onComplete:onTweenComplete});
				}
			}
		}
		
		private function onTweenComplete():void
		{
			glassOverlay.selectedOverlay.alpha = 0;
			glassOverlay.selectedOverlay.visible = true;
			Tweener.addTween(glassOverlay.selectedOverlay, {alpha:.8, time:.2, onComplete:function():void {glassOverlay.selectedOverlay.visible = false;}}); 
			this.dispatchEvent(new UIEvent(UIEvent.SCROLL_PICKER_ITEM_SELECTED, this));
		}
		
		private function calculateVelocity():Number
		{
			var currentTime:Number = flash.utils.getTimer();
			var velocity:Number;
			
			velocity = (mouseY - _velocityStartPos)/(currentTime - _velocityStartTime);
			
			
			return velocity;
		}
		
		public function refresh(objects:Array):void
		{
			while (scrollerView.numChildren)
			{
				scrollerView.removeChildAt(0);
			}
			
			_pickerValues = objects;
			for (var i:uint = 0; i < _pickerValues.length; i++)
			{
				if (_pickerValues[i] is String)
				{
					var scrollItems:ScrollText = new ScrollText(_pickerValues[i]);
					scrollItems.y = i * 30;
					scrollerView.addChild(scrollItems);
					
				}
			}
			Tweener.addTween(scrollerView, {y:60, time:1, transition:"easeOutBack"});
		}

		public function get selectedValue():String
		{
			return _pickerValues[Math.round(Math.abs((scrollerView.y - SELECTED_HEIGHT) / ITEM_HEIGHT))];
		}
		
		public function get selectedIndex():int
		{
			return Math.round(Math.abs((scrollerView.y - SELECTED_HEIGHT) / ITEM_HEIGHT));
		}
		
		public function set selectedIndex(num:int):void
		{
			scrollerView.y = SELECTED_HEIGHT - (ITEM_HEIGHT*num);
		}
		
		public function set selectedValue(val:String):void
		{
			if (_pickerValues.indexOf(val) < 0)
			{
				// inappropriate value
			}
			else
			{
				// set to index of selected value
				scrollerView.y =  SELECTED_HEIGHT - (ITEM_HEIGHT*_pickerValues.indexOf(val));
			}
		}
		
		
	}
}