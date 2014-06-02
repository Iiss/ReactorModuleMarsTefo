package elements
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import models.MainDataModel;
	
	/**
	 * ...
	 * @author liss
	 */
	public class LinearGraph extends Shape
	{
		private var _surface:Sprite;
		private var _valueStack:Array;
		private var _minValue:Number = 0;
		private var _maxValue:Number = 0;
		private var _model:MainDataModel;
		private var _propertyName:String;
		private var _drawRect:Rectangle;
		
		public function LinearGraph(surface:Sprite, model:MainDataModel, propertyName:String, initialMaxValue = 100)
		{
			_surface = surface;
			
			_drawRect = new Rectangle(0, 0, _surface.width, _surface.height);
			
			while (surface.numChildren > 0)
			{
				surface.removeChild(_surface.getChildAt(surface.numChildren - 1));
			}
			
			_maxValue = initialMaxValue;
			
			_propertyName = propertyName;
			_model = model;
			_model.onUpdate.add(updateGraph);
			
			init(_drawRect.width);
		}
		
		private function init(resolution:int):void
		{
			_valueStack = new Array();
			
			for (var i:int = 0; i < resolution; i++)
			{
				_valueStack.push(null);
			}
		}
		
		private function redrawGraph():void
		{
			_surface.graphics.clear();
			_surface.graphics.lineStyle(1, 0xcdd381, 1, true, "none");
			
			var delta:Number = _maxValue - _minValue;
			
			var py:Number;
			var px:Number;
			var firstValue:Boolean = true;
			
			for (var i:int = 0; i < _valueStack.length; i++)
			{
				if (_valueStack[i] != null)
				{
					px = _drawRect.width - i * _drawRect.width / (_valueStack.length - 1);
					
					if (delta != 0)
					{
						py = _drawRect.height - (_valueStack[i] - _minValue) * (_drawRect.height / delta);
					}
					else
					{
						py = _drawRect.height - (_valueStack[i] - _minValue);
					}
					
					firstValue ? _surface.graphics.moveTo(px, py) : _surface.graphics.lineTo(px, py);
					
					firstValue = false;
				}
			}
		}
		
		private function updateGraph():void
		{
			update(_model[_propertyName]);
		}
		
		public function update(curValue:Number):void
		{
			_valueStack.push(curValue);
			_valueStack.shift();
			
			_minValue = Math.min(_minValue, curValue);
			_maxValue = Math.max(_maxValue, curValue);
			
			redrawGraph();
		}
	}
}