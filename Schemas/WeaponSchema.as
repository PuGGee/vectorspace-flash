package Schemas {
  
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
  
  public class WeaponSchema extends Schema {
    
    var power:Number;
    var cooldown:Number;
    var speed:Number;
    var type:String;
    
    public function WeaponSchema( id:String ) {
      super( id );
    }
    
    //the damaging power of the weapon
    public function setPower( power:Number ):void {
      this.power = power;
    }
    
    //the time in between shots (measured in frames)
    public function setCooldown( cooldown:Number ):void {
      this.cooldown = cooldown;
    }
    
    //the speed of the projectile (doesn't apply for lazer weapons)
    public function setSpeed( speed:Number ):void {
      this.speed = speed;
    }
    
    //the weapon type (tracer, lazer)
    public function setType( type:String ):void {
      this.type = type;
    }
    
    public function getPower():Number {
      return power;
    }
    
    public function getCooldown():Number {
      return cooldown;
    }
    
    public function getSpeed():Number {
      return speed;
    }
    
    public function getType():String {
      return type;
    }
    
  }
}