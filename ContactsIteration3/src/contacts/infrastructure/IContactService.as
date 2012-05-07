package contacts.infrastructure
{
	import contacts.domain.Contact;
	
	import mx.rpc.AsyncToken;

	public interface IContactService
	{
		function getAllContacts():AsyncToken;
		function addContact(contact:Contact):AsyncToken;
	}
}