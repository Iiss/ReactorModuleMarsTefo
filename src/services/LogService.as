package services
{
	import com.junkbyte.console.Cc;
	/**
	 * Very simple log service
	 * @author liss
	 */
	public class LogService 
	{
		public static const LOG:String = "log";
		public static const ERROR:String = "error";
		public static const WARNING:String = "warning";
		
		public static function log(msg:String,msgType:String="log"):void
		{
			trace(msg);
			
			switch (msgType)
			{
				case ERROR:
					Cc.error(msg);
					break;
					
				case WARNING:
					Cc.warn(msg);
					break;
					
				default:
					Cc.log(msg);
					break;
			}
		}
	}

}