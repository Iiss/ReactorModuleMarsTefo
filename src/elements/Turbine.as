package elements 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import models.TurbineDataModel;
	import org.osflash.signals.natives.NativeSignal;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author liss
	 */
	public class Turbine 
	{
		private var _dataModel:TurbineDataModel;
		private var _gfx:Sprite;
		private var _activeSkin:Sprite;
		private var _stoppedSkin:Sprite;
		private var _changingSkin:Sprite;
		private var _recycleIndicator:MovieClip;
		private var _durabilityIndicator:Sprite;
		public var onClick:NativeSignal;
		private var _controller:Controller
		
		public function Turbine(gfx:Sprite, model:TurbineDataModel, controller:Controller) 
		{
			_gfx = gfx;
			
			_activeSkin 			= _gfx["active_skin"];
			_stoppedSkin			= _gfx["stopped_skin"];
			_changingSkin 			= _gfx["changing_skin"];
			_recycleIndicator 		= _changingSkin["recycle_indicator"];
			
			_recycleIndicator.stop();
			
			_activeSkin.mouseChildren = false;
			_stoppedSkin.mouseChildren = false;
			_changingSkin.mouseChildren = false;
			
			_dataModel = model;
			_dataModel.onUpdate.add(update);
			
			_controller = controller
			_controller.addReactorElementDataModel(_dataModel);
			
			onClick = new NativeSignal(_gfx, MouseEvent.MOUSE_DOWN, MouseEvent);
			onClick.add(clickHandler);
		}
		
		public function update(model:TurbineDataModel):void
		{
			_activeSkin.visible = model.turnedOn;
			_stoppedSkin.visible = !model.turnedOn;
			
			_activeSkin.visible ? _durabilityIndicator = _activeSkin["durability_indicator"] : _durabilityIndicator = _stoppedSkin["durability_indicator"];
			
			_durabilityIndicator.scaleY = model.durability / 100;
			
			_changingSkin.visible = model.selected || model.repairing==1;
			model.repairing != 0 ? _recycleIndicator.play() : _recycleIndicator.stop();
			
			if (_activeSkin.visible)
			{
				model.vRotor > 0 ? _activeSkin['rotor']['animation'].play() : _activeSkin['rotor']['animation'].stop();
			}
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if (!_dataModel.selected && _dataModel.repairing!=1)
			{
				_controller.clearSelection();
				_controller.selectElement(_dataModel);
			}
			else 
			{
				if (_dataModel.repairing == 0)
				{
					if (e.target == _activeSkin || e.target == _stoppedSkin)
					{
						_controller.toggleTurbine(_dataModel);
						
						if (_dataModel.turnedOn)
						{
							_controller.clearSelection();
						}
					}
					else 
					{
						_controller.changeTurbine();
						_controller.clearSelection();
					}
				}
			}
		}
	}
}