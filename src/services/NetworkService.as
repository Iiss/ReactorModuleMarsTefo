package services
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author liss
	 */
	public class NetworkService 
	{
		private static var _url:String;
		private static var _request:URLRequest;
		private static var _loader:URLLoader;
		private static var _params:URLVariables;
		
		public static function setup(serverUrl:String):void
		{
			_url = serverUrl;
			
			if (serverUrl == null || serverUrl == "")
			{
				LogService.log("Server url was not set. NetworkService was not initialized", LogService.WARNING);
				
				_request =null;
				
				if (_loader != null)
				{
					_loader.removeEventListener(IOErrorEvent.IO_ERROR, logError);
					_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, logError);
					_loader = null;
				}
			}
			else
			{
				LogService.log("Server url set to " + serverUrl);
				
				_request = new URLRequest(_url);
				
				if (_loader == null)
				{
					_loader = new URLLoader();
					_loader.addEventListener(IOErrorEvent.IO_ERROR, logError);
					_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, logError);
				}
			}
		}
		
		public static function reportToServer(dataObj:Object=null):void
		{
			if (_loader == null)
			{
				return;
			}
			
			if (dataObj == null)
			{
				_request.data = null;
			}
			else
			{
				_params = new URLVariables();
				
				for (var p:String in dataObj)
				{
					_params[p] = dataObj[p];
				}
				
				_request.data = _params;
			}
			
			_loader.load(_request);
		}
		
		private static function logError(e:Event):void
		{
			LogService.log(e.toString(), LogService.ERROR);
		}
	}
}