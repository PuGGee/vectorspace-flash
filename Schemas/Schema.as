package Schemas {
  
  public class Schema {
    
    var id:String;
    
    public function Schema( id:String ) {
      this.id = id;
    }
    
    public function getId():String {
      return id;
    }
    
  }
}