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
  
  public class HardwareSchema extends Schema {
    
    var shield:Number = 0;
    var regen:Number = 0;
    var armour:Number = 0;
    var torque:Number = 0;
    var thrust:Number = 0;
    var speedMax:Number = 0;
    
    public function HardwareSchema( id:String ) {
      super( id );
    }
    
    public function setShield( shield:Number ):void {
      this.shield = shield;
    }
    
    public function setRegen( regen:Number ):void {
      this.regen = regen;
    }
    
    public function setArmour( cooldown:Number ):void {
      this.armour = armour;
    }
    
    public function setTorque( torque:Number ):void {
      this.torque = torque;
    }
    
    public function setThrust( thrust:Number ):void {
      this.thrust = thrust;
    }
    
    public function setSpeedMax( speedMax:Number ):void {
      this.speedMax = speedMax;
    }
    
    public function getShield():Number {
      return shield;
    }
    
    public function getRegen():Number {
      return regen;
    }
    
    public function getArmour():Number {
      return armour;
    }
    
    public function getTorque():Number {
      return torque;
    }
    
    public function getThrust():Number {
      return thrust;
    }
    
    public function getSpeedMax():Number {
      return speedMax;
    }
    
  }
}