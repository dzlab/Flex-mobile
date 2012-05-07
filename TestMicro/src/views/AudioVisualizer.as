package views
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	
	// Code based on Flex doc: http://livedocs.adobe.com/flex/3/html/help.html?content=Working_with_Sound_14.html
	
	public class AudioVisualizer extends UIComponent
	{
		public const CHANNEL_LENGTH:int = 256;
		
		public var plotHeight:int = 100;
		
		private var bytes:ByteArray = new ByteArray();
		
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			SoundMixer.computeSpectrum(bytes, false, 0);
			
			var g:Graphics = this.graphics;
			
			g.clear();
			g.lineStyle(0, 0x6600CC);
			g.beginFill(0x6600CC);
			g.moveTo(0, plotHeight);
			
			var n:Number = 0;
			
			// left channel
			for (var i:int = 0; i < CHANNEL_LENGTH; i++) 
			{
				n = (bytes.readFloat() * plotHeight);
				g.lineTo(i * 2, plotHeight - n);
			}
			g.lineTo(CHANNEL_LENGTH * 2, plotHeight);
			g.endFill();
			
			// right channel
			g.lineStyle(0, 0xCC0066);
			g.beginFill(0xCC0066, 0.5);
			g.moveTo(CHANNEL_LENGTH * 2, plotHeight);
			
			for (i = CHANNEL_LENGTH; i > 0; i--) 
			{
				n = (bytes.readFloat() * plotHeight);
				g.lineTo(i * 2, plotHeight - n);
			}
			g.lineTo(0, plotHeight);
			g.endFill();
		}
		
	}
}