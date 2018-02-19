package  {
  
  import Box2D.Dynamics.*
  import Box2D.Collision.*
  import Box2D.Collision.Shapes.*
  import Box2D.Dynamics.Joints.*
  import Box2D.Dynamics.Contacts.*
  import Box2D.Common.Math.*
  import flash.events.*
  import flash.display.*
  import flash.text.*
  import General.*
  import Helpers.*
  
  public class Shield implements Damageable {
    
    var health:Number
    var healthMax:Number
    
    var regen:Number
    var cooling:Boolean
    
    var intensity:Number
    
    var fixture:b2Fixture
    
    var ship:Ship
    
    public function Shield( fixture:b2Fixture, ship:Ship, health:Number, regen:Number ) {
      
      this.fixture = fixture
      this.fixture.SetUserData( { type: 'shield', parent: this } )
      this.ship = ship
      this.health = health
      this.regen = regen
      healthMax = health
      
      intensity = 0
      
      cooling = false
      
    }
    
    public function getHealth():Number {
      if ( cooling ) {
        return 0
      } else {
        return health
      }
    }
    
    public function getMaxHealth():Number {
      return healthMax
    }
    
    public function reduceHealth( val:Number ):void {
      health -= val
    }
    
    public function update():void {
      if ( intensity > 5 ) {
        intensity = 5
      }
      if ( intensity > 0 ) {
        if ( !cooling ) ship.listener.drawCircle( fixture.GetBody().GetPosition(), ( fixture.GetShape() as b2CircleShape ).GetRadius(), 0x00FFFF, intensity / 5 )
        intensity = intensity * 0.9
      } else if ( intensity < 0 ) {
        intensity = 0
      }
      health += regen
      if ( health > healthMax && !cooling ) health = healthMax
      if ( health <= 0 && !cooling ) {
        health = 0
        cooling = true
        fixture.SetSensor( true )
      }
      if ( health >= healthMax && cooling ) {
        fixture.SetSensor( false )
        health = healthMax / 2
        cooling = false
        intensity = 5
      }
    }
    
    public function shock( impulse:Number, point:b2Vec2, normal:b2Vec2 ):void {
      
      damageShip( impulse, point, normal )
      
    }
    
    public function damageShip( damage:Number, point:b2Vec2, normal:b2Vec2 ):void {
      
      health -= damage
      
      intensity += damage
      
      var angle:Number = vecToAngle( normal.GetNegative() )
      for ( var i:Number = 0 ; i < Math.round( damage * 4 ); i++ ) {
        ship.listener.addSfx( new SfxLine( point.Copy(), 0.5 * Math.random(), angle - Math.random() * Math.PI, 0x00FFFF ) )
      }
      
    }
    
  }
}