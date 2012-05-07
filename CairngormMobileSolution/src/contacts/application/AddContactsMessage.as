package contacts.application
{
	import contacts.domain.Contact;

	public class AddContactsMessage
	{
		public var contact:Contact;
		
		public function AddContactsMessage(contact:Contact)
		{
			this.contact = contact;
		}
	}
}