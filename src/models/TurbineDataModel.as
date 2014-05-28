package models 
{
	/**
	 * ...
	 * @author liss
	 */
	public class TurbineDataModel extends ReactorElementDataModel
	{
		public var repairing:Number = 0;
		public var durability:Number = 100;		//Износ генератора
		public var B:Number = 0; 				//Выходная мощность
		public var vRotor:Number = 0;
		public var turnedOn:Boolean = true;
		public var repairTime = 4; 				//время замены турбины генератора в секундах
		
		public function TurbineDataModel() 
		{
			type = 'R'
		}
		
	}

}