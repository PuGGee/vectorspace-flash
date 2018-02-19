package {
  
  import Schemas.*;
  import Box2D.Common.Math.*;
  import Weapons.*;
  
  public class Data {
    
    static var ships:Vector.<ShipSchema> = new Vector.<ShipSchema>;
    static var weapons:Vector.<WeaponSchema> = new Vector.<WeaponSchema>;
    static var hardware:Vector.<HardwareSchema> = new Vector.<HardwareSchema>;
    
    static var initialized:Boolean = false;
    
    public static function populate() {
      var shipSchema:ShipSchema;
      var weaponSchema:WeaponSchema;
      var hardwareSchema:HardwareSchema;
      
      shipSchema = new ShipSchema( 'Pigeon' );
      shipSchema.setHealth( 50 );
      shipSchema.setArmour( 1 );
      shipSchema.setGraphic( 'ship1' );
      shipSchema.setTorque( 0.3 );
      shipSchema.setThrust( 0.8 );
      shipSchema.setSpeedMax( 10 );
      shipSchema.setShieldRadius( 1 );
      shipSchema.addHardPoint( 0.25, 0.425, 1 );
      shipSchema.addHardPoint( -0.25, 0.425, 1 );
      shipSchema.addHardPoint( 0, 0, 0 );
      shipSchema.addHardPoint( 0, 0, 0 );
      shipSchema.setStructure([[
        new b2Vec2(-0.5, -0.4),
        new b2Vec2(0.5, -0.4),
        new b2Vec2(0.0, 0.85)
        ]]);
      ships.push( shipSchema );
      
      shipSchema = new ShipSchema('Scumar');
      shipSchema.setHealth(150);
      shipSchema.setArmour(3);
      shipSchema.setGraphic('ship2');
      shipSchema.setTorque(1.2);
      shipSchema.setThrust(2.4);
      shipSchema.setSpeedMax(10);
      shipSchema.setShieldRadius(1.5);
      shipSchema.addHardPoint(0.25, 1, 1);
      shipSchema.addHardPoint(-0.25, 1, 1);
      shipSchema.addHardPoint(0.625, -0.25, 1);
      shipSchema.addHardPoint(-0.625, -0.25, 1);
      shipSchema.addHardPoint(0, -1, 1, {start: -Math.PI / 2, finish: Math.PI / 2});
      shipSchema.addHardPoint(0, 0, 0);
      shipSchema.addHardPoint(0, 0, 0);
      shipSchema.addHardPoint(0, 0, 0);
      shipSchema.addHardPoint(0, 0, 0);
      shipSchema.setStructure([[
        new b2Vec2(-0.5, -1),
        new b2Vec2(0.5, -1),
        new b2Vec2(0.5, 0),
        new b2Vec2(0.25, 1),
        new b2Vec2(-0.25, 1),
        new b2Vec2(-0.5, 0)],
        [
        new b2Vec2(0.5, -1),
        new b2Vec2(0.75, -0.5),
        new b2Vec2(0.5, 0)
        ],[
        new b2Vec2(-0.5, 0),
        new b2Vec2(-0.75, -0.5),
        new b2Vec2(-0.5, -1)
        ]]);
      ships.push( shipSchema );
      
      weaponSchema = new WeaponSchema( 'Blaster mk1' );
      weaponSchema.setPower( 0.025 );
      weaponSchema.setCooldown( 5 );
      weaponSchema.setSpeed( 80 );
      weaponSchema.setType( 'tracer' );
      weapons.push( weaponSchema );
      
      weaponSchema = new WeaponSchema( 'Cannon mk1' );
      weaponSchema.setPower( 0.15 );
      weaponSchema.setCooldown( 10 );
      weaponSchema.setSpeed( 40 );
      weaponSchema.setType( 'tracer' );
      weapons.push( weaponSchema );
      
      weaponSchema = new WeaponSchema( 'Cannon mk2' );
      weaponSchema.setPower( 0.035 );
      weaponSchema.setCooldown( 14 );
      weaponSchema.setSpeed( 160 );
      weaponSchema.setType( 'tracer' );
      weapons.push( weaponSchema );
      
      weaponSchema = new WeaponSchema( 'Plasma mk1' );
      weaponSchema.setPower( 0.1 );
      weaponSchema.setCooldown( 2 );
      weaponSchema.setSpeed( 20 );
      weaponSchema.setType( 'tracer' );
      weapons.push( weaponSchema );
      
      weaponSchema = new WeaponSchema( 'Beamer mk1' );
      weaponSchema.setPower( 0.05 );
      weaponSchema.setCooldown( 20 );
      weaponSchema.setType( 'lazer' );
      weapons.push( weaponSchema );
      
      weaponSchema = new WeaponSchema( 'Beamer mk2' );
      weaponSchema.setPower( 0.2 );
      weaponSchema.setCooldown( 0 );
      weaponSchema.setType( 'lazer' );
      weapons.push( weaponSchema );
      
      hardwareSchema = new HardwareSchema( 'Shield mk1' );
      hardwareSchema.setShield( 25 );
      hardwareSchema.setRegen( 0.075 );
      hardware.push( hardwareSchema );
      
      hardwareSchema = new HardwareSchema( 'Armour mk1' );
      hardwareSchema.setArmour( 8 );
      hardware.push( hardwareSchema );
      
      hardwareSchema = new HardwareSchema( 'Engine mk1' );
      hardwareSchema.setTorque( 0.5 );
      hardwareSchema.setThrust( 1 );
      hardwareSchema.setSpeedMax( 10 );
      hardware.push( hardwareSchema );
      
      initialized = true;
      
    }
    
    public static function getShipSchemas():Vector.<ShipSchema> {
      if ( !initialized ) populate();
      return ships;
    }
    
    public static function getWeaponSchemas():Vector.<WeaponSchema> {
      if ( !initialized ) populate();
      return weapons;
    }
    
    public static function getHardwareSchemas():Vector.<HardwareSchema> {
      if ( !initialized ) populate();
      return hardware;
    }
    
    public static function randomShip():ShipSchema {
      if ( !initialized ) populate();
      var i:int = Math.floor( Math.random() * ships.length );
      return ships[ i ];
    }
    
    public static function randomWeapon():WeaponSchema {
      if ( !initialized ) populate();
      var i:int = Math.floor( Math.random() * weapons.length );
      return weapons[ i ];
    }
    
    public static function randomHardware():HardwareSchema {
      if ( !initialized ) populate();
      var i:int = Math.floor( Math.random() * hardware.length );
      return hardware[ i ];
    }
    
  }
}