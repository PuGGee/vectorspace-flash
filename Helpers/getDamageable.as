package Helpers {

  import Box2D.Dynamics.*;
  import Box2D.Collision.*;
  import Box2D.Collision.Shapes.*;
  import Box2D.Dynamics.Joints.*;
  import Box2D.Dynamics.Contacts.*;
  import Box2D.Common.*;
  import Box2D.Common.Math.*;
  
  public function getDamageable( fixture:b2Fixture ):Damageable {
     var userData:* = fixture.GetUserData();
     if ( userData && userData.type == 'shield' ) return userData.parent;
     userData = fixture.GetBody().GetUserData();
     if ( userData && ( userData.type == 'ship' || userData.type == 'player' ) ) return userData.parent;
     else return null;
  }

}