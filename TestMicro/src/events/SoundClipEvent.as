/**
 *  Author: Christophe Coenraets, http://coenraets.org
 */
package events
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class SoundClipEvent extends Event
	{
		public static const PLAYING_END:String = "playingEnd";
		public static const RECORDING_END:String = "recordingEnd";
	
		public var soundClip:ByteArray;
		
	
		public function SoundClipEvent(type:String, soundClip:ByteArray = null, bubbles:Boolean = true, cancelable:Boolean = true)
   		{
			super(type, bubbles, cancelable);
   			this.soundClip = soundClip;
		}
	}
}