package com.baao.controls
{
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import mx.core.UIComponent;
	
	public class UIVideo extends UIComponent
	{
		private var _video : Video;
		
		public function get video():Video
		{
			return _video;
		}
		
		/**
		 *  @private
		 *  The default width if none is specified and no width information is
		 *  available from the video.
		 */
		private static const DEFAULT_WIDTH:Number = 320;
		
		/**
		 *  @private
		 *  The default height if none is specified and no height information is
		 *  available from the video.
		 */
		private static const DEFAULT_HEIGHT:Number = 240;
		
		/**
		 *  @private default true
		 */
		private var _maintainAspectRatio:Boolean = true;
		
		[Bindable("maintainAspectRatioChanged")]
		[Inspectable(defaultValue="false")]
		
		/**
		 *  Specifies whether the control should maintain the original aspect ratio
		 *  while resizing the video.
		 *
		 *  @default true
		 */
		public function get maintainAspectRatio():Boolean
		{
			return _maintainAspectRatio;
		}
		
		/**
		 *  @private
		 */
		public function set maintainAspectRatio(value:Boolean):void
		{
			if (_maintainAspectRatio != value)
			{
				_maintainAspectRatio = value;
				
				invalidateSize();
				invalidateDisplayList();
				
				dispatchEvent(new Event("maintainAspectRatioChanged"));
			}
		}
		
		public function UIVideo()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			//default size to 320 x 240
			_video = new Video(DEFAULT_WIDTH, DEFAULT_HEIGHT);
			//addChild(_video);
			addChildAt(_video, 0);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			//UIVideo  size
			setActualSize(unscaledWidth, unscaledHeight);
			
			//wrapped video size and position with ratio
			//video Location
			
			var vx:Number = 0;
			var vy:Number = 0;
			
			// UIVideo Size.
			var w:Number = unscaledWidth;
			var h:Number = unscaledHeight;
			
			// Video size.
			var vw:Number = _video.videoWidth;
			var vh:Number = _video.videoHeight;
			
			if (_maintainAspectRatio && vw > 0 && vh > 0)
			{
				// 'maintainAspectRatio' is true but explicit width and height have
				// also been set.  Try to fit the video in the available space,
				// while maintaining the aspect ratio.
				
				var rw:Number = w / vw;
				var rh:Number = h / vh;
				
				if (rw < rh)
				{
					// Adjust height.
					h = w * vh / vw;
					vy = (unscaledHeight - h) / 2;
				}
				else if (rh < rw)
				{
					// Adjust width.
					w = h * vw / vh;
					vx = (unscaledWidth - w) / 2;
				}
			}	        
			_video.x = vx;
			_video.y = vy;
			_video.width = w;
			_video.height = h;
			
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var vw:Number = _video.videoWidth;
			var vh:Number = _video.videoHeight;
			
			measuredWidth = Math.max(vw, DEFAULT_WIDTH);
			measuredHeight = Math.max(vh, DEFAULT_HEIGHT);
			
			// Determine whether 'width' and 'height' have been set.
			var bExplicitWidth:Boolean = !isNaN(explicitWidth);
			var bExplicitHeight:Boolean = !isNaN(explicitHeight);
			
			// If only one has been set, calculate the other based on aspect ratio.
			if (_maintainAspectRatio && (bExplicitWidth || bExplicitHeight))
			{
				if (bExplicitWidth && !bExplicitHeight && vw > 0)
					measuredHeight = explicitWidth * vh / vw;
				else if (bExplicitHeight && !bExplicitWidth && vh > 0)
					measuredWidth = explicitHeight * vw / vh;
			}
			
			measuredMinWidth = 0;
			measuredMinHeight = 0;
		}
		
		public function attachNetStream(netStream : NetStream) : void 
		{
			_video.attachNetStream(netStream);
		}
		
		public function attachCamera(cam : Camera) : void 
		{
			if (cam != null)
			{
				cam.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
			}
			_video.attachCamera(cam);
		}  
		
		private function activityHandler(event:ActivityEvent):void 
		{
			//first call to activating, we resize and remove the listener
			if (event.activating)
			{
				trace("activating, try to resize to " + _video.videoWidth +" x "+ _video.videoHeight);
				invalidateSize();
				invalidateDisplayList();
				event.target.removeEventListener(ActivityEvent.ACTIVITY, activityHandler);
			}
		} 
		
	}
}

