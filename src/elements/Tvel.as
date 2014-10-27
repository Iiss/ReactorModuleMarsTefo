package elements
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import models.TvelDataModel;
	import org.osflash.signals.natives.NativeSignal;
	import com.greensock.TweenNano;
	/**
	 * ...
	 * @author liss
	 */
	public class Tvel
	{
		private static var READY_TO_CHANGE_STATE:String = "Ready";
		private static var NORMAL_STATE:String = "Normal";
		private static var DAMAGED_STATE :String= "Damaged";
		private static var CHANGE_STATE :String= "Change";
		
		private var _gfx:Sprite
		
		private var _tvelData:TvelDataModel;
		private var _controller:Controller;
		public var onClick:NativeSignal;
		private var _indicatorMask:Sprite;
		private var _core:Sprite;
		private var _bg:Sprite;
		private var _recycle:MovieClip;
		
		private var _durabilityIndicator:MovieClip;
		private var _currentState:String;
		
		
		public function Tvel(gfx:Sprite, controller:Controller)
		{
			_controller = controller;
			
			_gfx = gfx;
			_gfx.mouseChildren = false;
			
			_bg = _gfx['bg'];
			
			_core = _gfx['core'];
			
			_durabilityIndicator = _gfx['durability_indicator'];
			_durabilityIndicator.stop();
			
			_recycle = _gfx['recycle'];
			_recycle.stop();
			
			_tvelData = new TvelDataModel;
			_tvelData.onUpdate.add(update);
			
			controller.addReactorElementDataModel(_tvelData);
			
			currentState = Tvel.NORMAL_STATE;
			
			onClick = new NativeSignal(_gfx, MouseEvent.CLICK, MouseEvent);
			onClick.add(onMouseClick);
		}
		
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			if (value == _currentState)
			{
				return;
			}
			
			_currentState = value;
			
			switch (_currentState)
			{
				case Tvel.NORMAL_STATE:
					_core.visible = true;
					_durabilityIndicator.visible = true;
					_recycle.visible = false;
					_recycle.stop();
					
					if (_core.alpha ==0)
					{
						TweenNano.to(_core, 1, { alpha:1 } );
						TweenNano.to(_durabilityIndicator, 1, { alpha:1 } );
						TweenNano.to(_bg, 1, { alpha:1 } );
					}
					
					break;
					
				case Tvel.CHANGE_STATE:
					_core.visible = false;
					_durabilityIndicator.visible = false;
					_bg.alpha = 0;
					_recycle.visible = true;
					_recycle.play();
					TweenNano.delayedCall(3,onChangeComplete);
					break;
				
				case Tvel.READY_TO_CHANGE_STATE:
					_core.visible = false;
					_durabilityIndicator.visible = false;
					_recycle.stop();
					break;
					
				case Tvel.DAMAGED_STATE:
					_recycle.visible = true;
					_recycle.alpha = 0;
					TweenNano.to(_recycle, .3, { alpha:1 } );
					TweenNano.to(_core, .3, { alpha:0 } );	
					TweenNano.to(_durabilityIndicator, .3, { alpha:0 } );
					TweenNano.to(_bg, .3, { alpha:0, onComplete:onDamageComplete } );
					break;
			}
		}
		
		private function onChangeComplete():void
		{
			_controller.changeTVEL(_tvelData);
			currentState = Tvel.NORMAL_STATE;
		}
		
		private function onDamageComplete():void
		{
			currentState = Tvel.READY_TO_CHANGE_STATE;
		}
		
		private function killTweens():void
		{
			TweenNano.killTweensOf(this);
		}
		
		public function update(model:TvelDataModel):void
		{
			_durabilityIndicator.gotoAndStop(Math.round(model.durability));
			_core.scaleX = _core.scaleY = .5 + .5 * Math.abs(_tvelData.deep / (TvelDataModel.MAX_DEEP - TvelDataModel.MIN_DEEP));
			
			if (currentState == Tvel.NORMAL_STATE && model.durability < 1)
			{
				currentState = Tvel.DAMAGED_STATE;
			}
		}
		
		
		private function onMouseClick(e:MouseEvent):void
		{
			switch (currentState)
			{
				case Tvel.NORMAL_STATE:
					
					if (!(_tvelData.pulling && _tvelData.pushing))
					{
						if (_tvelData.deep == TvelDataModel.MAX_DEEP)
						{
							_controller.pullTVEL(_tvelData);		
						}
						else
						{
							_controller.pushTVEL(_tvelData);		
						}
					}
					
					break;
				
				case READY_TO_CHANGE_STATE:
					currentState = Tvel.CHANGE_STATE;
					break;
			}	
		}
	}

}