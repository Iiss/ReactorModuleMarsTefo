package elements 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import models.MainDataModel;
	import models.TvelDataModel;
	import ru.marstefo.reactor.gui.Tvs;
	import utils.GraphicsUtils;
	import org.osflash.signals.natives.NativeSignal;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author liss
	 */
	public class Tvel extends Sprite 
	{
		private var _gfx:Tvs

		private var _tvelData:TvelDataModel;
		private var _mainModel:MainDataModel;
		private var _controller:Controller;
		public var onClick:NativeSignal;
		private var  _indicatorMask:Sprite;
		public function Tvel(model:MainDataModel, controller:Controller) 
		{
			_controller = controller;

			_gfx = new Tvs;
			_gfx.width = _gfx.height = 99.2;
			_gfx.mouseChildren = false;

		//	_indicatorMask = new Sprite;
		//	_indicatorMask.
			_gfx['durability_indicator'].addChild(_indicatorMask);
		//	_gfx['durability_indicator'].mask = _indicatorMask;

			var value:Number = Math.round(Math.random() * 100);
			trace('value=' + value);
			trace(_gfx['durability_indicator'])
			trace(_gfx['durability_indicator'].mask)
			GraphicsUtils.drawPieMask(_indicatorMask.graphics, 30, 45, 40, 40,0,8);
			addChild(_gfx);

			_mainModel = model;
			_tvelData = new TvelDataModel;
			controller.addReactorElementDataModel(_tvelData);

			onClick = new NativeSignal(_gfx, MouseEvent.CLICK, MouseEvent);
			onClick.add(onMouseClick);
		}

		public function update():void 
		{

		}

		private function onMouseClick(e:MouseEvent):void
		{
			_controller.clearSelection();
			_controller.pushSelection(_tvelData);
		}

	}

}