package skins
{
	import flash.display.DisplayObject;
	
	import mx.core.IVisualElement;
	
	import skins.assets.Button_down;
	import skins.assets.Button_up;
	
	import spark.components.supportClasses.ButtonBase;
	import spark.components.supportClasses.StyleableTextField;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class OptimizedButtonSkin extends MobileSkin
	{
		public function OptimizedButtonSkin()
		{
			super();
		}
		
		
		private var _hostComponent:ButtonBase;

		// Define the getter for _hostComponent
		public function get hostComponent():ButtonBase
		{
			return _hostComponent;
		}
		
		// Define the setter for _hostComponent
		public function set hostComponent(value:ButtonBase):void
		{
			_hostComponent = value;
		}
		
		// Define the label of the button
		public var labelDisplay:StyleableTextField;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			//upSkin = new buttonUpSkin();
			//addChild(upSkin);
			
			labelDisplay = StyleableTextField(createInFontContext(StyleableTextField));
			labelDisplay.styleName = this;
			
			addChild(labelDisplay);
		}
		
		// Called by commitCurrentState ot redraw the background
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.drawBackground(unscaledWidth, unscaledHeight);
			
		}
		
		protected var buttonUpSkin:Class = Button_up;
		protected var buttonDownSkin:Class = Button_down;
		
		private var _border:DisplayObject;
		private var changeFXGSkin:Boolean = false;
		private var borderClass:Class;		
		
		// Called when the state of the button change
		override protected function commitCurrentState():void
		{   
			super.commitCurrentState();
			
			if (currentState == "down")
			{
				borderClass = buttonDownSkin;
				labelDisplay.setStyle("color", 0x666666);
			}
			else
			{
				borderClass = buttonUpSkin;
				labelDisplay.setStyle("color", 0xFFFFFF);
			}
			
			if (!(_border is borderClass))
				changeFXGSkin = true;
			
			// update borderClass and background
			invalidateDisplayList();
		}
		
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{	
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// size the FXG background
			if (changeFXGSkin)
			{
				changeFXGSkin = false;
				
				if (_border)
				{
					removeChild(_border);
					_border = null;
				}
				
				if (borderClass)
				{
					_border = new borderClass();
					addChildAt(_border, 0);
				}
			}
			
			if (_border)
			{
				setElementPosition(_border, 0, 0);
				setElementSize(_border, unscaledWidth, unscaledHeight);
			}
			
			var textW:Number = getElementPreferredWidth(labelDisplay);
			var textH:Number = getElementPreferredHeight(labelDisplay);
			
			setElementPosition(labelDisplay, (unscaledWidth - textW) /2, (unscaledHeight- textH) / 2);
			
		}
		
	}
}