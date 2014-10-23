package elements 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	import models.MainDataModel;
	import org.osflash.signals.natives.NativeSignal;
	import flash.events.MouseEvent;
	import models.RodDataModel;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author liss
	 */
	public class SternSlide 
	{
		private const PRECISION_STEP:Number = 1;
		private const PRECISION_DELAY:Number = 500;
		
		private var _thumb:Sprite;
		private var onMouseDown:NativeSignal;
		private var onMouseUp:NativeSignal;
		private var onMouseMove:NativeSignal;
		private var upBtnMouseDown:NativeSignal;
		private var upBtnMouseUp:NativeSignal;
		private var downBtnMouseDown:NativeSignal;
		private var downBtnMouseUp:NativeSignal;
		private var _dragRect:Rectangle;
		private var _label:TextField;
		private var _inDrag:Boolean;
		
		private var _model:MainDataModel;
		private var _controller:Controller;
		private var _group:Array;
		private var _isActive:Boolean;
		
		private var _movingTo:Number = 0;
		private var _precisionTimer:Timer;
		private var _onTimer:NativeSignal;
		
		public function SternSlide(gfx:Sprite,group:Array,model:MainDataModel,controller:Controller) 
		{
			_group = group;
			
			_thumb = gfx['thumb'];
			_label = gfx['label'];
			_label.embedFonts = true;
			_label.text='0';
			
			_dragRect = new Rectangle(_thumb.x, _thumb.y, 0, 126);
			
			_controller = controller;
			
			_model = model;
			_model.onUpdate.add(update);
		
			_precisionTimer = new Timer(PRECISION_DELAY);
			_onTimer = new NativeSignal(_precisionTimer, TimerEvent.TIMER, TimerEvent);
			_onTimer.add(updatePrecisionMovement);
			
			
			onMouseUp = new NativeSignal(_thumb.stage, MouseEvent.MOUSE_UP, MouseEvent);
			onMouseUp.add(stopDrag);
			
			upBtnMouseDown = new NativeSignal(gfx['up_btn'], MouseEvent.MOUSE_DOWN, MouseEvent);
			downBtnMouseDown = new NativeSignal(gfx['down_btn'], MouseEvent.MOUSE_DOWN, MouseEvent);
			
			onMouseDown = new NativeSignal(_thumb, MouseEvent.MOUSE_DOWN, MouseEvent);
			onMouseDown.add(onStartDrag);
			
			upBtnMouseDown.add(precisionUpPressed);
			downBtnMouseDown.add(precisionDownPressed);
			
			onMouseMove = new NativeSignal(_thumb.stage, MouseEvent.MOUSE_MOVE, MouseEvent);
		}
		
		private function precisionUpPressed(e:MouseEvent):void 
		{
			_movingTo = PRECISION_STEP;
			updatePrecisionMovement();
			_precisionTimer.start();
			setSelection(true);
		}
		
		private function precisionDownPressed(e:MouseEvent):void 
		{
			_movingTo = - PRECISION_STEP;
			updatePrecisionMovement();
			_precisionTimer.start();
			setSelection(true);
		}
		
		private function updatePrecisionMovement(e:TimerEvent=null):void
		{
			if (_movingTo != 0)
			{
				for each(var el:RodDataModel in _group)
				{
					el.movingTo += _movingTo;
					if (el.movingTo <  RodDataModel.MIN_DEEP)
					{
						el.movingTo = RodDataModel.MIN_DEEP;
					}
					
					if (el.movingTo > RodDataModel.MAX_DEEP)
					{
						el.movingTo = RodDataModel.MAX_DEEP
					}
				}
			}
		}
		
		private function onStartDrag(e:MouseEvent):void
		{
			onMouseMove.add(onDrag);
		
			_thumb.startDrag(false, _dragRect);
			_inDrag = true;
		}
		
		private function onDrag(e:MouseEvent):void
		{
			moveGroup(yToValue(_thumb.y));
			setSelection(true);
		}
		
		private function stopDrag(e:MouseEvent):void
		{
			_precisionTimer.stop();
			_movingTo = 0;
			
			onMouseMove.remove(onDrag);
			
			_thumb.stopDrag();
			_inDrag = false;
			
			setSelection(false);
		}
		
		private function update():void
		{
			if (_group != null && _group.length > 0)
			{
				var selection:RodDataModel = _group[0] as RodDataModel;
				
				if ( selection != null)
				{
					_label.text = Math.floor(selection.deep).toString();
					
					if (!_inDrag)
					{
						_thumb.y = valueToY(selection.deep);
					}		
				}	
			}
		}
		
		
		
		private function yToValue(yValue:Number):Number
		{
			return (_dragRect.y + _dragRect.height - yValue) * (RodDataModel.MAX_DEEP-RodDataModel.MIN_DEEP) / _dragRect.height
		}
		
		private function valueToY(value:Number):Number
		{
			return _dragRect.y + _dragRect.height - value * _dragRect.height  / (RodDataModel.MAX_DEEP - RodDataModel.MIN_DEEP);
		}
		
		private function moveGroup(deep:Number):void 
		{
			if (_group != null)
			{
				for each (var el:RodDataModel in _group)
				{
					_controller.moveRodTo(deep, el);
				}
			}
		}
		
		private function setSelection(state:Boolean):void
		{
			if (_isActive == state) return;
			
			if (_group != null)
			{
				for each(var el:* in _group) 
				{
					state ?_controller.selectElement(el):_controller.unselectElement(el);
				}
				
				_isActive = state;
			}
		}
	}
}