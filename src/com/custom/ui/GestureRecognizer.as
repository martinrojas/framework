package com.custom.ui
{
	import com.controllerFramework.control.Controller;
	import com.controllerFramework.events.ApplicationControllerEvent;
	import com.caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;
	
	public class GestureRecognizer
	{
		private var _originalXPos:uint;
		private var _originalYPos:uint;
		private var _originalWidth:uint;
		private var _originalHeight:uint;
		private var _originalRotation:Number;
		
		private var _displayObject:MovieClip;
		
		public function GestureRecognizer(object:MovieClip)
		{
			Controller.logger.log(this, "Initializing GestureRecognizer");
			_displayObject = object;
			
			// set multitouch input mode
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			// set object array and positions
			_originalXPos = _displayObject.x;
			_originalYPos = _displayObject.y;
			_originalWidth = _displayObject.width;
			_originalHeight = _displayObject.height;
			_originalRotation = _displayObject.rotation;
			
			// display object
			_displayObject.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom); // zoom / pinch
			_displayObject.addEventListener(MouseEvent.MOUSE_DOWN, onDrag); // drag
			_displayObject.addEventListener(MouseEvent.MOUSE_UP, onDrag);
			_displayObject.addEventListener(TransformGestureEvent.GESTURE_ROTATE,onRotate); // rotate
		}
		
		/********************************************/
		/***         ZOOM/PINCH HANDLERS          ***/
		/********************************************/
		
		/**
		 * onZoom - Handles resize interactions with specified objects in sceneObjects array. Utilizes constrainArea function to cap object size to a max of 150% of it's intial value and min of 75% 
		 * @param e - Event specifies the phase and target
		 * 
		 */		
		private function onZoom(e:TransformGestureEvent):void
		{
			Controller.logger.log(this, "Zoom Gesture activated e.scaleX: " + e.scaleX + " e.scaleY: " + e.scaleY );
//			var scaleMultiplier:Number = (e.scaleX + e.scaleY)/2;
			if (e.phase == "update")
			{
				_displayObject.scaleX *= e.scaleX;
				_displayObject.scaleY *= e.scaleY;
				_displayObject = constrainArea(); // cap area to 150% max / 75% min
			}
			else if (e.phase == "end")
			{
				returnToInitialPosition(); // return to initial size
			}
		}
		
		/**
		 * Constrains a view object to a maximum of 150% of it's current size and a minimum of 75% of it's current size 
		 * @param curObject - object being manipulated
		 * @param existingWidth - original width of object
		 * @param existingHeight - original height of object
		 * @return - returns object with caps if necessary
		 * 
		 */		
		private function constrainArea():MovieClip
		{					
			if (_displayObject.width < _originalWidth*.75 || _displayObject.height < _originalHeight*.75)
			{
				_displayObject.width = _originalWidth*.75;
				_displayObject.height = _originalHeight*.75;
			}
				
			else if (_displayObject.width > _originalWidth*1.5 || _displayObject.height > _originalHeight*1.5)
			{
				_displayObject.width = _originalWidth*1.5;
				_displayObject.height = _originalHeight*1.5;
			}
			return _displayObject;
		}
		
		/********************************************/
		/***             DRAG HANDLERS            ***/
		/********************************************/
		
		/**
		 * onDrag - Handles dragging interactions with scene objects. Utilizes timer to differentiate between a mouse click and drag 
		 * @param e
		 * 
		 */		
		private function onDrag(e:Event):void
		{
			Controller.logger.log(this, "Zoom Gesture activated"+ e.type + " object => " + _displayObject.name);

			switch(e.type){
				case TouchEvent.TOUCH_BEGIN:
				{
//					if(e.eventPhase == EventPhase.AT_TARGET)
//					{
						var boundingBox:Rectangle = new Rectangle(0, 0, 1920, 1080);
						_displayObject.startDrag(false,boundingBox); 
//					}
					break;
				}
				case TouchEvent.TOUCH_END:
				{
//					if(e.eventPhase == EventPhase.AT_TARGET)
//					{
						_displayObject.stopDrag();
						//checkForCollisions(e.target);
						returnToInitialPosition();
//					}
					break;
				}
			}
		}
		
		
		/**
		 * returnToInitialPosition - returns a dragged object to it's initial position in the scene
		 * @param curObject - current object being dragged out of it's initial position
		 * 
		 */		
		private function returnToInitialPosition():void
		{
			Controller.logger.log(this, "ReturnToInitialPosition called - _originalXPos: " + _originalXPos + " _originalYPos: " + _originalYPos);
			Tweener.addTween(_displayObject,{ x:_originalXPos, y:_originalYPos, rotation:0, time:1, width:_originalWidth, height:_originalHeight, transition:"easeMode"});
		}
		
		
		/**
		 * checkForCollisions - Checks final location of dragged object for collisions with other scene objects
		 * @param curObject - Current object being dragged
		 * 
		 */		
		private function checkForCollisions(curObject:*):void
		{
//			var view:EngagementView = EngagementView(view);
//			var currentSceneObjects:Array = new Array(view.discoverButton,view.shopButton,view.helpButton);
//			currentSceneObjects.splice(currentSceneObjects.indexOf(curObject),1);
//			
//			for each (var sceneObject:Object in currentSceneObjects)
//			{
//				if (curObject.hitTestObject(sceneObject))
//				{
//					//TODO: Shift element to original position
//				}
//			}			 
		}
		
		/********************************************/
		/***            ROTATE HANDLERS           ***/
		/********************************************/
		
		private function onRotate(e:TransformGestureEvent):void
		{
			Controller.logger.log("Gesture onRotate called: " + e.phase);
			if(e.phase == "update")
			{
				_displayObject.rotation += e.rotation;
//				rotateAtCenter(_displayObject, e.rotation);
			}
			
			if(e.phase == "end")
			{
				returnToInitialPosition(); 
			}
		}
		
		
		private function rotateAtCenter(curObject:*, rotAmount:Number):void
		{
			var centerPoint:Point=new Point(curObject.x+curObject.width/2, curObject.y+curObject.height/2);
			var transformationMatrix:Matrix = curObject.transform.matrix;
			transformationMatrix.tx -= centerPoint.x;
			transformationMatrix.ty -= centerPoint.y;
			transformationMatrix.rotate(rotAmount*(Math.PI/180));
			transformationMatrix.tx += centerPoint.x;
			transformationMatrix.ty += centerPoint.y;
			curObject.transform.matrix = transformationMatrix;
		}
		
		public function dispose():void
		{
			Controller.logger.log(this, "Dispose called on GestureRecognizer");
			if (_displayObject.hasEventListener(TransformGestureEvent.GESTURE_ZOOM))
			{
				_displayObject.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
			}
			if (_displayObject.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				_displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			}
			if (_displayObject.hasEventListener(MouseEvent.MOUSE_UP))
			{
				_displayObject.removeEventListener(MouseEvent.MOUSE_UP, onDrag);
			}
			if (_displayObject.hasEventListener(TransformGestureEvent.GESTURE_ROTATE))
			{
				_displayObject.removeEventListener(TransformGestureEvent.GESTURE_ROTATE,onRotate);
			}
		}
	}
}