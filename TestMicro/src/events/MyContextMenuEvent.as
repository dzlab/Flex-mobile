/**
 *  Author: Christophe Coenraets, http://coenraets.org
 */
package events
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class MyContextMenuEvent extends Event
	{
		public static const DELETE:String = "deleteItem";
		public static const EMAIL:String = "email";
		public static const MENU_CLOSE:String = "menuClose";
	
		public var file:File;
		public var soundClip:ByteArray;
		
	
		public function MyContextMenuEvent(type:String, file:File = null, bubbles:Boolean = true, cancelable:Boolean = true)
   		{
			super(type, bubbles, cancelable);
   			this.file = file;
		}
	}
}