package com.baao.utils
{
	import spark.skins.mobile.ViewNavigatorSkin;
	
	public class ViewNavigatorSkin extends spark.skins.mobile.ViewNavigatorSkin

	
	{
	
		protected var stats:Stats;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			stats = new Stats();
			addChild(stats);
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// TODO Auto Generated method stub
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			stats.x = 0;
			stats.y = 0;
		}
		
	}
	
	
	
}