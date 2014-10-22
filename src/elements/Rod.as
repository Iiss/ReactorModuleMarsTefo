package elements 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import models.RodDataModel;
	import org.osflash.signals.natives.NativeSignal;
	/**
	 * ...
	 * @author liss
	 */
	public class Rod
	{
		private var _rodData:RodDataModel;
		private var _controller:Controller;
		public var onClick:NativeSignal;
		private var _gfx:Sprite;
		private var _fill:Sprite;

		public function Rod(gfx:Sprite,rodModel:RodDataModel,controller:Controller) 
		{
			_controller = controller;

			_gfx = gfx;
			_gfx.mouseChildren = false;
			_fill = _gfx['fill'];

			_rodData = rodModel;
			_rodData.onUpdate.add(update);
			
			controller.addReactorElementDataModel(_rodData);
		}

		public function get group():int
		{
			return _rodData.group;
		}

		public function update(model:RodDataModel):void 
		{
			if (model.selected || (model.deep!=model.movingTo))
			{
				if (_fill.alpha < .8)
				{
					_fill.alpha += .1;
				}
			}
			else
			{
				if (_fill.alpha > .2)
				{
					_fill.alpha -= .05;
				}
			}			
		}
	}
}