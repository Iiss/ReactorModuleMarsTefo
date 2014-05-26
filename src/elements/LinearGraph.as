package elements 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import models.MainDataModel;
	import models.ReactorElementDataModel;
	/**
	 * ...
	 * @author liss
	 */
	public class LinearGraph extends Shape
	{
		private var _surface:DisplayObject;
		private var _valueStack:Array;
		private var _minValue:Number = 0;
		private var _maxValue:Number = 0;
		
		public function LinearGraph(surface:DisplayObject)
		{
			_surface = surface;
		}
		
		private function init(resolution:int):void
		{
			_valueStack = new Array();
	
			for(var i:int=0;i<resolution;i++)
			{
				_valueStack.push(null);
			}
		}
		
		private function redrawGraph():void
		{
			_surface.graphics.clear();
			_surface.graphics.lineStyle(2,0xE8D800);
			
			var delta:Number = _maxValue-_minValue;
			
			var py:Number;
			var px:Number;
			
			for(var i:int=0;i<_valueStack.length;i++)
			{
				if (_valueStack[i]!=null)
				{
					px = i * _surface.width / (_valueStack.length - 1);
					py = _surface.height - (_valueStack[i] - _minValue) * (_surface.height / delta);
					i==0 ? _surface.graphics.moveTo(px,py) : _surface.graphics.lineTo(px,py);
				}
			}
		}
		
		public function update(curValue:Number):void
		{
			_valueStack.push(curValue);
			_valueStack.shift();
	
			_minValue = Math.min(_minValue,curValue);
			_maxValue = Math.max(_maxValue,curValue);
			
			redrawGraph();
		}
	}
}