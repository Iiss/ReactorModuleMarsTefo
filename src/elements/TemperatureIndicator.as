package elements 
{
	import flash.display.Sprite;
	import models.MainDataModel;
	/**
	 * ...
	 * @author liss
	 */
	public class TemperatureIndicator 
	{
		private var _model:MainDataModel;
		private var _propertyName:String;
		private var _overdriveValue:Number;
		private var _mask:Sprite;
		
		public function TemperatureIndicator(gfx:Sprite, model:MainDataModel, propertyName:String, overdriveValue:Number)
		{
			_mask = gfx['bar_mask'];
			
			_propertyName = propertyName;
			_overdriveValue = overdriveValue;
			
			_model = model;
			_model.onUpdate.add(update);
		}
		
		private function update():void
		{
			_mask.scaleY = Math.min(Number(_model[_propertyName]) / _overdriveValue, 1);
		}
	}
}