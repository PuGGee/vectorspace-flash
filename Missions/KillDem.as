package Missions {
  import Box2D.Common.Math.*;
  import General.*;
  import Helpers.*;
  
  public class KillDem extends Mission {
    var targets:Vector.<Ship>;
    
    override public function testWinConditions():Boolean {
      var won:Boolean = true;
      for (var i:int = targets.length - 1; i >= 0; i--) {
        var target:Ship = targets[i];
        if (target.dead()) { removeTarget(i); } else { won = false; }
      }
      return won;
    }
    
    public function removeTarget(index:int):void {
      targets.splice(index, 1);
    }
    
    override public function start(controller:WorldController, xLocation:Number, yLocation:Number):void {
      var enemyNum:int = rand(3) + 20;
      targets = new Vector.<Ship>();
      for (var i:int = 0; i < enemyNum; i++) {
        var randomLocation:b2Vec2 = randomiseLocation(xLocation, yLocation, 10);
        var ship:Ship = controller.addNpc(randomLocation.x, randomLocation.y);
        ship.setAsEnemy();
        targets.push(ship);
      }
    }
  }
}
