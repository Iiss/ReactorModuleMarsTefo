package utils 
{
	/**
	 * ...
	 * @author liss
	 */
	public class MathUtils 
	{
		// Used for rad-to-deg and deg-to-rad conversion.
		public static const DEG:Number = 180 / Math.PI;
		public static const RAD:Number = Math.PI / 180;
		
		/**
		 * Finds the angle (in degrees) from point 1 to point 2.
		 * @param	x1		The first x-position.
		 * @param	y1		The first y-position.
		 * @param	x2		The second x-position.
		 * @param	y2		The second y-position.
		 * @return	The angle from (x1, y1) to (x2, y2).
		 */
		public static function angle(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			return Math.atan2(y2 - y1, x2 - x1) * DEG;
		}
	}
}