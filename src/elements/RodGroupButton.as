package elements 
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import org.osflash.signals.natives.NativeSignal;
	/**
	 * ...
	 * @author liss
	 */
	public class RodGroupButton
	{
		private var _controller:Controller;
		private var _group:Array;
		public var onClick:NativeSignal;

		public function RodGroupButton(view:InteractiveObject, group:Array, controller:Controller) 
		{
			_group = group;
			_controller = controller;
			onClick = new NativeSignal(view, MouseEvent.CLICK, MouseEvent);
			onClick.add(clickHandler);
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