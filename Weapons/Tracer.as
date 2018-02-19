package Weapons {
	
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
	
	public class Tracer extends Linkable {

		var body:b2Body;
		var listener:WorldController;
		
		var intersectionPoints:Vector.<b2Vec2>;
		var intersectionFixtures:Vector.<b2Fixture>;
		var intersectionNormals:Vector.<b2Vec2>;
		
		var power:Number;

		public function Tracer( listener:WorldController, x_:Number, y_:Number, vel:b2Vec2, power:Number ) {
			
			this.listener = listener;
			
			body = listener.addShape( new b2CircleShape( 0.05 ), new b2Vec2( x_, y_ ), { type: 'proj', parent: this }, 5, true, false );
			
			body.SetLinearVelocity( vel );
			
			intersectionPoints = null;
			intersectionFixtures = null;
			intersectionNormals = null;
			
			this.power = power;
			
		}
		
		public override function update():void {
			
			var bodyPos:b2Vec2 = body.GetPosition();
			var velocity:b2Vec2 = body.GetLinearVelocity();
			var endPos:b2Vec2 = new b2Vec2( bodyPos.x + velocity.x * WorldController.timeStep, bodyPos.y + velocity.y * WorldController.timeStep );
			
			intersectionPoints = new Vector.<b2Vec2>();
			intersectionFixtures = new Vector.<b2Fixture>();
			intersectionNormals = new Vector.<b2Vec2>();
			
			listener.worldRef().RayCast( intersect, bodyPos, endPos );
			
			var mindist:Number = 99999;
			
			var minPoint:int = -1;
			
			for ( var i:int = 0; i < intersectionPoints.length; i++ ) {
					
				var dist:Number = Math.abs( intersectionPoints[ i ].x - bodyPos.x ) + Math.abs( intersectionPoints[ i ].y - bodyPos.y );
				
				if ( dist < mindist ) {
					
					mindist = dist;
					
					minPoint = i;
					
				}
				
			}
			
			if ( minPoint != -1 ) {
				
				var intersectionPoint:b2Vec2 = intersectionPoints[ minPoint ];
				var intersectionFixture:b2Fixture = intersectionFixtures[ minPoint ];
				var hitBody:b2Body = intersectionFixture.GetBody();
				var normal:b2Vec2 = intersectionNormals[ minPoint ];
				
				listener.drawLine( bodyPos, intersectionPoint );
				
				var force:b2Vec2 = body.GetLinearVelocity();
				var angle:Number = vecToAngle( normal );
				force.Multiply( power );
				
				for ( i = 0 ; i < 5; i++ ) {
					listener.addSfx( new SfxLine( intersectionPoint.Copy(), 0.6 * Math.random(), angle - Math.random() * Math.PI ) );
				}
				
				if (!intersectionFixture.GetUserData() || intersectionFixture.GetUserData().type != 'shield') hitBody.ApplyForce( force, intersectionPoint );
				
				var ship:Damageable = getDamageable( intersectionFixture );
				if ( ship ) {
					ship.damageShip( force.Length(), intersectionPoint, normal.GetNegative() );
				}
				
				destroy();
				
			} else {
				
				listener.drawLine( bodyPos, endPos );
				
			}
			
		}
		
		public function intersect( fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number ):Number {
			
			if ( !fixture.IsSensor() ) {
				intersectionPoints.push( point );
				intersectionFixtures.push( fixture );
				intersectionNormals.push( normal );
			}
			
			return 1;
			
		}
		
		public function destroy():void {
			
			listener.removeProjectile( this );
			
			listener.removeBody( body );	
			
		}

	}
	
}
