package  {
	
	import flash.display.Sprite;
	import flash.events.*;
	
	public class HardwareIcon extends Sprite {
		
		var xAnchor:Number;
		var yAnchor:Number;
		
		public function HardwareIcon( x:Number, y:Number ) {
			this.x = x;
			this.y = y;
			xAnchor = x;
			yAnchor = y;
		}
		
		public function mouseDownOver( e:Event ):void {
			startDrag();
		}
		
		public function mouseUpOver( e:Event ):void {
			stopDrag();
			x = xAnchor;
			y = yAnchor;
		}
		
	}
	
}
