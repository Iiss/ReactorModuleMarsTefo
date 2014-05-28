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
				_controller.pushSelection(_dataModel);
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

/*
package ui.turbine 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import models.MainDataModel;
	
	public class Turbine extends TurbineSystemElement 
	{
		private var _gfx:TurbineGFX;
		private var _heart:MovieClip;
		private var _glow:Sprite;
		
		//// Locale data model ////
		public var type:String = 'T'
		public var repairing:Number = 0;
		public var durability:Number = 100;		//Износ генератора
		public var B:Number = 0; 		//Выходная мощность
		public var vRotor:Number = 0;
		public var turnedOn:int = 1;
		///////////////////////////
		
		public function Turbine(model:MainDataModel,flowIndex:int,x:Number=0,y:Number=0) 
		{
			super(model, flowIndex, x, y);
			
			_gfx = new TurbineGFX
			_gfx.gotoAndStop(1);
			
			_heart = _gfx['heart']
			_heart.gotoAndStop(2)
			
			_glow = _gfx['b1'];
			
			_gfx.scaleX = _gfx.scaleY = .8;
			addChild(_gfx);
			
			
			update();
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			_selected ? _gfx.gotoAndStop(2) : _gfx.gotoAndStop(1);
		}
		
		override public function update():void 
		{
			
				
			//turbine heart gfx update
			if (durability <= 0)
			{
				if(_heart.currentFrame != 3 && repairing != -1){
				//	 play explosion sfx & gfx
				//	soundExplosion.start();
				//	generator['g'+i].attachMovie("explosion", "explosion", generator['g'+i].getNextHighestDepth());
					
					_heart.gotoAndStop(3);
				}
				
			}
			else
			{
				_heart.gotoAndStop(turnedOn + 1);
				_heart['rotor'].rotation += vRotor;
			}

			
			// flows gfx update
			if (_model.lockOpened) 
			{
				_water.alpha 	= 0;
				_hotWater.alpha = 0;
				_glow.alpha 	= 0;
			}
			else if (_model.generatorActive)
			{
				_glow.alpha 		= .01 * _model._globalB / _model.generatorActive * turnedOn / 3;
				_water.alpha 		= (.8 - _model.generatorActive * .1) * turnedOn;
				_hotWater.alpha 	= (.8 - _model.generatorActive * .1) * turnedOn * _model.kg;
			}
			
			//check selection
			if (_model.curElementType != this.type) 
			{
				selected = false;
				return;
			}
			_model.curElement.indexOf(this) == -1 ? selected = false : selected = true;
		}
		
	

}
*/
/*
			
			if(repairing == 1){
					
				if (_heart['rotor'].scaleY > .2)
				{
					_heart['rotor'].scaleX -= 0.005;
					_heart['rotor'].scaleY = _heart['rotor'].scaleX;
				}
				else
				{
					repairing = -1;
					_heart.gotoAndStop(2);
					_heart['rotor'].scaleY = _heart['rotor'].scaleX = .2;	
				}
			}
			else if (repairing == -1)
			{
				if (_heart['rotor'].scaleY < 1)
				{	
					_heart['rotor'].scaleX += 0.005;
					_heart['rotor'].scaleY = _heart['rotor'].scaleX;
				}
				else
				{
					repairing = 0;
					durability = 80+Math.random()*20;
					vRotor = 0;
				}
			}*/