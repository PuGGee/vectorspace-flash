package Helpers {
  public function getNangle( angle:Number ):Number {
    var nangle:Number = ( angle + Math.PI / 2 ) % ( Math.PI * 2 );
    if ( nangle > Math.PI ) {
      nangle = nangle - Math.PI * 2;  
    }
    if ( nangle < -Math.PI ) {
      nangle = nangle + Math.PI * 2;  
    }
    return nangle;
  }
}