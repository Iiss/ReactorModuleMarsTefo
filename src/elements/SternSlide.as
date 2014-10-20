package elements 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import models.MainDataModel;
	import org.osflash.signals.natives.NativeSignal;
	import flash.events.MouseEvent;
	import models.RodDataModel;
	/**
	 * ...
	 * @author liss
	 */
	public class SternSlide 
	{
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
		
		public function SternSlide(gfx:Sprite,model:MainDataModel,controller:Controller) 
		{
			//_group = group;
			
			_thumb = gfx['thumb'];
			_label = gfx['label'];
			_label.embedFonts = true;
			_label.text='0';
			
			_dragRect = new Rectangle(_thumb.x, _thumb.y, 0, 126);
			
			_controller = controller;
			
			_model = model;
			_model.onUpdate.add(update);
			
			upBtnMouseDown = new NativeSignal(gfx['up_btn'], MouseEvent.MOUSE_DOWN, MouseEvent);
			downBtnMouseDown = new NativeSignal(gfx['down_btn'], MouseEvent.MOUSE_DOWN, MouseEvent);
			
			onMouseDown = new NativeSignal(_thumb, MouseEvent.MOUSE_DOWN, MouseEvent);
			onMouseDown.add(onStartDrag);
			
			upBtnMouseDown.add(precisionUpPressed);downBtnMouseDown.add(precisionDownPressed);
			
		}
		
		private function precisionUpPressed(e:MouseEvent):void 
		{
			var selection:RodDataModel = _model.curElement[0] as RodDataModel;
			
			if ( selection != null)
			{
				_controller.setMoveTo(selection.deep + 1);	
			}
		}
		
		private function precisionDownPressed(e:MouseEvent):void 
		{
			var selection:RodDataModel = _model.curElement[0] as RodDataModel;
			
			if ( selection != null)
			{
				_controller.setMoveTo(selection.deep - 1);	
			}
		}
		
		
		
		private function onStartDrag(e:MouseEvent):void
		{
			if (onMouseMove == null)
			{
				onMouseMove = new NativeSignal(_thumb.stage, MouseEvent.MOUSE_MOVE, MouseEvent);
			}
			
			if (onMouseUp == null)
			{
				onMouseUp = new NativeSignal(_thumb.stage, MouseEvent.MOUSE_UP, MouseEvent);
			}
			
			onMouseMove.add(onDrag);
			onMouseUp.add(stopDrag);
			
			_thumb.startDrag(false, _dragRect);
			_inDrag = true;
		}
		
		private function onDrag(e:MouseEvent):void
		{
			_controller.setMoveTo(yToValue(_thumb.y));
		}
		
		private function stopDrag(e:MouseEvent):void
		{
			onMouseMove.remove(onDrag);
			onMouseUp.remove(stopDrag);
			
			_thumb.stopDrag();
			_inDrag = false;
		}
		
		private function update():void
		{
			var selection:RodDataModel = _model.curElement[0] as RodDataModel;
			
			if ( selection != null)
			{
				_label.text = Math.floor(selection.deep).toString();
				
				if (!_inDrag)
				{
					_thumb.y = valueToY(selection.deep);
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
		
		
		private function clickHandler(e:MouseEvent):void
		{
			if (_group)
			{
				_controller.clearSelection();
				_controller.pushSelection(_group);
			}
		}
		
	}
}