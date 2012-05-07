package renderers
{
	import spark.components.Image;
	import spark.components.LabelItemRenderer;
	
	public class CheckboxItemRenderer extends LabelItemRenderer
	{
				
		[Embed(source="assets/check.png")]
		private static const check:Class;
		
		private var checkImage:Image;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			checkImage = new Image();
			checkImage.source = check;
			checkImage.visible = false;
			addChild(checkImage);
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			//super.drawBackground(unscaledWidth, unscaledHeight);
			graphics.beginFill(0xFFFFFF);
			graphics.lineStyle(1, 0x999999);
			graphics.drawRect(-1, -1, unscaledWidth +2, unscaledHeight +2);
			graphics.endFill();
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			if(selected)
			{
				checkImage.visible = true;
				setElementSize(checkImage, 30, 30);
				setElementPosition(checkImage, unscaledWidth - checkImage.width, (unscaledHeight - checkImage.height) / 2);
			}else
				checkImage.visible = false;
		}
		
	}
}