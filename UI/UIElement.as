package UI {
  import flash.display.*;
  import flash.text.*;
  import General.*
  
  public class UIElement {
    var controller:WorldController;
    var color:Number;

    public function UIElement(controller:WorldController, color:Number = 0xFF0000) {
      this.controller = controller;
      this.color = color;
    }
    
    public function draw(canvas:Sprite):void {
    }
  }
}