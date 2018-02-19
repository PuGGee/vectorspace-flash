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
  
  public class ShipSchema extends Schema {
    var hardPoints:Vector.<HardPoint> = new Vector.<HardPoint>();
    
    var structurePoints:Array;
    
    var health:Number;
    var armour:Number;
    var graphic:String;
    
    var torque:Number;
    var thrust:Number;
    var speedMax:Number;
    
    var shieldRadius:Number;
    
    public function ShipSchema( id:String ) {
      super( id );
    }
    
    public function setHealth( health:Number ):void {
      this.health = health;
    }
    
    public function setArmour( armour:Number ):void {
      this.armour = armour;
    }
    
    public function setGraphic( graphic:String ):void {
      this.graphic = graphic;
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
    
    public function setShieldRadius(shieldRadius:Number):void {
      this.shieldRadius = shieldRadius;
    }
    
    public function addHardPoint(x:Number, y:Number, size:int, arc:Object = null):void {
      hardPoints.push(new HardPoint(x, y, size, arc));
    }
    
    public function setStructure(structurePoints:Array):void {
      this.structurePoints = structurePoints;
    }
    
    public function getHealth():Number {
      return health;
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
    
    public function getShieldRadius():Number {
      return shieldRadius;
    }
    
    public function getHardPoints():Vector.<HardPoint> {
      return hardPoints;
    }
    
    public function getStructure():Array {
      return structurePoints;
    }
  }
}