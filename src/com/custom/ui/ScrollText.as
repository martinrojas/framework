package com.custom.ui
{
	import flash.display.MovieClip;
	import flash.text.TextField;

	[Embed(source="assets/ScrollPicker.swf", symbol="ScrollText")]
	
	public class ScrollText extends MovieClip
	{
		public var label:TextField;
		
		public function ScrollText(text:String = "N / A")
		{
			label.htmlText = text;
		}
	}
}