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
  import Schemas.*;
  
  public class Station extends Ship {

    public static var refreshRate:int = 18000;

    var counter:int;
    
    var stock:Vector.<Schema>;

    public function Station( listener:WorldController, body:b2Body, healthMax:Number, armourMax:Number ) {
      
      super( listener, body, healthMax, armourMax, 50, 50, 5 );
      
      stock = new Vector.<Schema>();
      generateStock();
      
      counter = 0;
      
    }
    
    override public function update():void {
      
      super.update();
      
      if ( counter >= refreshRate ) {
        
        counter = 0;
        
        generateStock();
        
      } else {
        counter++;
      }
      
    }
    
    public function generateStock():void {
      
      stock = new Vector.<Schema>();
      stock.push( Data.randomWeapon() );
      stock.push( Data.randomWeapon() );
      stock.push( Data.randomHardware() );
      stock.push( Data.randomHardware() );
      
    }
    
    public function getStock():Vector.<Schema> {
      return stock;
    }
    
  }
}
      