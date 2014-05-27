package elements
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import models.TvelDataModel;
	import org.osflash.signals.natives.NativeSignal;
	
	/**
	 * ...
	 * @author liss
	 */
	public class Tvel
	{
		private var _gfx:Sprite
		
		private var _tvelData:TvelDataModel;
		private var _controller:Controller;
		public var onClick:NativeSignal;
		private var _indicatorMask:Sprite;
		
		private var _durabilityIndicator:MovieClip;
		
		public function Tvel(gfx:Sprite, controller:Controller)
		{
			_controller = controller;
			
			_gfx = gfx;
			_gfx.mouseChildren = false;
			
			_durabilityIndicator = _gfx['durability_indicator'];
			_durabilityIndicator.stop();
			
			_tvelData = new TvelDataModel;
			_tvelData.onUpdate.add(update);
			
			controller.addReactorElementDataModel(_tvelData);
			
			onClick = new NativeSignal(_gfx, MouseEvent.CLICK, MouseEvent);
			onClick.add(onMouseClick);
		}
		
		public function update(model:TvelDataModel):void
		{
			_durabilityIndicator.gotoAndStop(Math.round(model.durability));
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			_controller.clearSelection();
			_controller.pushSelection(_tvelData);
		}
	
	}

}