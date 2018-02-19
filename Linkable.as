package  {
	
	public class Linkable implements EntityController {
		
		var next:Linkable;
		var previous:Linkable;
		
		public function getNext():Linkable {
			
			return next;
			
		}
		
		public function getPrevious():Linkable {
			
			return previous;
			
		}
		
		public function setNext( entity:Linkable ):void {
			
			next = entity;
			
		}
		
		public function setPrevious( entity:Linkable ):void {
			
			previous = entity;
			
		}
		
		public function update():void {
		}

	}
	
}
