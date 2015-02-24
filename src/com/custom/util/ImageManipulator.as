package com.custom.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * Utility for manipulations of images.
	 * 
	 * @author jcarpe
	 */
	public class ImageManipulator
	{
		/**
		 * Crops a Display Object and returns the cropped bitmap.
		 * 
		 * @param _x
		 * X value to begin crop
		 * 
		 * @param _y
		 * Y value to begin crop
		 * 
		 * @param _width
		 * Width value of the crop
		 * 
		 * @param _height
		 * Height value of the crop
		 * 
		 * @param _stage
		 * The stage that the DisplayObject to be cropped is on
		 * 
		 * @param displayObject
		 * The Display Object to be cropped
		 * 
		 * @return croppedBitmap
		 * The cropped bitmap instance
		 */
		public static function crop( _x:Number, _y:Number, _width:Number, _height:Number, _stage:Stage, displayObject:DisplayObject = null ) : Bitmap
		{
			var cropArea:Rectangle = new Rectangle( 0, 0, _width, _height );
			var croppedBitmap:Bitmap = new Bitmap( new BitmapData( _width, _height ), PixelSnapping.ALWAYS, true );
			croppedBitmap.bitmapData.draw( ( displayObject != null ) ? displayObject : _stage, new Matrix(1, 0, 0, 1, -_x, -_y) , null, null, cropArea, true );
			return croppedBitmap;
		}
	}
}