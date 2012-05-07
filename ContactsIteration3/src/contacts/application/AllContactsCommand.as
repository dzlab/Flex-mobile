package contacts.application
{
	import contacts.domain.ContactManager;
	import contacts.infrastructure.IContactService;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	
	import spark.components.ViewNavigator;

	public class AllContactsCommand
	{
		[Inject]
		public var service:IContactService;
		
		[Inject]
		public var manager:ContactManager;
		
		// you only need to return a AsyncToken, then parcelay will know where to put the result & error
		public function execute(event:AllContactsMessage):AsyncToken
		{
			return service.getAllContacts();
		}
		
		public function result(contacts:ArrayCollection, trigger:AllContactsMessage):void
		{
			manager.allContacts = contacts;
		}
		
		public function error(event:FaultEvent, trigger:AllContactsMessage):void
		{
			trace("Error ! ");
		}
		
	}
}