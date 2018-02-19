package Helpers {

  import Box2D.Dynamics.*;
  import Box2D.Collision.*;
  import Box2D.Collision.Shapes.*;
  import Box2D.Dynamics.Joints.*;
  import Box2D.Dynamics.Contacts.*;
  import Box2D.Common.*;
  import Box2D.Common.Math.*;
  
  public function vecToAngle( vec:b2Vec2 ):Number { 
    return Math.atan2( vec.y, vec.x );
  }

}