package  {
  
  import Schemas.*;
  
  public class PlayerState {
    
    public var ship:ShipSchema;
    public var cargo:Vector.<Schema>;
    public var hardware:Vector.<Schema>;
    public var money:int;
    
    public function PlayerState( ship:ShipSchema ) {
      this.ship = ship;
      cargo = new Vector.<Schema>();
      hardware = new Vector.<Schema>();
      money = 0;
    }
    
  }
}