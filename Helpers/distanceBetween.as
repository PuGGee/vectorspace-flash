package Helpers {
  import Box2D.Common.Math.b2Vec2;
  
  public function distanceBetween(vec1:b2Vec2, vec2:b2Vec2):int {
    var xDif:Number = vec1.x - vec2.x;
    var yDif:Number = vec1.y - vec2.y;
    return Math.sqrt(xDif * xDif + yDif * yDif);
  }
}