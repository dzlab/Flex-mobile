package domain
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;

	public class Model
	{
		
		//Begin Singleton
		public function Model()
		{
			if (instance != null)
				throw new Error("Only one instance can be created...");
		}
		
		private static var instance:Model = null;
		
		public static function getModel():Model
		{
			if (instance == null)
				instance = new Model();
			
			return instance;
		}
		//End Singleton


		[Bindable]
		public var contacts:ArrayCollection;
		
		private var sqlConnectionSync:SQLConnection;
		
		public function loadContacts():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("db/contacts.db");
			if (!file.exists)
			{
				var appFile:File = File.applicationDirectory.resolvePath("db/contacts.db");
				appFile.copyTo(file);
			}
			trace(file.nativePath);
			sqlConnectionSync = new SQLConnection();
			sqlConnectionSync.open(file, SQLMode.UPDATE);
			
			var read:SQLStatement = new SQLStatement(); //create the read statemen
			read.sqlConnection = sqlConnectionSync; //set the connection
			
			read.text = "select * from Contact";
			//read.itemClass = Note;
			read.execute();
			var result:SQLResult = read.getResult(); //retrieve the result of the query
			trace(result.data);
			if (result.data && (result.data.length > 0))
			{
				contacts = new ArrayCollection(result.data);
			}
			
						
		}
		
		public function addContact(contact:Object):void
		{

			var insert:SQLStatement = new SQLStatement(); //create the insert statement
			insert.sqlConnection = sqlConnectionSync; //set the connection
			insert.text = "insert into Contact (firstname, lastname, email) VALUES (:firstname, :lastname, :email)";
			insert.parameters[":firstname"] = contact.firstname;
			insert.parameters[":lastname"] = contact.lastname;
			insert.parameters[":email"] = contact.email;
			insert.execute();
			trace("The data was saved into the table!");

			contacts.addItem(contact);
			
		}
		
		
		
	}
}