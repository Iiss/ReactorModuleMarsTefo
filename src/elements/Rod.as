package elements 
{
	import flash.display.MovieClip;
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
		private var _gfx:MovieClip;

		public function Rod(gfx:MovieClip,rodModel:RodDataModel,controller:Controller) 
		{
			_controller = controller;

			_gfx = gfx;
			_gfx.mouseChildren = false;
			_gfx.gotoAndStop(1);

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
			model.selected ? _gfx.gotoAndStop(2) : _gfx.gotoAndStop(1);				
		}
	}
}