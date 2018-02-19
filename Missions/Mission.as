package Missions {
  
  public class Mission {
    var bounty:Number = 0;
    
    public function setBounty(bounty:Number):void {
      this.bounty = bounty;
    }
    
    public function start(controller:WorldController, xLocation:Number, yLocation:Number):void {
      
    }
    
    public function testWinConditions():Boolean {
      return true
    }
    
    public function finishAndGetBounty():int {
      return bounty;
    }
  }
}
