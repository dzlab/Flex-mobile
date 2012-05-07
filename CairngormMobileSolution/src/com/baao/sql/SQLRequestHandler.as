package com.baao.sql
{
	import flash.data.SQLResult;
	import flash.errors.SQLError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.Responder;
	
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	use namespace mx_internal;
	
	internal class SQLRequestHandler extends EventDispatcher
	{
		private var token:AsyncToken;
		public var responder:Responder;
		
		private var service:SQLiteService;

		public function SQLRequestHandler(service:SQLiteService, token:AsyncToken, target:IEventDispatcher=null)
		{
			super(target);
			this.service = service;
			this.token = token;
			responder = new Responder(onResult, onFault);
		}
		
		private function onResult(result:SQLResult):void
		{
			//if data we return data array wrapped in an ArrayCollection ; SQLesult otherwise
			var res:Object;
			if (result.data)
				res = new ArrayCollection(result.data)
			else
				res = result;
			
			var resultEvent:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, res, token);
			token.applyResult(resultEvent);
			
			if (service.hasEventListener(ResultEvent.RESULT))
				service.dispatchEvent(resultEvent);
		}
		
		private function onFault(error:SQLError):void
		{
			var fault:Fault = new Fault(String(error.detailID), error.details, error.operation);
			fault.rootCause = error;
			var faultEvent:FaultEvent = new FaultEvent(FaultEvent.FAULT, false, true, fault, token);
			token.applyFault(faultEvent);
			
			if (service.hasEventListener(FaultEvent.FAULT))
				service.dispatchEvent(faultEvent);
		}	
	}
}