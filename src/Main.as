package  
{
	import adobe.utils.ProductManager;
	import br.com.stimuli.loading.BulkProgressEvent;
	import debug.ProtoPanel;
	import elements.Reactor;
	import flash.display.Sprite;
	import flash.events.Event;
	import br.com.stimuli.loading.BulkLoader;
	import com.junkbyte.console.Cc;
	import models.*;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author liss
	 */
	public class Main extends Sprite 
	{
		public const CONFIG_URL:String = "data/config.xml";
		public const ASSETS_URL:String = "assets/reactor_lib.swf";
		
		private var _assetsLoader:BulkLoader
		private var _model:MainDataModel;
		private var _controller:Controller;
		
		
		
		public function Main() 
		{
			stage ? init() : addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Cc.startOnStage(this, "`");
			
			_assetsLoader = new BulkLoader("assets");
			_assetsLoader.add(CONFIG_URL, { id:CONFIG_URL } );
			_assetsLoader.add(ASSETS_URL, { id:ASSETS_URL } );
			
			_assetsLoader.logFunction = log
			_assetsLoader.logLevel = BulkLoader.LOG_INFO;
			
			_assetsLoader.addEventListener(BulkProgressEvent.COMPLETE, onAssetsLoaded);
			_assetsLoader.addEventListener(BulkLoader.ERROR, doNothing);
			
			_assetsLoader.start();
		}
		
		private function onAssetsLoaded(e:Event):void
		{
			_assetsLoader.removeEventListener(BulkProgressEvent.COMPLETE, onAssetsLoaded);
			_assetsLoader.removeEventListener(BulkLoader.ERROR, doNothing);
			
			var gfx:Sprite = _assetsLoader.getSprite(ASSETS_URL, true)
			
			addChild(gfx);
			
			var config:XML = _assetsLoader.getXML(CONFIG_URL, true);
			
			_model = new MainDataModel(config.constants,config.init_variables);
			_controller = new Controller(_model);
			
			var reactor:Reactor = new Reactor(gfx, _model, _controller);
			
			addEventListener(Event.ENTER_FRAME, EF);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, clear);
			
			/// temp ///
			var panel:ProtoPanel = new ProtoPanel(this, _model, _controller);
		}
		
		private function clear(e:MouseEvent):void
		{
			if (e.target == stage) _controller.clearSelection();
		}
		
		private function EF(e:Event):void
		{
			_controller.update();
		}
		
		private function log(msg:String):void
		{
			trace(msg);
			
			var error:Boolean = msg.toLowerCase().indexOf("error") != -1;
			error ? Cc.error(msg) : Cc.log(msg);
		}
		
		private function doNothing(e:Event = null):void{}
	}

}