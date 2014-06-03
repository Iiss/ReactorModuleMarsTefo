package elements 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import org.osflash.signals.natives.NativeSignal;
	import flash.events.MouseEvent;
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
		private var _dragRect:Rectangle;
		private var _label:TextField;
		
		public function SternSlide(gfx:Sprite) 
		{
			_thumb = gfx['thumb'];
			_label = gfx['label'];
			_label.embedFonts = true;
			_label.text='0';
			
			_dragRect = new Rectangle(_thumb.x, _thumb.y, 0, 126);
			
			onMouseDown = new NativeSignal(_thumb, MouseEvent.MOUSE_DOWN, MouseEvent);
			onMouseDown.add(onStartDrag);
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
			
			_thumb.startDrag(false,_dragRect);
		}
		
		private function onDrag(e:MouseEvent):void
		{
			_label.text = Math.floor((_dragRect.y + _dragRect.height - _thumb.y) * 1000 / _dragRect.height).toString();
		}
		
		private function stopDrag(e:MouseEvent):void
		{
			onMouseMove.remove(onDrag);
			onMouseUp.remove(stopDrag);
			
			_thumb.stopDrag();
		}
	}

}