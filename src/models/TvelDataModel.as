package models 
{
	/**
	 * ...
	 * @author liss
	 */
	public class TvelDataModel extends ReactorElementDataModel
	{
		public static const MIN_DEEP:Number = 0;
		public static const MAX_DEEP:Number = 100;
		
		public var deep:Number = MAX_DEEP;
		public var pulling:Boolean = false;
		public var pushing:Boolean = false;
		public var durability:Number = 100; //Износ ТВС
		public var er:Number = 0;
		public var exlosions:Number = 0;
		public var Tl:Array = [];
		public var I:Array = [];	
		public var Xe:Array = [];
		public var e:Array = [];


		public function TvelDataModel() 
		{
			type = 'R'
			
			for (var i:int = 0; i < 12; i++)
			{
				Tl.push(1);
				I.push(1);
				Xe.push(1);
				e.push(1);
			}
		}
		
	}

}