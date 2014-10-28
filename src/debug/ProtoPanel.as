package debug 
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import flash.display.DisplayObjectContainer;
	import models.MainDataModel;
	import com.bit101.components.Window;
	import models.TvelDataModel;
	/**
	 * ...
	 * @author liss
	 */
	public class ProtoPanel 
	{
		private var _model:MainDataModel;
		private var _controller:Controller;
		private var tReactorLabel:Label;
		private var tLiquidLabel:Label;
		private var tGeneratorLabel:Label;
		private var tRoomLabel:Label;
		private var powerLabel:Label;
		
		private var tvelHBox:HBox
		
		
		public function ProtoPanel(parent:DisplayObjectContainer, model:MainDataModel, controller:Controller) 
		{
			_controller = controller;
			_model = model;
			
			var window:Window = new Window(parent, 0, 0, 'Control Panel');
			window.hasMinimizeButton = true;
			window.draggable = true;
			window.width = 320;
			window.height = 280;
			
			var vBox:VBox =  new VBox(window, 10, 10);
			tReactorLabel = new Label(vBox, 10, 10);
			tLiquidLabel = new Label(vBox, 10, 10);
			tGeneratorLabel = new Label(vBox, 10, 10);
			tRoomLabel = new Label(vBox, 10, 10);
			powerLabel = new Label(vBox, 10, 10);
			
			_model.onUpdate.add(update);
		}
		
		public function update():void
		{
			tReactorLabel.text = 	'Reactor Temp:.........' + _model.t1;
			tLiquidLabel.text = 	'Liquid Temp:............' + _model.t2;
			tGeneratorLabel.text = 	'Generator Temp:......' + _model.t3;
			tRoomLabel.text = 		'Room Temp:............' + _model.t4;
			powerLabel.text = 		'Power Output:.........' + _model.powerOutput;	
		}
		
		private function roundToDecimal(value:Number):Number
		{
			return Math.floor(value * 10) / 10;
		}
	}
}