package elements
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import models.MainDataModel;
	import models.TurbineDataModel;
	
	/**
	 * ...
	 * @author liss
	 */
	public class TurbineSystem
	{
		private var _model:MainDataModel;
		private var _gfx:Sprite;
		private var _stream:MovieClip;
		private var _mask:Sprite;
		private var _turbins:Dictionary;
		
		public function TurbineSystem(gfx:Sprite, model:MainDataModel)
		{
			_gfx = gfx;
			_gfx.mouseEnabled = false;
			_gfx.mouseChildren = false;
			
			_stream = _gfx['stream_mc'];
			_mask = _gfx['mask_mc'];
			
			_turbins = new Dictionary;
			
			_model = model;
			_model.onUpdate.add(update);
		}
		
		private function update():void
		{
			_stream.visible = _model.lockOpened;
		}
		
		public function addTurbine(t:TurbineDataModel, flowIndex:int):void
		{
			var segment:DisplayObject = _mask.getChildByName('output_' + flowIndex.toString());
			_turbins[t] = segment;
			
			t.onUpdate.add(onTurbineUpdate);
		}
		
		private function onTurbineUpdate(model:TurbineDataModel):void
		{
			if (model != null && _turbins[model] != null)
			{
				var onStage:Boolean = _mask.getChildByName((_turbins[model] as DisplayObject).name)!=null;
				
				if (!model.turnedOn && onStage)
				{
					_mask.removeChild(_turbins[model]);
				}
				else if (model.turnedOn && !onStage)
				{
					_mask.addChild(_turbins[model]);
				}
			}
		}
	}
}