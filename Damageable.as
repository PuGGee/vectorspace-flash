package  {

  import Box2D.Dynamics.*;
  import Box2D.Collision.*;
  import Box2D.Collision.Shapes.*;
  import Box2D.Dynamics.Joints.*;
  import Box2D.Dynamics.Contacts.*;
  import Box2D.Common.*;
  import Box2D.Common.Math.*;
  
  public interface Damageable {
    
    function shock( impulse:Number, point:b2Vec2, normal:b2Vec2 ):void;
    
    function damageShip( impulse:Number, point:b2Vec2, normal:b2Vec2 ):void;
    
  }

}