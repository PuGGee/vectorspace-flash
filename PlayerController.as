package  {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Collision.Shapes.b2MassData;
	
	public class PlayerController implements EntityController {

		var player:Ship;
		var keys:Array;
		var target:b2Vec2;
		
		public function PlayerController( player:Ship, keys:Array ) {
			this.player = player;
			this.keys = keys;
			target = new b2Vec2( 0, 0 );
		}
		
		public function updateMouse( xmouse:int, ymouse:int ):void {
			target.x = xmouse;
			target.y = ymouse;
		}
		
		public function update():void {
			if ( keys[ 32 ] ) {
				player.shoot();
			}
			if ( keys[ 87 ] ) {	//w
				player.accelerate( 1 );
			} else if (keys[ 87 ]) {
				player.slow();
			}
			
			if ( keys[ 65 ] ) {	//a
				player.turn( -1 );
			} else if ( keys[ 68 ] ) {	//d
				player.turn( 1 );
			} else {
				player.straighten();
			}
			
			//player.lookAt( target );
			
		}

	}
	
}