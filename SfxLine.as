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
  
  public class SfxLine extends Sfx {
    public function SfxLine( point:b2Vec2, scale:Number, angle:Number, color:Number = 0xFF0000 ) {
      super( point, scale, angle, color );
    }
    
    override public function draw( canvas:Sprite, drawScale:Number, offset:b2Vec2 ):void {
      var xvec:Number = Math.cos( angle + Math.PI / 2 );
      var yvec:Number = Math.sin( angle + Math.PI / 2 );
      
      canvas.graphics.lineStyle( 1, color, 1 );
      canvas.graphics.moveTo( ( point.x - offset.x ) * drawScale, ( point.y - offset.y ) * drawScale );
      point.x += xvec * scale; point.y += yvec * scale;
      canvas.graphics.lineTo( ( point.x - offset.x ) * drawScale, ( point.y - offset.y ) * drawScale );
    }
  }
}
