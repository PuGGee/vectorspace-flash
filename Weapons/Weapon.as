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
	import General.*
	
	public class Weapon {
		public static const UNMOUNTABLE = 3001;
		public static const WEAPON = 3002;
		public static const TURRET = 3003;
		
		var listener:WorldController;
		
		var position:b2Vec2;
		
		var body:b2Body;
		
		var power:Number;
		var timer:Number;
		var cooldown:Number;
		var speed:Number;
		var duration:Number;
		var durationTimer:Number;
		
		var type:String;
		//see schema
		public function Weapon(listener:WorldController, body:b2Body, x_:Number, y_:Number, power:Number, cooldown:Number, speed:Number, type:String = 'tracer') {
			this.listener = listener;
			this.body = body;
			
			position = new b2Vec2( x_, y_ );
			
			this.power = power;
			this.cooldown = cooldown;
			this.speed = speed;
			this.type = type;
			
			timer = 0;
			duration = 10;
			durationTimer = 0;
		}
		
		public function getPosition():b2Vec2 {
			return position;
		}
		
		public function getWorldPosition():b2Vec2 {
			return body.GetWorldPoint( position )
		}
		
		public function getDirection():b2Vec2 {
			var x_:Number = Math.cos( getAngle() );
			var y_:Number = Math.sin( getAngle() );
			
			return new b2Vec2( x_, y_ );
		}
		
		public function update():void {
			timer--;
			durationTimer--;
		}
		
		public function shoot():void {
			if ( type == 'tracer' ) {
				shootTracer();
			} else if ( type == 'lazer' ) {
				shootLazer();
			}
		}
		
		function shootTracer():void {
			if ( timer <= 0 ) {
				var bodyPos:b2Vec2 = getWorldPosition();
				var bodyVel:b2Vec2 = body.GetLinearVelocity();
				var vel:b2Vec2 = new b2Vec2( Math.cos( getAngle() ) * speed + bodyVel.x, Math.sin( getAngle() ) * speed + bodyVel.y );
				
				listener.addTracer( bodyPos.x, bodyPos.y, vel, power );
				timer = cooldown;	
			}
		}
		
		function shootLazer():void {
			if ( timer <= 0 ) {
				timer = cooldown;
				durationTimer = duration;	
			}
			if ( durationTimer > 0 ) {
				listener.addLazer( this, 100, power );	
			}
		}
		
		function getAngle():Number {
			return body.GetAngle() + Math.PI / 2;
		}
		
		function rand():Number {
			return Math.round( Math.random() * cooldown * 0.2 );
		}
	}
}
