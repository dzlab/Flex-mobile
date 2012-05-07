package com.baao.sql
{
	internal class SQLRequest
	{
		
		public var statement:String;
		public var requestHandler:SQLRequestHandler;
		public var datatype:Class;
		public var prefetch:int;
		
		public function SQLRequest(statement:String, requesthandler:SQLRequestHandler, dataType:Class, prefetch:int)
		{
			super();
			this.statement = statement;
			this.requestHandler = requesthandler;
			this.datatype = dataType;
			this.prefetch = prefetch;
		}
	}
}