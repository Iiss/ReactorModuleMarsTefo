package  
{
	import br.com.stimuli.loading.BulkProgressEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import br.com.stimuli.loading.BulkLoader;
	import com.junkbyte.console.Cc;
	/**
	 * ...
	 * @author liss
	 */
	public class Main extends Sprite 
	{
		public const CONFIG_URL:String = "data/config.xml";
		public const ASSETS_URL:String = "assets/reactor_lib.swf";
		
		private var _assetsLoader:BulkLoader
		
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
			
			addChild(_assetsLoader.getSprite(ASSETS_URL, true));
		}
		
		private function log(msg:String):void
		{
			trace(msg);
			
			var error:Boolean = msg.toLowerCase().indexOf("error") != -1;
			error ? Cc.error(msg) : Cc.log(msg);
		}
		
		private function doNothing(e:Event=null){}
	}

}