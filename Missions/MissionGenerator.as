package Missions {
  
  public class MissionGenerator {
    var controller:WorldController;
    
    public function MissionGenerator(controller:WorldController) {
      this.controller = controller;
    }
    
    public function generate(difficulty:Number):Mission {
      var mission:Mission = new KillDem();
      mission.setBounty(100);
      return mission;
    }
  }
}