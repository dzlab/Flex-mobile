package contacts.domain
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class ContactManager
	{
		
		public var allContacts:ArrayCollection = new ArrayCollection();
		
		public function ContactManager()
		{
		}
		
		public function addContact(contact:Contact):void
		{
			//contacts
			allContacts.addItem(contact);
		}
	}
}