package Controllers {
  
  import Missions.*;
  
  public class MissionController {
    var controller:WorldController;
    private var mission:Mission;
    
    public function MissionController(controller:WorldController) {
      this.controller = controller;
    }
    
    public function generate(difficulty:Number):Mission {
      mission = new KillDem();
      mission.setBounty(100);
      return mission;
    }
    
    public function updateMission():void {
      if (mission && mission.testWinConditions()) {
        controller.playerState.money += mission.finishAndGetBounty();
        mission = null;
        trace('you did it!');
      }
    }
  }
}