package com.custom.ui
{
	import flash.display.MovieClip;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.elements.VideoElement;
	import org.osmf.media.URLResource;
	import org.osmf.utils.URL;
	
	public class multipleVideoPlayer extends MovieClip
	{
		
		
		////////////////////////////////////////////////////
		//DECLARATIONS
		////////////////////////////////////////////////////
		
		//URI of the media
		public static const PROGRESSIVE_PATH:String = "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
		public static const STREAMING_PATH:String = "rtmp://cp67126.edgefcs.net/ondemand/mediapm/osmf/content/test/akamai_10_year_f8_512K";
		public static const STREAMING_MP4_PATH:String = "rtmp://cp67126.edgefcs.net/ondemand/mp4:mediapm/ovp/content/demo/video/elephants_dream/elephants_dream_768x428_24.0fps_408kbps.mp4";
		public static const LOCAL_SWF:String = "assets/swf_banner.swf";
		public static const DYNAMIC_STREAMING:String = "http://mediapm.edgesuite.net/osmf/content/test/manifest-files/dynamic_Streaming.f4m";
		
		public var player:MediaPlayer;
		public var container:MediaContainer;
		public var mediaFactory:DefaultMediaFactory;
		
		
		public function multipleVideoPlayer($path:String)
		{
			super();
			initPlayer($path);
		}
		
		
		protected function initPlayer($path:String):void
		{
			//the pointer to the media
			var resource:URLResource = new URLResource($path);
			
			// Create a mediafactory instance
			mediaFactory = new DefaultMediaFactory();
			
			//creates and sets the MediaElement (generic) with a resource and path
			var element:MediaElement = mediaFactory.createMediaElement( resource );
			
			//the simplified api controller for media
			player = new MediaPlayer( element );
			
			//the container (sprite) for managing display and layout
			container = new MediaContainer();
			container.addMediaElement( element );
			container.width = 1024;
			container.height = 700;
			
			//Adds the container to the stage
			this.addChild( container );
		}
	}
}