class Counter {

  private int millisPassed;
  private int startingMillis;
  private boolean counting;
  
  Counter() {
    counting = false;
    millisPassed = 0;
  }
  
  public void startCounting() {
    startingMillis = millis();
    counting = true;
  }
  
  public void stopCounting() {
    counting = false;
  }
  
  public void tick() {
    if( counting ) 
      millisPassed = millis() - startingMillis;
  }
  
  public boolean gameTimePassed() {
    if ( millisPassed > 30000 ) return true;
    
    return false;
  }
  
  public int getTime() {
    return millisPassed;
  }
  
}
