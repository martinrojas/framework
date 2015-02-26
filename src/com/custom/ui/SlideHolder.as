package com.custom.ui
{
	import com.framework.control.Controller;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	
	public class SlideHolder extends MovieClip
	{
		
		private  var _slider:slideHolder;
		private  var slides:Array = [];
		
		protected var _width:int;
		protected var _height:int;
		protected var _prevMousePos:Number;
		protected var _velocityStartPos:Number;
		protected var _velocityStartTime:int;
		
		public function SlideHolder()
		{
			super();
			_slider = new slideHolder();
			this.addChild(_slider);
			
			var energySlide:BitmapObj = new BitmapObj ("mainAssets/marketing/1_how.png", "energy");
			slides.push(energySlide);
			var euSlide:BitmapObj = new BitmapObj ("mainAssets/marketing/2_now.png", "eu");
			slides.push(euSlide);
			var howSlide:BitmapObj = new BitmapObj ("mainAssets/marketing/3_partner.png", "how");
			slides.push(howSlide);
			var nowSlide:BitmapObj = new BitmapObj ("mainAssets/marketing/4_eu.png", "now");
			slides.push(nowSlide);
			var partnerSlide:BitmapObj = new BitmapObj ("mainAssets/marketing/5_energy.png", "partner");
			slides.push(partnerSlide);
			var whySlide:BitmapObj = new BitmapObj ("mainAssets/marketing/6_why.png", "why");
			slides.push(whySlide);
			
			for ( var i:int = 0; i < slides.length; i++)
			{
				_slider.scoller.addChild(slides[i]);
				slides[i].x = ( 2048 * i ) + 44;
				
			}
			
			_width = this.width;
			_height = this.height;
			_slider.scoller.x = 0;
			_slider.scoller.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				
			createDots(0);
				
		}
		
		
		private function onMouseDown($evt:MouseEvent):void
		{
			if (TweenMax.isTweening(_slider.scoller))
			{
				TweenMax.killAll(true);
			}
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			_velocityStartTime = getTimer();
			_velocityStartPos = mouseX;
			_prevMousePos = mouseX;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var xPosDiff:Number = mouseX - _prevMousePos;
			_prevMousePos = mouseX;
			_slider.scoller.x += xPosDiff;
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
			
			
			if (_slider.scoller.x > 0)
			{
				TweenMax.to(_slider.scoller, .5, {x:0});
			}
			else if (_slider.scoller.x < -((slides.length - 1) * 2048))
			{
				TweenMax.to(_slider.scoller, .5, {x:-((slides.length - 1) * 2048)});
			}
			else
			{
				var tweenEndPosition:Number;
				tweenEndPosition = (velocity * 95) + _slider.scoller.x;
				Controller.logger.log(this + " Tween end = " + tweenEndPosition + " velocity = " + velocity);
				if (tweenEndPosition > 44)
				{
					TweenMax.to(_slider.scoller, .5, {x:0});
				}
				else if (_slider.scoller.x < -((slides.length - 1) * 2048))
				{
					TweenMax.to(_slider.scoller, .5, {x:-((slides.length - 1) * 2048)});
				}
				else
				{
					var pos:int = Math.ceil(tweenEndPosition / 1024);
//					Controller.logger.log(pos.toString());
					if((pos % 2) == 0)
					{
						TweenMax.to(_slider.scoller, .5, {x:(pos * 1024)});
						createDots(Math.abs(pos )/ 2);
					}
					else
					{
						TweenMax.to(_slider.scoller, .5, {x:((pos - 1) * 1024)});
						createDots(Math.abs(pos-1)/ 2);
					}
					
				}							
			}
			
		}
		
		private function calculateVelocity():Number
		{
			var currentTime:Number = flash.utils.getTimer();
			var velocity:Number;
			
			velocity = (mouseX - _velocityStartPos)/(currentTime - _velocityStartTime);
			
			return velocity;
		}
		
		private function createDots($select:int):void
		{
			var tempX:int = (2048 - (slides.length * 40)) / 2;
			
			Controller.logger.log($select.toString() + " : " + tempX.toString());
//			while (_slider.navHolder.numChildren)
//			{
//				_slider.navHolder.removeChildAt(0);
//			}
			_slider.navHolder.graphics.clear();
			for (var i:int = 0; i < slides.length ; i++)
			{
				if($select == i)
				{
					_slider.navHolder.graphics.beginFill(0x333333);
					_slider.navHolder.graphics.drawCircle(tempX + 10, 0 , 10);
					_slider.navHolder.graphics.endFill();
				}
				else
				{
					_slider.navHolder.graphics.beginFill(0x999999);
					_slider.navHolder.graphics.drawCircle(tempX + 10, 0 , 10);
					_slider.navHolder.graphics.endFill();
				}
				tempX += 40;
			}
			
		}
		
	}
}