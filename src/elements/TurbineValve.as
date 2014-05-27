package elements 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import models.MainDataModel;
	import org.osflash.signals.natives.NativeSignal;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author liss
	 */
	public class TurbineValve 
	{
		private var _gfx:MovieClip;
		private var _model:MainDataModel;
		private var _controller:Controller;
		public var onClick:NativeSignal;
		
		public function TurbineValve(gfx:MovieClip,model:MainDataModel,controller:Controller) 
		{
			_gfx = gfx;
			_gfx.mouseChildren = false;
			
			_model = model;
			_model.onUpdate.add(update);
			
			_controller = controller;
			
			onClick = new NativeSignal(_gfx, MouseEvent.MOUSE_DOWN, MouseEvent);
			onClick.add(onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			_controller.toggleTurbineSystemLock();
		}
		
		public function update():void
		{
			_model.lockOpened ? _gfx.gotoAndStop(1) : _gfx.gotoAndStop(2);
		}
	}
}