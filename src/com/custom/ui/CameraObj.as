package com.custom.ui 
{
    import com.controllerFramework.control.Controller;
    
    import flash.display.*;
    import flash.events.*;
    import flash.media.Camera;
    import flash.media.Video;
    import flash.net.*;

	public class CameraObj extends MovieClip {
		
		private var _video:Video
		private var _camera:Camera;
		private var _cameraIndex:String;
		
		public function CameraObj():void 
		{
			super();
		}
		
		/**
		 * Sets camera variable with specified parameters.  Create a new {@link Video} object and attaches the camera feed. Empties any values
		 * contained in imageData and mirroredImageData variables.
		 * @param width
		 * @param height
		 * @param capture
		 * @param mode
		 * @return  
		 */		
		public function setCameraMode(width:uint, height:uint, cameraFeed:String=''):void 
		{
			_cameraIndex = cameraFeed;
			if(_cameraIndex == '') {
				_camera = Camera.getCamera();
			}
			else{
			 	_camera = Camera.getCamera(_cameraIndex);
			}
		 	var bandwidth:int = 0; 
			var quality:int = 75;
			_camera.setQuality(bandwidth, quality);
			_camera.setMode(width, height, 20, false);


			_video = new Video(_camera.width, _camera.height);
			_video.attachCamera(_camera);
			_video.scaleX = -1;
			_video.x = _video.x + _video.width;
			addChild(_video);
		}
		
		public function dispose():void 
		{
			while (this.numChildren)
            {
                this.removeChildAt(0);
            }
			
			_video = null;
			_camera = null;
		}
	}
}