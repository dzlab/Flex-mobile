/**
 *  Author: Christophe Coenraets, http://coenraets.org
 */
package events
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class SoundFileEvent extends Event
	{
		public static const SELECT:String = "selectVoiceNote";
		public static const DELETE:String = "deleteItem";
		public static const MENU:String = "soundFileMenu";
	
		public var file:File;
		public var soundClip:ByteArray;
		
	
		public function SoundFileEvent(type:String, file:File, bubbles:Boolean = true, cancelable:Boolean = true)
   		{
			super(type, bubbles, cancelable);
   			this.file = file;
		}
	}
}