package elements 
{
	import flash.text.TextField;
	import models.MainDataModel;
	/**
	 * ...
	 * @author liss
	 */
	public class Counter 
	{
		private var _label:TextField;
		private var _model:MainDataModel;
		private var _propertyName:String;
		
		public function Counter(label:TextField, model:MainDataModel, propertyName:String) 
		{
			_label = label;
			_propertyName = propertyName;
			_model = model;
			_model.onUpdate.add(update);
		}
		
		public function update():void
		{
			_label.text = Math.round(_model[_propertyName]).toString();
		}
	}
}