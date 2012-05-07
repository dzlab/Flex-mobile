package domain
{
	import flash.events.EventDispatcher;
	
	[RemoteClass(alias="Note")]
	[Bindable]
	public class Contact extends EventDispatcher
	{
		public var firstname:String;
		public var lastname:String;
		public var email:String;
		public var photo:String;
		public var contactId:int;
		
		public function Contact()
		{
		}
	}
}