package models 
{
	/**
	 * ...
	 * @author liss
	 */
	public class RodDataModel extends ReactorElementDataModel
	{
		public var deep:Number = 1000;
		public var I:Number = 0;
		public var Xe:Number = 0;
		public var e:Number = 0;
		public var movingTo:Number = -1;
		public var k:Number = 1; //may differ (by groups) [1, .5, 1, .5]	
		public var dependency:Object;
		public var XeIntencity:Number = 0;
		
		public function RodDataModel()
		{
			type = 'S';
		}
	}

}