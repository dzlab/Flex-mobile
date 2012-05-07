package vo 
{
    
    [Bindable]
	[RemoteClass(alias="rorpc.Sandwich")]
	public class Sandwich {
		
		public var sandwichId:int;
		public var sandwichName:String="";
		public var bread:String="";
		public var meat:String="";
		public var spread:String="";	
		public var type:String="";
		
		public function Sandwich() 
		{
		}		

	}
}

