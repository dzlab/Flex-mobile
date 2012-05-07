package domain
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;

	/** This class implements the singleton pattern */
	public class Model
	{
		//Begin Singleton
		/**This class should be private as stipulate the singleton pattern, 
		 * but in AS3 it's not possible to have private constructor thus throw for instance exceptions */
		public function Model()
		{
			if(instance != null)
				throw new Error("Only one instance can be created...");
		}
		
		private static var instance:Model = null;
		
		public static function getModel():Model
		{
			if(instance == null)
				instance = new Model();
			
			return instance;
		}
		//End Singleton
		
		import mx.collections.ArrayCollection;
		[Bindable]
		public var contacts:ArrayCollection = new ArrayCollection ();
/*
		public var contacts:ArrayCollection = new ArrayCollection ([
			{firstname:"Marc", lastname:"Mazoué", email:"marc.mazoue@orange.com"},
			{firstname:"Emmanuel", lastname:"Bertin", email:"emmanuel.bertin@orange.com"},
			{firstname:"Marie", lastname:"Tiphaine", email:"marie.tiphaine@orange.com"}]);
*/		
		[Bindable]
		private var sqlConnectionSync:SQLConnection;
		
		public function openSqlConnection():SQLConnection
		{
			if(sqlConnectionSync != null)
				return sqlConnectionSync;
			var file:File = File.applicationDirectory.resolvePath("db/bookmark.db");
			// tell me where the file is stored
			trace(file.nativePath);
			sqlConnectionSync = new SQLConnection();
			sqlConnectionSync.open(file, SQLMode.UPDATE);
			
			return sqlConnectionSync;
		}
		
		public function closeSqlConnection():void
		{
			sqlConnectionSync.close();
		}
		
		public function loadContacts():void
		{
			// TODO Auto-generated method stub
			
			
			var read:SQLStatement = new SQLStatement(); //create the read statemen
			read.sqlConnection = openSqlConnection(); //set the connection
			
			// map rows to a class
			read.itemClass = Contact;
			read.text = "SELECT contactId, firstname, lastname, email, photo FROM contacts ORDER BY contactId";
			read.execute();
			var result:SQLResult = read.getResult(); //retrieve the result of the query
			trace("Reading from database: " + result.data);
			if(result.data && (result.data.length > 0))
			{
				// casting with 'as' or ClassName(obj)
				contacts = new ArrayCollection(result.data);
				trace("Contact list: " + contacts);
			}
		}
		
		public function saveContact(txtFirstName:String, txtLastName:String, txtEmail:String, txtPhoto:String):void 
		{
			contacts.addItem({firstname: txtFirstName, lastname: txtLastName, email: txtEmail, photo: txtPhoto});
			var insert:SQLStatement = new SQLStatement(); //create the insert statement
			insert.sqlConnection = Model.getModel().openSqlConnection(); //set the connection
			insert.text = "INSERT INTO contacts (firstname, lastname, email, photo) VALUES (?, ?, ?, ?)";
			insert.parameters[0] = txtFirstName;
			insert.parameters[1] = txtLastName;
			insert.parameters[2] = txtEmail;
			insert.parameters[3] = txtPhoto;
			insert.execute();
			trace("The data was saved into the table!");
			
		}
	}
}