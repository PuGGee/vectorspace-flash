package Weapons {
  import Box2D.Dynamics.*;
  import Box2D.Common.Math.b2Vec2;
  import Helpers.*;
  
  public class Turret extends Weapon {
    var arc:Object;
    var turn:Number;
    
    public function Turret(listener:WorldController, body:b2Body, x_:Number, y_:Number, power:Number, cooldown:Number, speed:Number, arc:Object, type:String = 'tracer') {
      super(listener, body, x_, y_, power, cooldown, speed, type);
      this.arc = arc;
      this.turn = 0;
    }
    
    override public function update():void {
      super.update();
    }
    
    override public function getAngle():Number {
      return super.getAngle() + turn;
    }
    
    private function lookAt(location:b2Vec2):void {
      var pos:b2Vec2 = body.GetPosition();

      var targetAngle:Number = Math.atan2(location.y - pos.y, location.x - pos.x);
      var adif:Number = targetAngle - getNangle(getAngle());
      adif = getNangle(adif);
    }
  }
}