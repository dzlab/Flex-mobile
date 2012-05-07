package domain
{
	import flash.events.EventDispatcher;

	[RemoteClass(alias="Note")]
	[Bindable]
	public class Note extends EventDispatcher
	{
		public var modificationDate:Date = new Date();
		public var text:String;
		public var noteId:int;
		
		public function Note()
		{
		}
	}
}