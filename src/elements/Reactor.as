package elements 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import models.MainDataModel;
	import models.RodDataModel;
	import org.osflash.signals.natives.NativeSignal;
	/**
	 * ...
	 * @author liss
	 */
	public class Reactor extends Sprite
	{
		//Tvels  name
		private var _tvels:Array = ['r1a','r2d','r3a','r2a','r1d','r3d','r3b','r1b','r2c','r3c','r2b','r1c']

		//Rods name|selection group|k|dependecy description
		private var _rods:Array =
		[
			{name:'s32da', 		group:4,	k:1,	dependency:{stack:1,position:5}},
			{name:'s13d', 	 	group:2, 	k:1, 	dependency:{stack:4,position:5}},
			{name:'s12da',	 	group:5,	k:.5, 	dependency:{stack:1,position:4}},
			{name:'s13a', 	 	group:2, 	k:1, 	dependency:{stack:0,position:2}},
			{name:'s32ad', 	 	group:4,	k:1, 	dependency:{stack:1,position:2}},
			{name:'s12ad', 	 	group:5, 	k:.5,	dependency:{stack:0,position:1}},
			{name:'s3d', 	 	group:3, 	k:.5,	dependency:{stack:2,position:5}},
			{name:'s32ba', 	 	group:4,	k:1, 	dependency:{stack:3,position:6}},
			{name:'s13b', 	 	group:2, 	k:1, 	dependency:{stack:6,position:7}},
			{name:'s12ba', 	 	group:5, 	k:.5,	dependency:{stack:3,position:7}},
			{name:'s32ab', 	 	group:4, 	k:1,	dependency:{stack:2,position:3}},
			{name:'s12ab', 	 	group:5,	k:.5, 	dependency:{stack:0,position:3}},
			{name:'s3a', 	 	group:3, 	k:.5,	dependency:{stack:2,position:6}},
			{name:'s32dc', 	 	group:4,	k:1, 	dependency:{stack:5,position:8}},
			{name:'s12dc', 	 	group:5,	k:.5, 	dependency:{stack:4,position:8}},
			{name:'s13c', 	 	group:2,  	k:1,	dependency:{stack:9,position:11}},
			{name:'s32cd', 	 	group:4, 	k:1,	dependency:{stack:8,position:9}},
			{name:'s12cd', 	 	group:5,	k:.5, 	dependency:{stack:8,position:11}},
			{name:'s3c', 	 	group:3, 	k:.5,	dependency:{stack:5,position:9}},
			{name:'s32bc', 	 	group:4,	k:1, 	dependency:{stack:6,position:9}},
			{name:'s12bc', 	 	group:5,	k:.5, 	dependency:{stack:7,position:10}},
			{name:'s32cb', 	 	group:4, 	k:1,	dependency:{stack:9,position:10}},
			{name:'s12cb', 	 	group:5,	k:.5, 	dependency:{stack:10,position:11}},
			{name:'s3b', 		group:3,	k:.5, 	dependency:{stack:6,position:8}}
		]

		private var _controller:Controller;
		private var _groups:Array;
		public var onClick:NativeSignal;
		private var _gfx:DisplayObjectContainer;

		public function Reactor(gfx:DisplayObjectContainer, model:MainDataModel,controller:Controller) 
		{
			_controller = controller;
			_groups = new Array;

			_gfx = gfx;
			
			drawTvels(model, controller);
			drawRods(model, controller);

			//clear init data
			_rods = null;
			_tvels = null;
		}

		public function get groups():Array
		{
			return _groups;
		}

		private function drawTvels(model:MainDataModel,controller:Controller):void
		{
			var t:Tvel
			var tvelView:Sprite;
			
			for (var i:int = 0; i < _tvels.length; i++)
			{
				tvelView = _gfx.getChildByName(_tvels[i]) as Sprite;
				t = new Tvel(tvelView,model,controller);	
			}
			
			tvelView = null;
			t = null;
		}

		private function drawRods(model:MainDataModel,controller:Controller):void
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

				r = new Rod(rodView, rodModel, model, controller);

				if (!_groups[r.group]) _groups[r.group] = new Array;

				_groups[r.group].push(rodModel);
			}

			r = null;
		}
	}
}