package models 
{
	import org.osflash.signals.Signal;

	/**
	 * ...
	 * @author liss
	 */
	public class MainDataModel 
	{
		/*
		 * constants
		 */
		public var p1			:Number;
		public var kInertion	:Number;
		public var MStart		:Number;
		public var MFriction	:Number;
		public var kSteam		:Number;
		public var kRotor		:Number;
		public var kGeneration	:Number;
		public var kMom			:Number;
		public var kIzn			:Number;
		public var kIznKv		:Number;
		public var kohl			:Number;
		public var kohl2		:Number;
		public var kd			:Number;
		public var eMax			:Number;
		public var kU			:Number;
		public var kTl			:Number;
		public var kI			:Number;
		public var kXeS			:Number;
		public var kt12			:Number;
		public var kt23			:Number;
		public var kt34			:Number;
		public var kt45			:Number;
		public var kt			:Number;
		public var kXe			:Number;
		public var eCrit		:Number;
		
		/*
		 * operation variables
		 */
		// [градусы цельсия]
		public var t1:Number; 	//температура реактора
		public var t2:Number; 	//температура жидкости
		public var t3:Number;	//температура генератора
		public var t4:Number;	//температура в помещении
		public var t5:Number;
		//
		public var v1:Number;
		public var v2:Number;
		public var v3:Number;
		public var v4:Number;
		public var v5:Number;
		// [КДж/кг*К]
		public var c1:Number;
		public var c2:Number;
		public var c3:Number;
		public var c4:Number;
		public var c5:Number;
		
		public var Q1:Number;
		public var Q2:Number;
		public var Q3:Number;
		public var Q4:Number;
		public var Q5:Number;
		
		public var curElement		:Array;
		public var curElementType	:String = "";
		public var totalEnergy		:Number = 0;
		public var _globalB			:Number = 0; //Выход энергии
		public var lockOpened		:Boolean = true;//false;
		public var generatorActive	:int = 0;// generator active/unactive status
		public var kg				:Number = 0;//used in generator update;
		
		
		/*
		 * Reactor elements stacks
		 */
		public var tvels	:Vector.<TvelDataModel>;
		public var rods		:Vector.<RodDataModel>;
		public var turbines	:Vector.<TurbineDataModel>;
	
		public var rodDependencies:Array
		
		
		/////// ?????? /////////
		public var ms		:Number = 4;
		public var mC		:Number = 0;
		public var eSumm	:Number = 0;
		public var XeSumm	:Number = 0;
		public var cooling	:Number = 0;	
		////////////////////////
		
		/*
		 * Signals
		 */
		public var onUpdate:Signal;
		
		public function MainDataModel(const_list:XMLList,init_vars_list:XMLList) 
		{
			parseVars(const_list);
			parseVars(init_vars_list);
			
			Q1 = t1*v1*c1;
			Q2 = t2*v2*c2;
			Q3 = t3*v3*c3;
			Q4 = t4*v4*c4;
			Q5 = t5*v5*c5;
			
			onUpdate	= new Signal;
			
			curElement 		 = new Array;
			tvels 			 = new Vector.<TvelDataModel>;
			rods 			 = new Vector.<RodDataModel>;
			turbines 		 = new Vector.<TurbineDataModel>;
			rodDependencies	 = new Array;
		}
		
		public function update():void
		{
			onUpdate.dispatch();
		}
		
		
		/**
		 * XML config parser
		 * @param	list
		 */
		private function parseVars(list:XMLList):void
		{
			var node:XML;
			var prop_name:String;
			
			for each (node in list.children())
			{
				prop_name = node.name().toString();
				
				if (hasOwnProperty(prop_name))
				{
					this[prop_name] = Number(node)
				}
			}
		}
	}

}