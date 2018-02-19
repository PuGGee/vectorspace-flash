package  {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Collision.Shapes.b2MassData;
	import Helpers.*;
	
	public class NpcController implements EntityController {

		public const homingDistance:Number = 20;
		public const followDistance:Number = 5;

		var listener:WorldController;
		var ship:Ship;
		var target:Ship;
		
		var counter:int = 0;
		
		public function NpcController(listener:WorldController, ship:Ship) {
			this.listener = listener;
			this.ship = ship;
		}
		
		public function update():void {
			counter++;
			if (counter >= 10) {
				getTarget();
				counter = 0;
			}
			if (ship.getBehavior() == Ship.FOLLOW) {
				followBehavior();
			} else {
				defaultBehavior();
			}
		}
		
		public function noTarget():Boolean {
			return target == null || target.dead();
		}
		
		private function followBehavior():void {
			if (distanceBetween(ship.getLocation(), listener.player.getLocation()) > followDistance) {
				ship.accelerate(1);
			}
			ship.lookAt(listener.player.getLocation());
			if (target && distanceBetween(ship.getLocation(), target.getLocation()) <= homingDistance) {
				ship.setDefaultBehavior();
			}
		}
		
		private function defaultBehavior():void {
			if (target && distanceBetween(ship.getLocation(), target.getLocation()) <= homingDistance) {
				ship.accelerate(1);
				if (Math.abs(ship.lookAt(target.getLocation())) < 0.3) {
					ship.shoot();
				}
			} else if (ship.getTeam() == listener.player.getTeam()) {
				ship.setFollowBehavior();
			}
		}
		
		private function getTarget():void {
			target = ship.nearestTarget();
		}
	}
}
