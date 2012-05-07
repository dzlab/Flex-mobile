////////////////////////////////////////////////////////////////////////////////
//
//  BaaO
//  Copyright 2011 BaaO
//  All Rights Reserved.
//
//  NOTICE: BaaO permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

/*
Todo

- Proposer de séquencer les requêtes
- Renvoyer un AsyncToken sur l'ouverture de la BD
- gérer les ransactions (begin, commit, rollback)
- Gérer les requêtes paramêtrées
- déclaratif pour les appels

*/


package com.baao.sql
{
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.Responder;
	
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	use namespace mx_internal;
	
	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]	
	
	/**
	 * 
	 * Facade Class for AIR SQLite database allowing AsyncToken and result and fault Handlers
	 * 
	 */	
	public class SQLiteService extends EventDispatcher
	{
		/**
		 * the path to the local SQLite database
		 */
		private var _databaseFilePath:String;
		
		public function get databaseFilePath():String
		{
			return _databaseFilePath;
		}
		
		public function set databaseFilePath(value:String):void
		{
			_databaseFilePath = value;
			databaseFile = new File(databaseFilePath);
			trace("db path : " + databaseFile.nativePath )
			if (autoOpen)
				open();
		}
		
		private var _autoOpen:Boolean = false;
		
		public function get autoOpen():Boolean
		{
			return _autoOpen;
		}
		
		public function set autoOpen(value:Boolean):void
		{
			_autoOpen = value;
			if (databaseFile && !databaseConnection.connected)
				open();
		}
		
		/**
		 * Database File associated with this service (constructed from databaseFilePath)
		 */
		protected var databaseFile:File;		
		
		/**
		 * Database SQLConnection associated with this service
		 */
		protected var databaseConnection:SQLConnection;	
		
		/**
		 * Database SQLStatement associated with each SQLOperation
		 */
		protected var statement:SQLStatement;
		
		/**
		 * Creates a new instance of SQLService and initiates
		 * members
		 */		
		public function SQLiteService()
		{
			databaseConnection = new SQLConnection();
			//Statement problem modification 
			//Description : an error occurs on "statement" variable, when this one has already been affected by a previous request
			//=============== BEGIN ADDITION ===============//
			/*
			statement = new SQLStatement();
			statement.sqlConnection = databaseConnection;
			*/
			//===============  END ADDITION  ===============//
		}
		
		/**
		 * Opens the Database in Asynchroneous mode
		 * (This service doesn't work in Synchroneous mode)
		 *  
		 */
		
		public function open() : void
		{
			
			databaseConnection.addEventListener(SQLEvent.OPEN, openResult);
			databaseConnection.addEventListener(SQLErrorEvent.ERROR, openException);
			databaseConnection.openAsync( databaseFile, SQLMode.UPDATE );
			opening = true;
		}
		
		/**
		 * listener of database opening
		 * 
		 * @param SQLEvent
		 * 
		 */
		private function openResult(result:SQLEvent) : void
		{
			opening = false;
		}
		
		/**
		 * listener of database opening error
		 * 
		 * @param SQLErrorEvent
		 * 
		 */
		private function openException(error:SQLErrorEvent) : void
		{
			opening = false;
			dispatchEvent(error.clone());
		}
		
		/**
		 * Executes a basic SQL operation 
		 * 
		 * @param the SQL statement in which to execute
		 * @param responder which handles the operation result / fault
		 * @param optional class for mapping SELECT results
		 * @param optional prefetch
		 * 
		 */
		protected function execute(statementText:String, responder:Responder, itemClass:Class = null, parameters:Object=null, prefetch:int = -1.0) : void
		{
			//Statement problem modification
			//=============== BEGIN ADDITION ===============//
			statement = new SQLStatement();
			statement.sqlConnection = databaseConnection;
			//===============  END ADDITION  ===============//
			statement.text = statementText; //An "error" occurs on this line with the old version
			statement.itemClass = itemClass;
			if (parameters)
			{
				for (var property:String in parameters) 
				{
					statement.parameters[property] = parameters[property];
				}
			}
			
			statement.execute(prefetch, responder);
		}
		
		private var opening:Boolean = false;
		private var requests:Vector.<SQLRequest> = new Vector.<SQLRequest>();
		
		public function executeAsync(statement:String, dataType:Class = null, parameters:Object = null, prefetch:int = -1.0) : AsyncToken
		{
			var token:AsyncToken = new AsyncToken();		
			var requesthandler:SQLRequestHandler = new SQLRequestHandler(this, token);
			
			if (databaseConnection.connected)
			{
				execute(statement, requesthandler.responder, dataType, parameters, prefetch);
				return token;				
			}
			else if (!databaseConnection.connected && opening)
			{
				var request:SQLRequest = new SQLRequest(statement, requesthandler, dataType, prefetch);
				requests.push(request);
				databaseConnection.addEventListener(SQLEvent.OPEN, executeRequests);
				databaseConnection.addEventListener(SQLErrorEvent.ERROR, cancelRequests);
				return token;								
			}
			else
			{
				throw new Error("SQLiteService must be open before executing any statement");
			}
		}
		
		private function executeRequests(result:SQLEvent) : void
		{
			opening = false;
			databaseConnection.removeEventListener(SQLEvent.OPEN, executeRequests);
			databaseConnection.removeEventListener(SQLErrorEvent.ERROR, cancelRequests);
			var i:int;
			var requestsSize:int = requests.length;
			var request:SQLRequest;
			for (i=0; i < requestsSize; i++)
			{
				request = requests[i];
				execute(request.statement, request.requestHandler.responder, request.datatype, request.prefetch);
			}
		}
		
		/**
		 * @private
		 */
		private function cancelRequests(error:SQLErrorEvent) : void
		{
			opening = false;
			databaseConnection.removeEventListener(SQLEvent.OPEN, executeRequests);
			databaseConnection.removeEventListener(SQLErrorEvent.ERROR, cancelRequests);
			requests = new Vector.<SQLRequest>();
		}
		
	}	
}