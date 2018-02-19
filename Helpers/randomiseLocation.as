package Helpers {
  import Box2D.Common.Math.*;
  
  public function randomiseLocation(_x:Number, _y:Number, mag:Number, randomiseDistance = true):b2Vec2 {
    var angle:Number = Math.random() * Math.PI * 2;
    var distance:Number = randomiseDistance ? Math.random() * mag : mag;
    var newX:Number = _x + Math.cos(angle) * distance;
    var newY:Number = _y + Math.sin(angle) * distance;
    return new b2Vec2(newX, newY);
  }
}