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
	import General.*;
	import Helpers.*;
	import Weapons.*;
	
	public class Ship extends Linkable implements EntityController, Damageable {
		//teams
		public const ALLY:int = 1001;
		public const NEUTRAL:int = 1002;
		public const ENEMY:int = 1003;
		
		//behaviors
		public static const DEFAULT:int = 2001;
		public static const FOLLOW:int = 2002;
		
		public var listener:WorldController;

		public const maxRotationalSpeed = 0.1;

		var body:b2Body;
		
		var health:Number;
		var armourTop:Number;
		var armourBottom:Number;
		
		var team:int;
		var behavior:int;
		var angry:Boolean;
		
		var healthMax:Number;
		var armourMax:Number;
		
		var shield:Shield;
		
		var torque:Number;
		var thrust:Number;
		var speedMax;
		
		var mdata:b2MassData;
		
		var weapons:Vector.<Weapon>;
		
		var controller:EntityController;

		public function Ship( listener:WorldController, body:b2Body, healthMax:Number, armourMax:Number, torque:Number, thrust:Number, speedMax:Number ) {
			
			this.listener = listener;
			
			this.body = body;
			
			this.body.SetUserData( { type: 'ship', parent: this } );
			
			this.healthMax = healthMax;
			this.armourMax = armourMax;
			
			health = healthMax;
			armourTop = armourMax;
			armourBottom = armourMax;
			
			this.torque = torque;
			this.thrust = thrust;
			this.speedMax = speedMax;
			
			mdata = new b2MassData();
			getBody().GetMassData( mdata );
			
			weapons = new Vector.<Weapon>;
			
			team = NEUTRAL;
			behavior = DEFAULT;
		}
		
		public function setAsNeutral():void {
			team = NEUTRAL;
		}
		
		public function setAsEnemy():void {
			team = ENEMY;
		}
		
		public function setAsAlly():void {
			team = ALLY;
		}
		
		public function setDefaultBehavior():void {
			behavior = DEFAULT;
		}
		
		public function setFollowBehavior():void {
			behavior = FOLLOW;
		}
		
		public function getTeam():int {
			return team;
		}
		
		public function friendsWith(ship:Ship):Boolean {
			if (ship.getTeam() == NEUTRAL || team == NEUTRAL || ship.getTeam() == team) return true;
			return false;
		}
		
		public function setController( controller:EntityController ):void {
			this.controller = controller;
		}
		
		public function setShield( shield:Shield ):void {
			this.shield = shield;
		}
		
		public function addWeapon( weapon:Weapon ):void {
			weapons.push( weapon );
		}
		
		public function removeWeapon( weapon:Weapon ):Weapon {
			weapons.splice( weapons.indexOf( weapon ), 1 );
			return weapon;
		}
		
		public function accelerate( strength:Number ):void {
			if ( Math.abs( strength ) > 1 ) {
				strength = strength / Math.abs( strength );
			}
			
			var xvec:Number = Math.cos( getBody().GetAngle() + Math.PI / 2 ) * speedMax;
			var yvec:Number = Math.sin( getBody().GetAngle() + Math.PI / 2 ) * speedMax;
			
			var vel:b2Vec2 = getBody().GetLinearVelocity();
			
			var xdif:Number = xvec - vel.x;
			var ydif:Number = yvec - vel.y;
			
			var difbar:Number = Math.sqrt( xdif * xdif + ydif * ydif );
			
			var mult:Number;
			if ( thrust * strength / 30 > difbar ) {
				mult = difbar / ( thrust * strength );
			} else {
				mult = 1;	
			}
			var n:b2Vec2 = new b2Vec2( xdif / difbar, ydif / difbar );
			var bodyPos:b2Vec2 = getBody().GetWorldCenter().Copy();
			
			getBody().ApplyForce( new b2Vec2( n.x * thrust * strength * mult, n.y * thrust * strength * mult ), bodyPos );
		}
		
		public function turn(strength:Number):void {
			if (Math.abs(strength) > 1) {
				strength = strength / Math.abs(strength);
			}
			var v:Number = getBody().GetAngularVelocity() * WorldController.timeStep;
			var sign:Number = strength < 0 ? -1 : 1;
			var a:Number = getAngularAccelleration() * sign;
			
			if (Math.abs(v + a) < maxRotationalSpeed || Math.abs(v + a) < Math.abs(v)) {
				getBody().ApplyTorque(torque * strength);
			}
		}
		
		public function straighten():void {
			var v:Number = getBody().GetAngularVelocity() * WorldController.timeStep;
			var a:Number = getAngularAccelleration();
			if (a > Math.abs(v)) {
				getBody().SetAngularVelocity(0);
				return;
			}
			if (v > 0) {
				turn(-1);
			} else {
				turn(1);
			}
		}
		
		public function slow():void {
			
		}
		
		public function reduceHealth( val:Number ):void {
			health -= val;
		}
		
		public function reduceArmour( val:Number ):void {
			var damage:Number = val * 0.05;
			if ( damage > armourTop ) {
				damage -= armourTop;
				armourBottom -= damage;
				armourTop = 0;
			} else {
				armourTop -= damage;	
			}
		}
		
		public function damageShip( damage:Number, point:b2Vec2, normal:b2Vec2 ):void {
			var penetration:Number = damageCalc( damage );
			var impact:Number = damage - penetration;
			
			reduceHealth( penetration );
			reduceArmour( impact );
			
			var angle:Number = vecToAngle( normal.GetNegative() );
			for ( var i:Number = 0 ; i < Math.round( impact * 8 ); i++ ) {
				listener.addSfx( new SfxLine( point.Copy(), impact * Math.random() / 2, angle - Math.random() * Math.PI, 0xDDDDDD ) );
			}
			for ( i = 0 ; i < Math.round( penetration * 4 ); i++ ) {
				listener.addSfx( new SfxLine( point.Copy(), penetration * Math.random() / 5, angle - Math.random() * Math.PI, 0xFFFF00 ) );
			}
		}
		
		public function damageCalc( damage:Number ):Number {
			var deflectionRange:Number = armourTop - armourBottom;
			var deflection:Number = Math.random() * deflectionRange + armourBottom;
			if ( deflection > damage ) {
				return 0;
			} else {
				return damage - deflection;	
			}
		}
		
		public function getBody():b2Body {
			return body;
		}
		
		public function getLocation():b2Vec2 {
			return body.GetPosition();
		}
		
		override public function update():void {
			if ( controller ) controller.update();
			if ( shield ) shield.update();
			if ( health <= 0 ) {
				explode();	
			}
			for ( var i:Number = 0; i < weapons.length; i++ ) {
				weapons[ i ].update();	
			}
		}
		
		public function explode():void {
			listener.createExplosion( body.GetWorldCenter(), 2 );
			
			for ( var i:Number = 0; i < 4; i++ ) {
				var sd:b2PolygonShape = new b2PolygonShape();
				sd.SetAsArray([
					new b2Vec2(-0.2, 0.0),
					new b2Vec2(0.3, 0.0),
					new b2Vec2(0.0, 0.6)
					])
				var angle:Number = Math.random() * Math.PI * 2;
				var b:b2Body = listener.addShape( sd, body.GetWorldCenter().Copy(), null, 1, false, false );
				b.SetLinearVelocity( body.GetLinearVelocity().Copy() );
				listener.randomizeMovement( b, 150 );
			}
			destroy();
		}
		
		public function destroy():void {
			listener.removeBody( body );
			listener.removeShip( this );
		}
		
		public function shock( impulse:Number, point:b2Vec2, normal:b2Vec2 ):void {
			damageShip( impulse, point, normal );
		}
		
		public function shoot():void {
			for ( var i:Number = 0; i < weapons.length; i++ ) {
				weapons[ i ].shoot();	
			}
		}
		
		public function lookAt( targetPos:b2Vec2 ):Number {
			var pos:b2Vec2 = getBody().GetPosition();

			var targetAngle:Number = Math.atan2( targetPos.y - pos.y, targetPos.x - pos.x );
			var adif:Number = targetAngle - getNangle( getBody().GetAngle() + Math.PI / 2 );
			adif = getNangle( adif );
			
			var v:Number = getBody().GetAngularVelocity() * WorldController.timeStep;
			var a:Number = getAngularAccelleration();
			
			if ( adif < 0 ) {
				if ( Math.abs( adif ) <= v * v / ( 2 * a ) && v < 0 ) {
					turn( 1 );
				} else {
					turn( -1 );
				}
			}
			
			if ( adif >= 0 ) {
				if ( Math.abs( adif ) <= v * v / ( 2 * a ) && v > 0 ) {
					turn( -1 );
				} else {
					turn( 1 );
				}
			}
			return adif;
		}
		
		public function nearestTarget():Ship {
			var next:Ship = listener.getRoot();

			var shortestDistance:Number = 99999;
			var result:Ship = null;
			
			var shipPos:b2Vec2 = getBody().GetPosition();
			var targetPos:b2Vec2;

			var dist:Number;
			var xdif:Number;
			var ydif:Number;
			
			if ( next ) {
				do {
					if ( next != this && !friendsWith(next) ) {

						targetPos = next.getBody().GetPosition();
						
						xdif = targetPos.x - shipPos.x;
						ydif = targetPos.y - shipPos.y;
						
						dist = xdif * xdif + ydif * ydif;
						
						if ( dist < shortestDistance ) {
							shortestDistance = dist;
							result = next;	
						}
					}
				} while ( next = ( ( next as Linkable ).getNext() as Ship ) );
			}
			return result;
		}
		
		public function getBehavior():int {
			return behavior;
		}
		
		public function getHealth():Number {
			return health;
		}
		
		public function getArmourTop():Number {
			return armourTop;
		}
		
		public function getArmourBottom():Number {
			return armourBottom;
		}
		
		public function getShields():Number {
			if ( shield ) {
				return shield.getHealth();
			} else {
				return 0;
			}
		}
		
		public function getMaxShields():Number {
			if ( shield ) {
				return shield.getMaxHealth();
			} else {
				return 0;
			}
		}
		
		public function getMaxHealth():Number {
			return healthMax;
		}
		
		public function getMaxArmour():Number {
			return armourMax;
		}
		
		public function dead():Boolean {
			return health <= 0;
		}
		
		private function getAngularAccelleration():Number {
			return torque * mdata.I * WorldController.timeStep * 2.5 / getBody().GetMass();
		}
	}
}
