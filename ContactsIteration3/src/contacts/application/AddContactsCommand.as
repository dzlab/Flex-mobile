package contacts.application
{
	import contacts.domain.ContactManager;
	import contacts.infrastructure.IContactService;
	
	import mx.core.FlexGlobals;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class AddContactsCommand
	{
		[Inject]
		public var service:IContactService;
		
		[Inject]
		public var manager:ContactManager;
		
		public function execute(event:AddContactsMessage):AsyncToken
		{
			return service.addContact(event.contact);
		}
		
		public function result(event:ResultEvent, trigger:AddContactsMessage):void
		{
			manager.addContact(trigger.contact);
			//FlexGlobals.topLevelApplication.navigator.popView();
		}
		
		public function error(event:FaultEvent, trigger:AddContactsMessage):void
		{
			trace("Error ! ");
		}
		
	}
}