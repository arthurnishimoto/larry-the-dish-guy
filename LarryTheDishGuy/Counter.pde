class Counter {

  private int millisPassed;
  private boolean counting;
  
  Counter() {
    counting = false;
    millisPassed = 0;
  }
  
  public void startCounting() {
    counting = true;
  }
  
  public stopCounting() {
    counting = false;
  }
  
  public void tick() {
    if( counting ) 
      millisPassed += millis();
  }
  
  public boolean gameTimePassed() {
    if ( millisPassed > 30000 ) return true;
    
    return false;
  }
  
}
