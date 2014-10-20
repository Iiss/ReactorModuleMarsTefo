package elements
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import models.MainDataModel;
	import models.RodDataModel;
	import models.TurbineDataModel;
	import org.osflash.signals.natives.NativeSignal;
	
	/**
	 * ...
	 * @author liss
	 */
	public class Reactor extends Sprite
	{
		private var _tvels:Array = ['r1a', 'r2d', 'r3a', 'r2a', 'r1d', 'r3d', 'r3b', 'r1b', 'r2c', 'r3c', 'r2b', 'r1c'];
		private var _groupButtons:Array = 
		[
			{name: 'group_0_btn', group: 3 },
			{name: 'group_1_btn', group: 4 },
			{name: 'group_2_btn', group: 2 },
			{name: 'group_3_btn', group: 5 }
		];
		
		//Rods name|selection group|k|dependecy description
		private var _rods:Array = 
		[
			{name: 's32da', group: 4, k: 1, dependency: { stack: 1, position: 5 }},
			{name: 's13d', group: 2, k: 1, dependency: { stack: 4, position: 5 }},
			{name: 's12da', group: 5, k: .5, dependency: { stack: 1, position: 4 }},
			{name: 's13a', group: 2, k: 1, dependency: { stack: 0, position: 2 }},
			{name: 's32ad', group: 4, k: 1, dependency: { stack: 1, position: 2 }},
			{name: 's12ad', group: 5, k: .5, dependency: { stack: 0, position: 1 }},
			{name: 's3d', group: 3, k: .5, dependency: { stack: 2, position: 5 }},
			{name: 's32ba', group: 4, k: 1, dependency: { stack: 3, position: 6 }},
			{name: 's13b', group: 2, k: 1, dependency: { stack: 6, position: 7 }},
			{name: 's12ba', group: 5, k: .5, dependency: { stack: 3, position: 7 }},
			{name: 's32ab', group: 4, k: 1, dependency: { stack: 2, position: 3 }},
			{name: 's12ab', group: 5, k: .5, dependency: { stack: 0, position: 3 }},
			{name: 's3a', group: 3, k: .5, dependency: { stack: 2, position: 6 }},
			{name: 's32dc', group: 4, k: 1, dependency: { stack: 5, position: 8 }},
			{name: 's12dc', group: 5, k: .5, dependency: { stack: 4, position: 8 }},
			{name: 's13c', group: 2, k: 1, dependency: { stack: 9, position: 11 }},
			{name: 's32cd', group: 4, k: 1, dependency: { stack: 8, position: 9 }},
			{name: 's12cd', group: 5, k: .5, dependency: { stack: 8, position: 11 }},
			{name: 's3c', group: 3, k: .5, dependency: { stack: 5, position: 9 }},
			{name: 's32bc', group: 4, k: 1, dependency: { stack: 6, position: 9 }},
			{name: 's12bc', group: 5, k: .5, dependency: { stack: 7, position: 10 }},
			{name: 's32cb', group: 4, k: 1, dependency: { stack: 9, position: 10 }},
			{name: 's12cb', group: 5, k: .5, dependency: { stack: 10, position: 11 }},
			{name: 's3b', group: 3, k: .5, dependency: { stack: 6, position: 8 }}
		]
		
		private var _turbins:Array = ['g1', 'g2', 'g3', 'g4'];
		
		private var _controller:Controller;
		private var _groups:Array;
		public var onClick:NativeSignal;
		private var _gfx:DisplayObjectContainer;
		public var onStopButtonClick:NativeSignal;
		
		public function Reactor(gfx:DisplayObjectContainer, model:MainDataModel, controller:Controller)
		{
			_controller = controller;
			_groups = new Array;
			
			_gfx = gfx;
			
			setupTvels(controller);
			setupRods(controller);
			setupGroupButtons(controller);
			setupTurbins(model, controller);
			
			onStopButtonClick = new NativeSignal(_gfx['stop_btn'], MouseEvent.MOUSE_DOWN, MouseEvent);
			onStopButtonClick.add(_controller.stopReactor);
			
			var reactionDiagrams:LinearGraph = new LinearGraph(_gfx['reactions_diagram'], model, 'eSumm');
			var powerDiagram:LinearGraph = new LinearGraph(_gfx['power_diagram'], model, 'powerOutput');
			
			var roomTempIndicator:TemperatureIndicator = new TemperatureIndicator(_gfx['temperatures_block']['room_temperature'], model, 't4', 100);
			var liquidTempIndicator:TemperatureIndicator = new TemperatureIndicator(_gfx['temperatures_block']['liquid_temperature'], model, 't2', 100);
			var reactorTempIndicator:TemperatureIndicator = new TemperatureIndicator(_gfx['temperatures_block']['reactor_temperature'], model, 't1', 100);
			
			var sternSlide1:SternSlide = new SternSlide(_gfx['stern_slide_0'],model,controller);
			
			//clear init data
			_rods = null;
			_tvels = null;
			_turbins = null;
			_groupButtons = null;
		}
		
		public function get groups():Array
		{
			return _groups;
		}
		
		private function setupTurbins(model:MainDataModel, controller:Controller):void
		{
			var turbineSystem:TurbineSystem = new TurbineSystem(_gfx['channels'], model);
			var turbineValve:TurbineValve = new TurbineValve(_gfx['valve'], model, controller);
			var coolingControl:CoolingControl = new CoolingControl(_gfx['cooling_control'], model, controller);
			
			var t:Turbine
			var tView:Sprite;
			var tModel:TurbineDataModel;
			
			for (var i:int = 0; i < _turbins.length; i++)
			{
				tView = _gfx.getChildByName(_turbins[i]) as Sprite;
				tModel = new TurbineDataModel();
				t = new Turbine(tView, tModel, controller);
				
				turbineSystem.addTurbine(tModel, i + 1);
			}
			
			tView = null;
			t = null;
			tModel = null;
		}
		
		private function setupGroupButtons(controller:Controller):void
		{
			var groupBtn:RodGroupButton;
			var groupBtnView:InteractiveObject;
			
			for (var i:int = 0; i < _groupButtons.length; i++)
			{
				groupBtnView = _gfx.getChildByName(_groupButtons[i].name) as InteractiveObject;
				groupBtn = new RodGroupButton(groupBtnView, groups[_groupButtons[i].group], controller);
			}
			
			groupBtn = null;
			groupBtnView = null;
		}
		
		private function setupTvels(controller:Controller):void
		{
			var t:Tvel
			var tvelView:Sprite;
			
			for (var i:int = 0; i < _tvels.length; i++)
			{
				tvelView = _gfx.getChildByName(_tvels[i]) as Sprite;
				t = new Tvel(tvelView, controller);
			}
			
			tvelView = null;
			t = null;
		}
		
		private function setupRods(controller:Controller):void
		{
			var rodsGfx:DisplayObjectContainer = _gfx;
			
			var r:Rod
			var rodView:MovieClip;
			var rodModel:RodDataModel;
			
			for (var i:int = 0; i < _rods.length; i++)
			{
				rodView = rodsGfx.getChildByName(_rods[i].name) as MovieClip;
				
				rodModel = new RodDataModel();
				rodModel.group = _rods[i].group;
				rodModel.dependency = _rods[i].dependency;
				rodModel.k = _rods[i].k;
				
				r = new Rod(rodView, rodModel, controller);
				
				if (!_groups[r.group])
					_groups[r.group] = new Array;
				
				_groups[r.group].push(rodModel);
			}
			
			r = null;
		}
	}
}