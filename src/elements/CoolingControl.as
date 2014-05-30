package elements
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import models.MainDataModel;
	import org.osflash.signals.natives.NativeSignal;
	import flash.events.MouseEvent;
	import utils.MathUtils;
	import com.greensock.TweenNano;
	
	/**
	 * ...
	 * @author liss
	 */
	public class CoolingControl
	{
		private static const MAX_ROTATION:Number = 90;
		private var _model:MainDataModel;
		private var _slider:Sprite;
		private var _controller:Controller;
		private var onMouseDown:NativeSignal;
		private var onMouseUp:NativeSignal;
		private var onMouseMove:NativeSignal;
		private var onTrackClick:NativeSignal;
		private var _initialDelta:Number;
		
		public function CoolingControl(gfx:Sprite, model:MainDataModel, controller:Controller)
		{
			_slider = gfx['slider'];
			
			_controller = controller;
			
			_model = model;
			//_model.onUpdate.add(update);
			update();
			
			
			onMouseDown = new NativeSignal(_slider, MouseEvent.MOUSE_DOWN, MouseEvent);
			onTrackClick = new NativeSignal(gfx, MouseEvent.CLICK, MouseEvent);
			
			onMouseDown.add(onStartDrag);
			onTrackClick.add(trackClickHandler);
		}
		
		private function trackClickHandler(e:MouseEvent):void
		{
			TweenNano.to(_slider, .3, {rotation: getTargetAngle()});
			_controller.setCooling(angleToCoolingValue(getTargetAngle()));
		}
		
		private function onStartDrag(e:MouseEvent):void
		{
			TweenNano.killTweensOf(_slider);
			
			_initialDelta = 0;// getTargetAngle() - _slider.rotation;
			
			if (onMouseMove == null)
			{
				onMouseMove = new NativeSignal(_slider.stage, MouseEvent.MOUSE_MOVE, MouseEvent);
			}
			
			if (onMouseUp == null)
			{
				onMouseUp = new NativeSignal(_slider.stage, MouseEvent.MOUSE_UP, MouseEvent);
			}
			
			onMouseMove.add(onDrag);
			onMouseUp.add(stopDrag);
		}
		
		private function onDrag(e:MouseEvent):void
		{
			var newAngle:Number = getTargetAngle()-_initialDelta;
			
			if (newAngle > -90 && newAngle < 180)
			{
				if (newAngle > MAX_ROTATION)
				{
					newAngle = MAX_ROTATION;
				}
				
				if (newAngle < 0)
				{
					newAngle = 0;
				}
				
				_slider.rotation = newAngle;
				
				_controller.setCooling(angleToCoolingValue(newAngle));
			}
			else
			{
				stopDrag(e);
			}
		
		}
		
		private function getTargetAngle():Number
		{
			return MathUtils.angle(_slider.x, _slider.y, _slider.parent.mouseX, _slider.parent.mouseY);
		}
		
		private function angleToCoolingValue(angle:Number):Number
		{
			//we can change cooling values in 0-1 range;
			return 1 - angle / MAX_ROTATION;
		}
		
		private function coolingToAngleValue(cooling:Number):Number
		{
			return MAX_ROTATION - cooling * MAX_ROTATION;
		}
		
		private function stopDrag(e:MouseEvent):void
		{
			onMouseMove.remove(onDrag);
			onMouseUp.remove(stopDrag);
		}
		
		private function update():void
		{
			_slider.rotation = coolingToAngleValue(_model.cooling);
		}
	}
}