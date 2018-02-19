package  {
  
  import Box2D.Dynamics.*;
  import Box2D.Collision.*;
  import Box2D.Collision.Shapes.*;
  import Box2D.Dynamics.Joints.*;
  import Box2D.Dynamics.Contacts.*;
  import Box2D.Common.*;
  import Box2D.Common.Math.*;
  import flash.events.*;
  import flash.display.*;
  import flash.text.*;
  import General.*
  
  public class CrappyDraw extends b2DebugDraw {
    //this class is dumb and i hate it
    var player:Ship;
    
    public function CrappyDraw(player) {
      this.player = player;
    }
    
    override public function DrawSolidCircle(center:b2Vec2, radius:Number, axis:b2Vec2, color:b2Color):void {
    }
    
    override public function DrawCircle(center:b2Vec2, radius:Number, color:b2Color):void {
    }
    
    override public function DrawSolidPolygon(vertices:Vector.<b2Vec2>, vertexCount:int, color:b2Color):void {
      for (var i:Number = 0; i < vertices.length; i++) {
        vertices[i].Subtract(player.getBody().GetPosition());
      }
      super.DrawSolidPolygon(vertices, vertexCount, color);
    }
    
  }
}