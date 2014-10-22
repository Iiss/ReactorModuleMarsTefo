package models 
{
	/**
	 * ...
	 * @author liss
	 */
	public class RodDataModel extends ReactorElementDataModel
	{
		public static const MIN_DEEP:Number = 0;
		public static const MAX_DEEP:Number = 1000;
		public var deep:Number = 1000;
		public var I:Number = 0;
		public var Xe:Number = 0;
		public var e:Number = 0;
		public var movingTo:Number = 1000;
		public var k:Number = 1; //may differ (by groups) [1, .5, 1, .5]	
		public var dependency:Object;
		public var XeIntencity:Number = 0;
		public var group:int;
		
		public function RodDataModel()
		{
			type = 'S';
		}
	}

}