package  {
  
  import Box2D.Dynamics.*
  import Box2D.Collision.*
  import Box2D.Collision.Shapes.*
  import Box2D.Dynamics.Joints.*
  import Box2D.Dynamics.Contacts.*
  import Box2D.Common.Math.*
  import flash.events.*;
  import flash.display.*;
  import flash.text.*;
  import General.*
  
  public class Sfx extends Linkable {
    var point:b2Vec2;
    var speed:b2Vec2;
    var scale:Number;
    var angle:Number;
    var color:Number;

    public function Sfx( point:b2Vec2, scale:Number, angle:Number, color:Number = 0xFF0000 ) {
      this.point = point;
      this.scale = scale;
      this.angle = angle;
      this.color = color;
      
      var xvec:Number = Math.cos( angle + Math.PI / 2 );
      var yvec:Number = Math.sin( angle + Math.PI / 2 );
      var dist:Number = Math.random() * scale * 0.15;
      speed = new b2Vec2(xvec * dist, yvec * dist);
    }
    
    public override function update():void {
      scale -= 0.1;
    }
    
    public function draw( canvas:Sprite, drawScale:Number, offset:b2Vec2 ):void {
      canvas.graphics.lineStyle( 0, 0, 0 );
      canvas.graphics.beginFill( color );
      canvas.graphics.drawEllipse( ( point.x - offset.x - scale / 2 ) * drawScale, ( point.y - offset.y - scale / 2 ) * drawScale, ( scale ) * drawScale, ( scale ) * drawScale );
      canvas.graphics.endFill();
      point.x += speed.x;
      point.y += speed.y;
    }
    
    public function finished():Boolean {
      if ( scale <= 0 ) {
        return true;
      } else {
        return false; 
      } 
    }
  }
}
