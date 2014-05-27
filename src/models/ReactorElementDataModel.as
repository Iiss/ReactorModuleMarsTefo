package models 
{
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author liss
	 */
	public class ReactorElementDataModel 
	{
		public var selected:Boolean;
		public var type:String;
		public var onUpdate:Signal = new Signal(ReactorElementDataModel);
		
		public function notify():void
		{
			onUpdate.dispatch(this);
		}
	}

}