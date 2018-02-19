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
  import Weapons.*;
  import Schemas.*;
  
  public class ShipFactory {
    var listener:WorldController;
    
    public function ShipFactory( listener:WorldController ) {
      this.listener = listener; 
    }
    
    public function make( position:b2Vec2, shipSchema:ShipSchema, hardware:Vector.<Schema>, player:Boolean = false ):Ship {
      var sd:b2PolygonShape = new b2PolygonShape();
      var shapes:Vector.<b2Shape> = new Vector.<b2Shape>();
      var b:b2Body;
      
      for (var i:int = 0; i < shipSchema.getStructure().length; i++) {
        sd.SetAsArray(shipSchema.getStructure()[i]);
        shapes.push(sd.Copy());
      }
      b = listener.addCompoundShape(shapes, position, null, 0.5, false, -1, player);
      
      var weapons:Vector.<Weapon> = new Vector.<Weapon>();
      var shield:Number = 0;
      var regen:Number = 0;
      var armour:Number = 0;
      var torque:Number = 0;
      var thrust:Number = 0;
      var speedMax:Number = 0;
      
      var hardPoints:Vector.<HardPoint> = shipSchema.getHardPoints();
      for (i = 0; i < hardware.length; i++ ) {
        if ( hardware[ i ] is WeaponSchema ) {
          var weapon:WeaponSchema = hardware[ i ] as WeaponSchema;
          var hardPoint:HardPoint = hardPoints[ i ];
          if (hardPoint.isTurret()) {
            weapons.push(new Turret(listener, b, hardPoint._x(), hardPoint._y(), weapon.getPower(), weapon.getCooldown(), weapon.getSpeed(), {start: hardPoint.getArc().start, finish: hardPoint.getArc().finish}, weapon.getType()));
          } else {
            weapons.push(new Weapon(listener, b, hardPoint._x(), hardPoint._y(), weapon.getPower(), weapon.getCooldown(), weapon.getSpeed(), weapon.getType()));
          }
        } else if ( hardware[ i ] is HardwareSchema ) {
          var item:HardwareSchema = hardware[ i ] as HardwareSchema;
          shield += item.getShield();
          regen += item.getRegen();
          armour += item.getArmour();
          torque += item.getTorque();
          thrust += item.getThrust();
          speedMax += item.getSpeedMax();
        }
      }
      var ship:Ship = new Ship( listener, b, shipSchema.getHealth(), shipSchema.getArmour() + armour, shipSchema.getTorque() + torque, shipSchema.getThrust() + thrust, shipSchema.getSpeedMax() + speedMax );
      if ( player ) {
        b.SetUserData( { type: 'player', parent: ship } );
      } else {
        b.SetUserData( { type: 'ship', parent: ship } );
      }
      if ( shield > 0 ) {
        var shieldShape:b2CircleShape = new b2CircleShape( shipSchema.getShieldRadius() );
        var shieldFixture:b2Fixture = b.CreateFixture2(shieldShape, 0);
        ship.setShield( new Shield( shieldFixture, ship, shield, regen ) );
      }
      for ( i = 0; i < weapons.length; i++ ) {
        ship.addWeapon( weapons[ i ] );
      }
      return ship; 
    }
  }
}