package UI {
  import Box2D.Common.Math.*;
  import flash.display.*;
  import flash.text.*;
  import General.*
  
  public class EnemyMarkers extends UIElement {
    public function EnemyMarkers(controller:WorldController, color:Number = 0xFF0000) {
      super(controller, color);
    }
    
    override public function draw(canvas:Sprite):void {
      var screenCenter:b2Vec2 = getScreenCenter();
      var next:Ship = (controller.shipRoot as Ship);
      if ( next ) {
        do {
          if (next != controller.player) testScreenPos(canvas, next, screenCenter);
        } while ( next = (next.getNext() as Ship) );
      }
    }
    
    public function drawMarker(canvas:Sprite, point:b2Vec2):void {
      canvas.graphics.beginFill( color );
      canvas.graphics.drawRect( point.x-10, point.y-10, 20, 20 );
      canvas.graphics.endFill();
    }
    
    private function testScreenPos(canvas:Sprite, ship:Ship, screenCenter:b2Vec2):void {
      var shipPos:b2Vec2 = ship.getBody().GetPosition();
      
      var xDif:Number = shipPos.x - screenCenter.x;
      var yDif:Number = shipPos.y - screenCenter.y;
      
      var screenX:Number = -(Math.cos(playerAngle()) * xDif + Math.sin(playerAngle()) * yDif) * WorldController.drawScale;
      var screenY:Number = (Math.sin(playerAngle()) * xDif - Math.cos(playerAngle()) * yDif) * WorldController.drawScale;
      
      if (Math.abs(screenX) * 2 > controller.stageWidth
        || Math.abs(screenY) * 2 > controller.stageHeight) {
        drawMarker(canvas, getIntersection(screenX, screenY));
      }
    }
    
    private function getIntersection(screenX:Number, screenY:Number):b2Vec2 {
      var width:Number = ellipseDimensions().x;
      var height:Number = ellipseDimensions().y;
      var ratio:Number = Math.abs(screenY / screenX);
      var xIntersection:Number = Math.sqrt(1/(1/(width*width)+ratio*ratio/(height*height)));
      var yIntersection:Number = Math.sqrt((1 - xIntersection*xIntersection/(width*width))*height*height);
      
      if (screenX < 0) xIntersection = -xIntersection;
      if (screenY < 0) yIntersection = -yIntersection;
      return new b2Vec2(xIntersection, yIntersection);
    }
    
    private function ellipseDimensions():b2Vec2 {
      return new b2Vec2(controller.stageWidth / 2 * 0.9,
                        300 );
                        //controller.stageHeight / 2 * 0.9);
    }
    
    private function playerPos():b2Vec2 {
      return controller.player.getBody().GetPosition();
    }
    
    private function playerAngle():Number {
      return controller.player.getBody().GetAngle();
    }
    
    private function realDistanceToCenter():Number {
      return controller.stageHeight * 0.15 / WorldController.drawScale;
    }
    
    private function getScreenCenter():b2Vec2 {
      var xVector:Number = Math.sin(-playerAngle()) * realDistanceToCenter();
      var yVector:Number = Math.cos(-playerAngle()) * realDistanceToCenter();
      
      return new b2Vec2(playerPos().x + xVector, playerPos().y + yVector);
    }
  }
}
