package  {
	
	import Box2D.Dynamics.*
	import Box2D.Collision.*
	import Box2D.Collision.Shapes.*
	import Box2D.Dynamics.Joints.*
	import Box2D.Dynamics.Contacts.*
	import Box2D.Common.Math.*
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import General.*
	
	public class StationController implements EntityController {
		
		var station:Ship;
		var listener:WorldController;
		
		var coords:b2Vec2;

		public function StationController( listener:WorldController, station:Ship ) {
			
			this.listener = listener;
			
			this.station = station;
			
			coords = station.getBody().GetWorldCenter().Copy();
			
		}
		
		public function update():void {
			
			
			
		}
		
		public function getShip():Ship {
			return station;
		}

	}
	
}
