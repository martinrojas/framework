package com.custom.ui
{	
	import com.controllerFramework.control.Controller;
	import com.caurina.transitions.*;
	//TODO change to greensock
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;

	public class ScrollView extends MovieClip
	{
		private static const SCROLL_INDICATOR_THICKNESS:uint = 12;
		private static const SCROLL_BUTTON_SCROLLING_YPOS_DIFF:uint = 25;
		private static const SCROLL_BUTTON_SCROLLING_TWEEN_TIME:Number = .1;
		
		protected var _mask:ShapeObj;
		protected var _orientation:String;
		protected var _width:int;
		protected var _height:int;
		protected var _contentInset:Object;
		protected var _hitArea:ShapeObj;
		protected var _scrollerIndicatorMask:ShapeObj;
		protected var _isScrollable:Boolean;
		
		protected var _prevMousePos:Number;
		protected var _velocityStartPos:Number;
		protected var _velocityStartTime:int;
		
		protected var _container:MovieClip;
		
		protected var _showScrollIndicator:Boolean;
		protected var _scrollerIndicator:ShapeObj;
		
		protected var _showVerticalScrollButtons:Boolean;
		protected var _upArrow:UpArrow;
		protected var _downArrow:DownArrow;
		protected var _upArrowPosDiff:Point;
		protected var _downArrowPosDiff:Point;
		protected var _scrollerIndicatorReferenceHeight:int;
		protected var _scrollerIndicatorReferenceOriginY:int;
		
		public function ScrollView(width:int, height:int, orientation:String, showScrollIndicator:Boolean = false, showVerticalScrollButtons:Boolean = false)
		{
			super();
			_hitArea = new ShapeObj(width, height, 0xFFFFFF, 0, 0);
			super.addChild(_hitArea);
			_container = new MovieClip();
			super.addChild(_container);
			
			_mask = new ShapeObj(width, height, 0x000000);
			super.addChild(_mask);
			_container.mask = _mask;			
			
			_width = width;
			_height = height;
			_orientation = orientation;
			_showScrollIndicator = showScrollIndicator;
			_showVerticalScrollButtons = showVerticalScrollButtons;
			
			_upArrow = new UpArrow();
			_downArrow = new DownArrow();
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			_upArrow.addEventListener(TouchEvent.TOUCH_BEGIN, onUpButton);
			_downArrow.addEventListener(TouchEvent.TOUCH_BEGIN, onDownButton);
			_upArrow.x = _width - _upArrow.width;
			_upArrow.y = 0;
			_downArrow.x = _width - _downArrow.width;
			_downArrow.y = _height - _downArrow.height;
			_upArrowPosDiff = new Point();
			_downArrowPosDiff = new Point();
			
			this.contentInset = {top:0, right:0, bottom:0, left:0};
		}

		override public function get width() : Number
		{
			return _width;
		}
		
		override public function get height() : Number
		{
			return _height;
		}
		
		public function get contentInset():Object
		{
			return this._contentInset;
		}
		
		public function set contentInset(obj:Object):void
		{
			this._contentInset = obj;
		}
		
		public function changeDownArrowPosition(xDiff:int = 0, yDiff:int =0):void
		{
			_downArrow.x += xDiff;
			_downArrow.y += yDiff;
			_downArrowPosDiff = new Point(xDiff, yDiff);
		}
		
		public function changeUpArrowPosition(xDiff:int = 0, yDiff:int =0):void
		{
			_upArrow.x += xDiff;
			_upArrow.y += yDiff;
			_upArrowPosDiff = new Point(xDiff, yDiff);
		}
		
		public function get contentOffset():Point
		{
			var containerPoint:Point = new Point(_container.x, _container.y);
			return containerPoint;
		}
		
		public function disableUserInteraction() : void
		{
			if (this.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			if (this.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			if (stage)
			{
				if (stage.hasEventListener(MouseEvent.MOUSE_UP))
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
			}
		}
		
		public function init():void
		{
			isContentScrollable();
			
			if (_upArrow && super.contains(_upArrow))
			{
				super.removeChild(_upArrow);
			}
			if (_downArrow && super.contains(_downArrow))
			{
				super.removeChild(_downArrow);
			}
			if (_scrollerIndicatorMask && super.contains(_scrollerIndicatorMask))
			{
				super.removeChild(_scrollerIndicatorMask);
			}
			if (_scrollerIndicator && super.contains(_scrollerIndicator))
			{
				super.removeChild(_scrollerIndicator);
			}
			
			if (_orientation == UIConstants.SCROLL_VIEW_HORIZONTAL && _container.width > _width)
			{
				if (!this.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				}
				
				if (_showScrollIndicator)
				{
					_scrollerIndicator = new ShapeObj(_width * (_width / _container.width), SCROLL_INDICATOR_THICKNESS, 0xdcea7c, 15, 1, "roundRect");					
//					_scrollerIndicator.y = _height - _scrollerIndicator.height*1.5 + _scrollIndicatorYDiff;
//					_scrollerIndicatorMask = new ShapeObj(_width, _height + _scrollIndicatorYDiff, 0x000000);
					_scrollerIndicator.mask = _scrollerIndicatorMask;
					super.addChild(_scrollerIndicatorMask);
					super.addChild(_scrollerIndicator);
//					_mask.height= _height = height - _scrollerIndicator.height;
				}
			}
			else if (_orientation == UIConstants.SCROLL_VIEW_VERTICAL && _container.height > _height)
			{
				if (!this.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				}
				
				if (_showScrollIndicator)
				{
					_scrollerIndicatorReferenceHeight = _downArrow.y - (_upArrow.y + _upArrow.height);
					_scrollerIndicatorReferenceOriginY = _upArrow.y + _upArrow.height;
					_scrollerIndicator = new ShapeObj(SCROLL_INDICATOR_THICKNESS, _scrollerIndicatorReferenceHeight * (_scrollerIndicatorReferenceHeight / _container.height), 0xdcea7c, 15, 1, "roundRect");
					_scrollerIndicator.x = _upArrow.x + _upArrow.width/2 - SCROLL_INDICATOR_THICKNESS/2;
					_scrollerIndicator.y = _upArrow.y + _upArrow.height;
					_scrollerIndicatorMask = new ShapeObj(_upArrow.width, _downArrow.y - (_upArrow.y + _upArrow.height), 0x000000);
					_scrollerIndicatorMask.x = _upArrow.x;
					_scrollerIndicatorMask.y = _upArrow.y + _upArrow.height;
					_scrollerIndicator.mask = _scrollerIndicatorMask;
					
					super.addChild(_scrollerIndicatorMask);
					super.addChild(_scrollerIndicator);
//					_mask.width = _width = width - _scrollerIndicator.width;
				}
				
				if (_showVerticalScrollButtons)
				{
					super.addChild(_upArrow);
					super.addChild(_downArrow);
				}
			}   
			else
			{
				if (this.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				}
			}
		}
		
		public function isContentScrollable():void
		{
			if (_container.width > _width || _container.height > _height)
			{
				_isScrollable = true;
			}
			else
			{
				_isScrollable = false;
			}
		}
		
		public function reSize (width:Number, height:Number):void
		{
			_mask.width = _width = width;
			_mask.height= _height = height;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{	
			if (Tweener.isTweening(_container))
			{
//				Tweener.removeAllTweens();
				Tweener.pauseTweens(_container);
			}
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

			_velocityStartTime = flash.utils.getTimer();
			
			if (_orientation == UIConstants.SCROLL_VIEW_HORIZONTAL)
			{
				_velocityStartPos = mouseX;
				_prevMousePos = mouseX;
			}
			else if (_orientation == UIConstants.SCROLL_VIEW_VERTICAL)
			{
				_velocityStartPos = mouseY;
				_prevMousePos = mouseY;
			}
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (_orientation == UIConstants.SCROLL_VIEW_HORIZONTAL)
			{
				var xPosDiff:Number = mouseX - _prevMousePos;
				_prevMousePos = mouseX;
				_container.x += xPosDiff;
				if (_showScrollIndicator)
				{
					_scrollerIndicator.x += - xPosDiff * (_width / _container.width);
				}
			}
			else if (_orientation == UIConstants.SCROLL_VIEW_VERTICAL)
			{
				var yPosDiff:Number = mouseY - _prevMousePos;
				_prevMousePos = mouseY;
				_container.y += yPosDiff;
				if (_showScrollIndicator)
				{
					_scrollerIndicator.y += - yPosDiff * (_scrollerIndicatorReferenceHeight / _container.height);
				}
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{			
			if (this.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			if (stage)
			{
				if (stage.hasEventListener(MouseEvent.MOUSE_UP))
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
			}
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			var velocity:Number = this.calculateVelocity();
			
			if (!isNaN(velocity))
			{
				// left edge
				if (_orientation == UIConstants.SCROLL_VIEW_HORIZONTAL && _container.x > this.minimumContentPositionX)
				{
					Tweener.addTween(_container, {x:this.contentInset.left, time:1, transition:"easeOutCubic"});
					if (_showScrollIndicator) Tweener.addTween(_scrollerIndicator, {x:0, time:1, transition:"easeOutCubic"});
				}
				// top edge
				else if (_orientation == UIConstants.SCROLL_VIEW_VERTICAL && _container.y > this.minimumContentPositionY)
				{
					Tweener.addTween(_container, {y:this.minimumContentPositionY, time:1, transition:"easeOutCubic"});
					Tweener.addTween(_scrollerIndicator, {y:_scrollerIndicatorReferenceOriginY, time:1, transition:"easeOutCubic"});
				}
				// right edge
				else if (_orientation == UIConstants.SCROLL_VIEW_HORIZONTAL && _container.x < this.maximumContentPositionX)
				{
					Tweener.addTween(_container, {x:this.maximumContentPositionX, time:1, transition:"easeOutCubic"});
					if (_showScrollIndicator) Tweener.addTween(_scrollerIndicator, {x:_width-_scrollerIndicator.width, time:1, transition:"easeOutCubic"});
				}
				// bottom edge
				else if (_orientation == UIConstants.SCROLL_VIEW_VERTICAL && _container.y < this.maximumContentPositionY)
				{
					Tweener.addTween(_container, {y:this.maximumContentPositionY, time:1, transition:"easeOutCubic"});
					if (_showScrollIndicator) Tweener.addTween(_scrollerIndicator, {y:_scrollerIndicatorReferenceHeight-_scrollerIndicator.height, time:1, transition:"easeOutCubic"});
				}		
				else
				{
					var tweenEndPosition:Number;
					if (_orientation == UIConstants.SCROLL_VIEW_HORIZONTAL)
					{
						tweenEndPosition = (velocity * 750) + _container.x;
						
						if (tweenEndPosition > this.minimumContentPositionX)
						{
							Tweener.addTween(_container, {x:this.minimumContentPositionX, time:1, transition:"easeOutBack"});
							if (_showScrollIndicator) Tweener.addTween(_scrollerIndicator, {x:0, time:1, transition:"easeOutCubic"});
						}
						else if (tweenEndPosition < this.maximumContentPositionX)
						{
							Tweener.addTween(_container, {x:this.maximumContentPositionX, time:1, transition:"easeOutBack"});
							if (_showScrollIndicator) Tweener.addTween(_scrollerIndicator, {x:_width-_scrollerIndicator.width, time:1, transition:"easeOutCubic"});
						}
						else
						{
							Tweener.addTween(_container, {x:tweenEndPosition, time:1, transition:"easeOutCubic"});
							if (_showScrollIndicator) Tweener.addTween(_scrollerIndicator, {x:-(tweenEndPosition*(_width / _container.width)), time:1, transition:"easeOutCubic"});
						}
					}
					else if (_orientation == UIConstants.SCROLL_VIEW_VERTICAL)
					{
						tweenEndPosition = (velocity *500) + _container.y;
	 					
						if (tweenEndPosition > this.minimumContentPositionY)
						{
							Tweener.addTween(_container, {y:this.minimumContentPositionY, time:1, transition:"easeOutBack"});
							if (_showScrollIndicator) Tweener.addTween(_scrollerIndicator, {y:_scrollerIndicatorReferenceOriginY, time:1, transition:"easeOutCubic"});
						}
						else if (tweenEndPosition < this.maximumContentPositionY)
						{
							Tweener.addTween(_container, {y:this.maximumContentPositionY, time:1, transition:"easeOutBack"});
							if (_showScrollIndicator) Tweener.addTween(_scrollerIndicator, {y:_scrollerIndicatorReferenceHeight-_scrollerIndicator.height, time:1, transition:"easeOutCubic"});
						}
						else
						{
							Tweener.addTween(_container, {y:tweenEndPosition, time:1, transition:"easeOutCubic"});
							if (_showScrollIndicator)Tweener.addTween(_scrollerIndicator, {y:-(tweenEndPosition*(_scrollerIndicatorReferenceHeight / _container.height)), time:1, transition:"easeOutCubic"});
						}
					}
				}
			}
		}
		
		private function calculateVelocity():Number
		{
			var currentTime:Number = flash.utils.getTimer();
			var velocity:Number;
			
			if (_orientation == UIConstants.SCROLL_VIEW_HORIZONTAL)
			{
				velocity = (mouseX - _velocityStartPos)/(currentTime - _velocityStartTime);
			}
			else if (_orientation == UIConstants.SCROLL_VIEW_VERTICAL)
			{
				velocity = (mouseY - _velocityStartPos)/(currentTime - _velocityStartTime);
			}
 			return velocity;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			_container.addChild(child);
			return child;
		}
		
		public function removeAllScrollViewContent():void
		{
//			Tweener.removeAllTweens();
			_container.x = _container.y = 0;
			while(_container.numChildren)
			{
				_container.removeChildAt(0);	
			}
			
			if (_scrollerIndicatorMask && super.contains(_scrollerIndicatorMask))
			{
				super.removeChild(_scrollerIndicatorMask);
			}
			if (_scrollerIndicator && super.contains(_scrollerIndicator))
			{
				super.removeChild(_scrollerIndicator);
			}
		}
		
		public function set yContainer(num:uint):void
		{
			_container.y = num;
		}
		
		public function resetPosition(removeTweens:Boolean = true, xPos:int = 0, yPos:int = 0):void
		{
			if (removeTweens)
			{
				Tweener.removeAllTweens();
			}
			_container.y = yPos;
			_container.x = xPos;
		}
		
		public function tweenToDisplayObjectPosition(position:Number,tweenTime:Number = .5,tweenDelay:Number = 0, useRawPositions:Boolean = false):void
		{
			if (_isScrollable)
			{
				if (useRawPositions == false)
				{
					if (_orientation == UIConstants.SCROLL_VIEW_HORIZONTAL && position > _width/2)
					{
						Tweener.addTween(_container, {x:position - _width/2,  time:tweenTime, delay:tweenDelay, onComplete:dispatchCompleteEvent});
					}
					else if (_orientation == UIConstants.SCROLL_VIEW_VERTICAL)
					{
						Tweener.addTween(_container, {y:-position + _height/2,  time:tweenTime, delay:tweenDelay, onComplete:dispatchCompleteEvent});
					}
				}
				else
				{
					if (_orientation == UIConstants.SCROLL_VIEW_HORIZONTAL)
					{
						Tweener.addTween(_container, {x:position,  time:tweenTime, delay:tweenDelay});
					}
					else if (_orientation == UIConstants.SCROLL_VIEW_VERTICAL)
					{
						Tweener.addTween(_container, {y:-position,  time:tweenTime, delay:tweenDelay});
					}
				}	
			}
		}

		public function tweenToBottom(tweenTime:Number = .5,tweenDelay:Number = 0):void
		{
			if (_isScrollable)
			{
				Tweener.addTween(_container, {y:-_height/3,  time:tweenTime, delay:tweenDelay, onComplete:dispatchCompleteEvent});
			}
		}
		
		private function dispatchCompleteEvent():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function get minimumContentPositionX() : Number
		{
			return this.contentInset.left;
		}
		
		private function get maximumContentPositionX() : Number
		{
			return (_width - _container.width - this.contentInset.right);
		}
		
		private function get minimumContentPositionY() : Number
		{
			return this.contentInset.top;
		}
		
		private function get maximumContentPositionY() : Number
		{
			return (_height - _container.height - this.contentInset.bottom);
		}
		
		
		
		/********************************************/
		/***        SCROLL BUTTON HANDLERS        ***/
		/********************************************/
		
		private function onDownButton(e:Event):void
		{
			_downArrow.removeEventListener(TouchEvent.TOUCH_BEGIN, onDownButton);
			this.addEventListener(Event.ENTER_FRAME,holdDownButton);
			_downArrow.addEventListener(TouchEvent.TOUCH_END, stopDownScroller);
		}
		
		private function holdDownButton(e:Event):void
		{
			if (!Tweener.isTweening(_container))
			{
				if (_container.y - SCROLL_BUTTON_SCROLLING_YPOS_DIFF >= -(_container.height - _height))
				{
					Tweener.addTween(_container, {y:_container.y - SCROLL_BUTTON_SCROLLING_YPOS_DIFF, time:SCROLL_BUTTON_SCROLLING_TWEEN_TIME});
					if (_scrollerIndicator.y + SCROLL_BUTTON_SCROLLING_YPOS_DIFF * (_scrollerIndicatorReferenceHeight / _container.height) < _scrollerIndicatorReferenceHeight - _scrollerIndicator.height)
					{
						Tweener.addTween(_scrollerIndicator, {y:_scrollerIndicator.y + SCROLL_BUTTON_SCROLLING_YPOS_DIFF * (_scrollerIndicatorReferenceHeight / _container.height), time:SCROLL_BUTTON_SCROLLING_TWEEN_TIME});
					}
				}
				else
				{
					Tweener.addTween(_container, {y:-(_container.height - _height), time:SCROLL_BUTTON_SCROLLING_TWEEN_TIME});
					Tweener.addTween(_scrollerIndicator, {y:_scrollerIndicatorReferenceHeight - _scrollerIndicator.height, time:SCROLL_BUTTON_SCROLLING_TWEEN_TIME});
				}
			}
		}
		
		private function stopDownScroller(e:Event):void
		{
			if (this.hasEventListener(Event.ENTER_FRAME))
			{
				this.removeEventListener(Event.ENTER_FRAME,holdDownButton);
			}
			if (_downArrow.hasEventListener(TouchEvent.TOUCH_END))
			{
				_downArrow.removeEventListener(TouchEvent.TOUCH_END, onDownButton);
			}
			_downArrow.addEventListener(TouchEvent.TOUCH_BEGIN, onDownButton);
		}
		
		public function onUpButton(e:Event):void
		{
			_upArrow.removeEventListener(TouchEvent.TOUCH_BEGIN, onUpButton);
			this.addEventListener(Event.ENTER_FRAME,holdUpButton);
			_upArrow.addEventListener(TouchEvent.TOUCH_END, stopUpScroller);
		}
		
		private function holdUpButton(e:Event):void
		{
			if (!Tweener.isTweening(_container))
			{
				if (_container.y + SCROLL_BUTTON_SCROLLING_YPOS_DIFF <= 0)
				{
					Tweener.addTween(_container, {y:_container.y + SCROLL_BUTTON_SCROLLING_YPOS_DIFF, time:SCROLL_BUTTON_SCROLLING_TWEEN_TIME});
					if (_scrollerIndicator.y - SCROLL_BUTTON_SCROLLING_YPOS_DIFF * (_scrollerIndicatorReferenceHeight / _container.height) > 0)
					{
						Tweener.addTween(_scrollerIndicator, {y:_scrollerIndicator.y - SCROLL_BUTTON_SCROLLING_YPOS_DIFF * (_scrollerIndicatorReferenceHeight / _container.height), time:SCROLL_BUTTON_SCROLLING_TWEEN_TIME});
					}
				}
				else
				{
					Tweener.addTween(_container, {y:0, time:SCROLL_BUTTON_SCROLLING_TWEEN_TIME});
					Tweener.addTween(_scrollerIndicator, {y:_scrollerIndicatorReferenceOriginY, time:SCROLL_BUTTON_SCROLLING_TWEEN_TIME});
				}
			}
		}
		
		private function stopUpScroller(e:Event):void
		{
			if (this.hasEventListener(Event.ENTER_FRAME))
			{
				this.removeEventListener(Event.ENTER_FRAME,holdUpButton);
			}
			if (_upArrow.hasEventListener(TouchEvent.TOUCH_OUT))
			{
				_upArrow.removeEventListener(TouchEvent.TOUCH_OUT, stopUpScroller);
			}
			_upArrow.addEventListener(TouchEvent.TOUCH_BEGIN, onUpButton);
		} 
		
		/********************************************/
		/***               DISPOSE                ***/
		/********************************************/
		
		public function dispose():void
		{
			if (this.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			if (this.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			if (stage)
			{
				if (stage.hasEventListener(MouseEvent.MOUSE_UP))
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
			}
			if (_upArrow.hasEventListener(TouchEvent.TOUCH_BEGIN))
			{
				_upArrow.removeEventListener(TouchEvent.TOUCH_BEGIN, onUpButton);
			}
			if (_upArrow.hasEventListener(TouchEvent.TOUCH_BEGIN))
			{
				_upArrow.removeEventListener(TouchEvent.TOUCH_BEGIN, onUpButton);
			}
			if (_downArrow.hasEventListener(TouchEvent.TOUCH_BEGIN))
			{
				_downArrow.removeEventListener(TouchEvent.TOUCH_BEGIN, onDownButton);
			}
			if (_downArrow.hasEventListener(TouchEvent.TOUCH_END))
			{
				_downArrow.removeEventListener(TouchEvent.TOUCH_END, stopDownScroller);
			}
			if (this.hasEventListener(Event.ENTER_FRAME))
			{
				this.removeEventListener(Event.ENTER_FRAME,holdDownButton);
				this.removeEventListener(Event.ENTER_FRAME,holdUpButton);
			}

			while(_container.numChildren)
			{
				_container.removeChildAt(0);	
			}
			while(super.numChildren)
			{
				super.removeChildAt(0);	
			}
		}
	}
}