package  {
  public class HardPoint {
    var x:Number;
    var y:Number;
    var pointType:int;
    var arc:Object;
    
    public function HardPoint(x:Number, y:Number, pointType:int, arc:Object) {
      this.x = x;
      this.y = y;
      this.pointType = pointType;
      this.arc = arc;
    }
    
    public function _x():Number {
      return x;
    }
    
    public function _y():Number {
      return y;
    }
    
    public function getPointType():Number {
      return pointType;
    }
    
    public function isTurret():Boolean {
      return !!arc;
    }
    
    public function getArc():Object {
      return arc;
    }
  }
}