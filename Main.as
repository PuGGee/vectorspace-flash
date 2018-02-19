package{

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
	
	import flash.display.MovieClip;

	public class Main extends MovieClip{
		
		var controller:WorldController;
		var canvas:Sprite;
		var menuSprite:Sprite;
		public static var stage;
		public function Main() {
			
			addEventListener( Event.ADDED_TO_STAGE, init, false, 0, true );
			
		}
		
		private function init( e:Event ):void {
			
			removeEventListener( Event.ADDED_TO_STAGE, init );
			Main.stage = stage;
			controller = new WorldController(480, 800);
			
			canvas = new Sprite();
			addChild( canvas );
			controller.setSprite( canvas );
			
			menuSprite = new Sprite();
			addChild( menuSprite );
			controller.setMenuSprite( menuSprite );
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, controller.keyPressed );
			stage.addEventListener( KeyboardEvent.KEY_UP, controller.keyReleased );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, controller.mouseMove );
			addEventListener( Event.ENTER_FRAME, update );
		
		}
		
		public function update( e:Event ):void {
			
			controller.update();
			
		}
		
	}
	
}
