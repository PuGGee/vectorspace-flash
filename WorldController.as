package  {
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.Math.*;
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import General.*;
	import UI.*;
	import Missions.*;
	import Weapons.*;
	import Schemas.*;
	import Controllers.*;
	import Helpers.*;
	
	import flash.display.MovieClip;
	
	public class WorldController {

		public var world:b2World;
		public var velocityIterations:int = 10;
		public var positionIterations:int = 10;
		public static var timeStep:Number = 1.0/30.0;
		public static var drawScale:Number = 30;
		public var keys:Array;
		public var xmouse:int;
		public var ymouse:int;
		public var canvas:Sprite;
		public var menuSprite:Sprite;
		public var debrisMax:int;
		
		static var meh:KillDem = new KillDem();
		
		public var player:Ship;
		public var playerController:PlayerController;
		
		public var playerState:PlayerState;
		
		public var shipRoot:Linkable;
		public var sfxRoot:Linkable;
		public var uiElements:Vector.<UIElement>;
		public var ships:int;
		
		public var projectileRoot:Linkable;
		
		public var stageWidth:Number;
		public var stageHeight:Number;
		
		var factory:ShipFactory;
		var missionController:MissionController;
		
		var station:Station;
		
		//scale at which to draw the world, based on size of player ship
		var viewScale:int;
		
		var dockedAt:int;
		
		public function WorldController(stageWidth:Number, stageHeight:Number) {
			
			//create a flag for every key which will indicate whether or not that key is being pressed currently
			keys = new Array( 1000 );
			
			for ( var i:int = 0; i < 1000; i++ ) {
				keys[ i ] = false;
			}
			
			//create the bounding box
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-1000.0, -1000.0);
			worldAABB.upperBound.Set(1000.0, 1000.0);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0, 0);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			// Construct a world object
			world = new b2World(gravity, doSleep);
			world.SetWarmStarting(true);
			
			//add custom contact listener to measure impulse from each collision
			world.SetContactListener( new ImpulseDamageListener( this ) );
			
			factory = new ShipFactory(this);
			missionController = new MissionController(this);
			
			viewScale = 4;
			
			shipRoot = null;
			ships = 0;
			
			xmouse = 0;
			ymouse = 0;
			
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			
			projectileRoot = null;
			
			createInterface();
			
			//makeStation( 40, 0 );
			
			var weapon:WeaponSchema = Data.randomWeapon();
			
			playerState = new PlayerState( Data.getShipSchemas()[1] );
			playerState.hardware.push( weapon );
			playerState.hardware.push( weapon );
			playerState.hardware.push( weapon );
			playerState.hardware.push( weapon );
			playerState.hardware.push( weapon );
			playerState.hardware.push( Data.randomHardware() );
			playerState.hardware.push( Data.randomHardware() );
			playerState.hardware.push( Data.randomHardware() );
			playerState.hardware.push( Data.randomHardware() );
			
			addPlayer( 0, 0 );
			
			debrisMax = 10;
			
		}
		
		public function createInterface():void {
			uiElements = new Vector.<UIElement>();
			uiElements.push(new EnemyMarkers(this, 0xFF0000));
		}
		
		public function drawInterface():void {
			menuSprite.graphics.clear();
			
			var healthPercent:Number = player.getHealth() / player.getMaxHealth();
			var armourMaxPercent:Number = player.getArmourTop() / player.getMaxArmour();
			var armourMinPercent:Number = player.getArmourBottom() / player.getMaxArmour();
			
			menuSprite.graphics.lineStyle( 0, 0, 0 );
      menuSprite.graphics.beginFill( 0x00FF20 );
      menuSprite.graphics.drawRect( -230, -340, 180 * healthPercent, 40 );
      menuSprite.graphics.endFill();
      menuSprite.graphics.beginFill( 0x666666 );
      menuSprite.graphics.drawRect( -230, -290, 180 * armourMinPercent, 40 );
      menuSprite.graphics.endFill();
      menuSprite.graphics.beginFill( 0xCCCCCC );
      menuSprite.graphics.drawRect( -230, -290, 180 * armourMaxPercent, 40 );
      menuSprite.graphics.endFill();
      
      if ( player.getMaxShields() > 0 ) {
	      var shieldsPercent:Number = player.getShields() / player.getMaxShields();
	      menuSprite.graphics.beginFill( 0x0020FF );
	      menuSprite.graphics.drawRect( -230, -240, 180 * shieldsPercent, 40 );
	      menuSprite.graphics.endFill();
	    }
	    
	    for (var i:int = 0; i < uiElements.length; i++) {
	    	uiElements[i].draw(menuSprite);
	    }
		}
		
		public function getRoot():Ship {
			return ( shipRoot as Ship );
		}
		
		public function getProjectileRoot():Linkable {
			return projectileRoot;
		}
		
		public function worldRef():b2World {
			return world;
		}
		
		private function addPlayer( x_:Number, y_:Number ):void {
			var ship:Ship = factory.make( new b2Vec2( x_, y_ ), playerState.ship, playerState.hardware, true );
			
			var controller:PlayerController = new PlayerController( ship, keys );
			ship.setController( controller );
			ship.setAsAlly();
			
			addShip( ship );
			
			player = ship;
			playerController = controller;
		}
		
		public function addNpc( x_:Number, y_:Number ):Ship {
			var shipSchema:ShipSchema = Data.getShipSchemas()[0];
			var weaponSchema:WeaponSchema = Data.randomWeapon();
			var hardwareSchema:HardwareSchema = Data.randomHardware();
			var hardware:Vector.<Schema> = new Vector.<Schema>();
			hardware.push( weaponSchema );
			hardware.push( hardwareSchema );
			
			var ship:Ship = factory.make( new b2Vec2( x_, y_ ), shipSchema, hardware );
			
			var controller:NpcController = new NpcController( this, ship );
			ship.setController( controller );
			
			addShip( ship );
			return ship;
		}
		
		public function addShip( ship:Ship ):void {
			if ( shipRoot ) {
				shipRoot.setPrevious( ship );
				ship.setNext( shipRoot );
			}
			shipRoot = ship;
			ships++;
		}
		
		public function removeShip( ship:Ship ):void {
			//if ( ship == player ) player = null;
			if ( ship == shipRoot ) {
				shipRoot = ship.getNext();
			} else {
				if ( ship.getPrevious() ) {
					ship.getPrevious().setNext( ship.getNext() );
				}
				
				if ( ship.getNext() ) {
					ship.getNext().setPrevious( ship.getPrevious() );	
				}
			}
			ships--;
		}
		
		public function addSfx( sfx:Sfx ):void {
			if ( sfxRoot ) {
				sfxRoot.setPrevious( sfx );
				sfx.setNext( sfxRoot );	
			}
			sfxRoot = sfx;
		}
		
		public function removeSfx( sfx:Sfx ):void {
			if ( sfx == sfxRoot ) {
				sfxRoot = sfx.getNext();
			} else {
				if ( sfx.getPrevious() ) {
					sfx.getPrevious().setNext( sfx.getNext() );
				}
				if ( sfx.getNext() ) {
					sfx.getNext().setPrevious( sfx.getPrevious() );
				}
			}
		}
		
		public function addTracer( x_:Number, y_:Number, vel:b2Vec2, power:Number ):void {
			addProjectile( new Tracer( this, x_, y_, vel, power ) );
		}
		
		public function addLazer( weapon:Weapon, range:Number, power:Number ):void {
			addProjectile( new Lazer( this, weapon, range, power ) );
		}
		
		public function addProjectile( projectile:Linkable ):void {
			if ( projectileRoot ) {
				projectileRoot.setPrevious( projectile );
				projectile.setNext( projectileRoot );
			}
			projectileRoot = projectile;
		}
		
		public function removeProjectile( projectile:Linkable ):void {
			if ( projectile == projectileRoot ) {
				projectileRoot = projectile.getNext();
			} else {
				if ( projectile.getPrevious() ) {
					projectile.getPrevious().setNext( projectile.getNext() );
				}
				if ( projectile.getNext() ) {
					projectile.getNext().setPrevious( projectile.getPrevious() );
				}
			}
		}
		
		public function addShape( shape:b2Shape, position:b2Vec2, userData:* = null, density:Number = 1, sensor:Boolean = false, cull:Boolean = true ):b2Body {
			var fd:b2FixtureDef = new b2FixtureDef();
			var bd:b2BodyDef = new b2BodyDef();
			var b:b2Body;
			
			bd.type = b2Body.b2_dynamicBody;
			bd.position = position;
			bd.angle = Math.random() * Math.PI * 2;
			b = world.CreateBody( bd );
			fd.shape = shape;
			fd.density = density;
			fd.isSensor = sensor;
			b.CreateFixture( fd );
			b.SetUserData( userData );
			
			if ( cull ) {
				var next:b2Body = world.GetBodyList();
				var cullList:Vector.<b2Body> = new Vector.<b2Body>();
				do {
					if ( testCollision( b, next ) ) {
						if ( b.GetUserData().type != 'debris' && next.GetUserData().type == 'debris' ) {
							cullList.push( next );
						} else {
							world.DestroyBody( b );
							return null;	
						}	
					}
				} while ( next = next.GetNext() );
				for ( var i:int = 0; i < cullList.length; i++ ) {
					world.DestroyBody( cullList[ i ] );	
				}	
			}
			return b;
		}
		
		public function makeStation( x_:Number, y_:Number ):void {
			
			var sd:b2PolygonShape = new b2PolygonShape();
			var shapes:Vector.<b2Shape> = new Vector.<b2Shape>();
			
			sd.SetAsArray([
				new b2Vec2(3.5, 6.2),
				new b2Vec2(2, 13.1),
				new b2Vec2(-7.8, 10.6),
				new b2Vec2(-13.1, 2.6),
				new b2Vec2(-10.5, -8.4)
				])
			shapes.push( sd.Copy() );
			
			sd.SetAsArray([
				new b2Vec2(-10.5, -8.4),
				new b2Vec2(-2.5, -13.5),
				new b2Vec2(7.4, 2.1),
				new b2Vec2(3.5, 6.2)
				])
			shapes.push( sd.Copy() );
			
			sd.SetAsArray([
				new b2Vec2(12.2, -6.7),
				new b2Vec2(13.8, 1.1),
				new b2Vec2(7.4, 2.1),
				new b2Vec2(-2.5, -13.5),
				new b2Vec2(6.5, -12.3)
				])
			shapes.push( sd.Copy() );
			
			sd.SetAsArray([
				new b2Vec2(8.9, 3.9),
				new b2Vec2(5.6, 8.1),
				new b2Vec2(3.5, 6.2),
				new b2Vec2(7.4, 2.1)
				])
			shapes.push( sd.Copy() );
			
			station = new Station( this, addCompoundShape( shapes, new b2Vec2( x_, y_ ), null, 5, false, 3 ), 100, 100 );
			
			station.setController( new StationController( this, station ) );
			
			addShip( station );
		}
		
		public function addCompoundShape( shapes:Vector.<b2Shape>, position:b2Vec2, userData:* = null, density:Number = 1, sensor:Boolean = false, dock:int = -1, player = false ):b2Body {
			var fd:b2FixtureDef = new b2FixtureDef();
			var bd:b2BodyDef = new b2BodyDef();
			var b:b2Body;
			
			bd.type = b2Body.b2_dynamicBody;
			bd.position = position;
			if (player) bd.bullet = true;
			bd.angle = Math.random() * Math.PI * 2;
			b = world.CreateBody( bd );
			fd.density = density;
			fd.isSensor = sensor;
			
			for ( var i:int = 0; i < shapes.length; i++ ) {
				fd.shape = shapes[ i ];
				if ( i == dock ) {
					b.CreateFixture( fd ).SetUserData( { type: 'dock', station: 1 } );
				} else {
					b.CreateFixture( fd );
				}
			}
			b.SetUserData( userData );
			return b;
		}
		
		public function removeBody( body:b2Body ):void {
			world.DestroyBody( body );
		}
		
		public function setSprite( sprite:Sprite ):void {
			canvas = sprite;
			canvas.x = stageWidth * 0.5;
			canvas.y = stageHeight * 0.65;
			
			var dbgDraw:b2DebugDraw = new CrappyDraw(player);
			dbgDraw.SetSprite(canvas);
			dbgDraw.SetDrawScale(drawScale);
			dbgDraw.SetFillAlpha(0.3);
			dbgDraw.SetLineThickness(1.0);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			world.SetDebugDraw(dbgDraw);
		}
		
		public function setMenuSprite( sprite:Sprite ):void {
			menuSprite = sprite;
			menuSprite.x = stageWidth * 0.5;
			menuSprite.y = stageHeight * 0.5;
		}
		
		public function update():void {
				
			canvas.graphics.clear();
									
			world.Step(timeStep, velocityIterations, positionIterations);
			world.ClearForces();
			
			world.DrawDebugData();
			
			var playerPos:b2Vec2 = player.getLocation();
			var playerAngle:Number = player.getBody().GetAngle();
			
			if ( playerController ) playerController.updateMouse( xmouse + playerPos.x - stageWidth / 2, ymouse + playerPos.y - stageHeight / 2);
			
			var next:Linkable = shipRoot;
			if ( next ) {
				do {
					next.update();
				} while ( next = next.getNext() );
			}
			
			next = projectileRoot;
			if ( next ) {
				do {
					next.update();
				} while ( next = next.getNext() );
			}
			
			next = sfxRoot;
			if ( next ) {
				do {
					( next as Sfx ).draw( canvas, drawScale, player.getLocation() );
					next.update();
					if ( ( next as Sfx ).finished() ) removeSfx( ( next as Sfx ) );
				} while ( next = next.getNext() );
			}
			
			canvas.rotation = 180 - playerAngle * 180 / Math.PI;
			
			updateDebris();
			
			missionController.updateMission();
			
			drawInterface();
			
		}
		
		public function dock( station ):void {
			
			player.destroy();
			playerController = null;
			player = this.station;
		
			dockedAt = 0;
			
		}
		
		public function undock( station ):void {
			
			var stationPos:b2Vec2 = this.station.getBody().GetWorldCenter();
			
			addPlayer( stationPos.x - 18, stationPos.y );
			
		}
		
		public function worldXCoord( x:Number ):Number {
			
			return ( x - player.getLocation().x * drawScale + 320 ) * drawScale;
			
		}
		
		public function worldYCoord( y:Number ):Number {
			
			return ( y - player.getLocation().y * drawScale + 240 ) * drawScale;
			
		}
		
		public function screenXCoord( x:Number ):Number {
			return x - stageWidth / 2;
			return x + player.getLocation().x * drawScale - 320;
			
		}
		
		public function screenYCoord( y:Number ):Number {
			return y - stageHeight / 2;
			return y + player.getLocation().y * drawScale - 240;
			
		}
		
		private function updateMission():void {
			
		}
		
		private function updateDebris():void {
			
			var playerPos:b2Vec2 = player.getLocation();
			
			var body:b2Body = world.GetBodyList();
			
			do {
				
				var pos:b2Vec2 = body.GetPosition();
				
				var xdif:Number = pos.x - playerPos.x
				var ydif:Number = pos.y - playerPos.y;
				
				var allowableDistance:Number = 18 + body.GetMass() * 3;
				
				if ( xdif * xdif + ydif * ydif >= allowableDistance * allowableDistance ) {
					
					if ( body.GetUserData() ) {
					
						if ( body.GetUserData().type == 'debris' ) {
							
							world.DestroyBody( body );
							
						} else if ( body.GetUserData().type == 'proj' ) {
							
							body.GetUserData().parent.destroy();
							
						}
						
					} else {
					
						world.DestroyBody( body );
						
					}
					
				}
				
			} while ( body = body.GetNext() );
			
			var debrisDif:Number = debrisMax - world.GetBodyCount() + ships;
			
			for ( var i:int = 0; i < debrisDif; i++ ) {
				
				var scale:int = 1;
				for ( var j:int = 0; j < 2; j++) { if ( Math.random() < 0.05 ) scale++; }
				
				var sd:b2PolygonShape = new b2PolygonShape();
				sd.SetAsBox( ( Math.random() * 0.4 + 0.1 ) * scale, ( Math.random() * 0.4 + 0.1 ) * scale );
				var rotationRadians:Number = Math.random() * 2 * Math.PI;
				var position:b2Vec2 = new b2Vec2( Math.cos( rotationRadians ) * (Math.random()*5+15) + playerPos.x, Math.sin( rotationRadians ) * (Math.random()*5+15) + playerPos.y );
				
				var b:b2Body = addShape( sd, position, { type: 'debris' } );
				
				if ( b ) {
					
					randomizeMovement( b, 20 );
					
				}
				
			}
			
		}
		
		public function drawLine( p1:b2Vec2, p2:b2Vec2, color:uint = 0xFF0000 ):void {
			
			var offset:b2Vec2 = player.getLocation();
			
			canvas.graphics.lineStyle(1,color,1);
			canvas.graphics.moveTo(( p1.x - offset.x ) * drawScale, ( p1.y - offset.y ) * drawScale );
			canvas.graphics.lineTo(( p2.x - offset.x ) * drawScale, ( p2.y - offset.y ) * drawScale );
			
		}
		
		public function drawCircle( p1:b2Vec2, radius:Number, color:uint = 0xFF0000, alpha:Number = 1.0 ):void {
			
			var offset:b2Vec2 = player.getLocation();
			
			canvas.graphics.lineStyle(1.5,color,alpha);
			canvas.graphics.drawCircle(( p1.x - offset.x ) * drawScale, ( p1.y - offset.y ) * drawScale, radius * drawScale );
			
		}
		
		public function createExplosion( point:b2Vec2, scale:Number ):void {
      var sparks:Number = scale * 20;
      var clouds:Number = scale * 6;
      
      for ( var i:int = 0; i < sparks; i++ ) {
      	addSfx( new SfxLine( point.Copy(), scale * Math.random(), Math.random() * Math.PI * 2 ) );
      }
      
      for ( i = 0; i < clouds; i++ ) {
      	var center:b2Vec2 = point.Copy();
      	//center.x += Math.random() * scale - scale / 2;
      	//center.y += Math.random() * scale - scale / 2;
      	addSfx(new Sfx(center, (scale * Math.random() + scale) / 2, Math.random() * Math.PI * 2));
      }
      
      var next:b2Body = world.GetBodyList();
      if ( next ) {
      	do {
      		var point2:b2Vec2 = next.GetWorldCenter();
      		var xdif:Number = point2.x - point.x;
      		var ydif:Number = point2.y - point.y;
      		var force:b2Vec2 = new b2Vec2( xdif, ydif );
      		force.Multiply( scale * 10 / force.LengthSquared() );
      		next.ApplyForce( force, point2 );
      	} while( next = next.GetNext() );
      }
    }
    
    public function randomizeMovement( body:b2Body, scale:Number = 1 ):void {
    	
    	var angle:Number = Math.random() * Math.PI * 2;
    	
    	var vel:b2Vec2 = new b2Vec2( Math.cos( angle ), Math.sin( angle ) );
    	vel.Multiply( Math.random() * scale );
    	
    	var torque:Number = ( Math.random() * scale - scale / 2 ) * 0.1;
    	
    	body.ApplyForce( vel, body.GetWorldCenter() );
    	body.ApplyTorque( torque );
    	
    }
		
		public function keyPressed( e:KeyboardEvent ):void {
			
			//trace( e.keyCode );
			
			var playerPos:b2Vec2 = player.getBody().GetWorldCenter();
			
			if ( e.keyCode == 69 ) {
				var friend:Ship = addNpc( playerPos.x + Math.random() * 30 - 15, playerPos.y + Math.random() * 30 - 15 );
				friend.setAsAlly();
				friend.setFollowBehavior();
			}
			
			if ( e.keyCode == 70 ) {
				//createExplosion( new b2Vec2( playerPos.x + Math.random() * 10 - 5, playerPos.y + Math.random() * 10 - 5 ), 2 );
				var mission:Mission = missionController.generate(1);
				var location:b2Vec2 = randomiseLocation(player.getLocation().x, player.getLocation().y, 200, false);
				mission.start(this, location.x, location.y);
			}
			
			keys[ e.keyCode ] = true;
			
		}
		
		public function keyReleased( e:KeyboardEvent ):void {
			
			keys[ e.keyCode ] = false;
			
		}
		
		public function mouseMove( e:MouseEvent ):void{
			
			xmouse = e.stageX;
			ymouse = e.stageY;
			
		}
		
		private function testCollision( body1:b2Body, body2:b2Body ):Boolean {
			
			if ( body1 == body2 ) { return false; }
			
			var fix1:b2Fixture = body1.GetFixtureList();
			var fix2:b2Fixture = body2.GetFixtureList();
			
			do {
				
				do {
					
					if ( fix1 == null || fix2 == null ) {
						
						return false;
						
					}
					
					if ( b2Shape.TestOverlap( fix1.GetShape(), body1.GetTransform(), fix2.GetShape(), body2.GetTransform() ) ) {
						
						return true;
						
					}
					
				} while ( fix2 = fix2.GetNext() );
				
			} while( fix1 = fix1.GetNext() );
				
			return false;
			
		}

	}
	
}
