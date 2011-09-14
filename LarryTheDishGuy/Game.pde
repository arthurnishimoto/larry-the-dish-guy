class Game {
  
  Player rightPlayer;
  Player leftPlayer;
  Counter theCounter;
  
  Game() {
    rightPlayer   = new Player();
    leftPlayer    = new Player();
    theCounter    = new Counter();
  }

  public void draw() {
    theCounter.tick();
    
    
    if( theCounter.gameTimePassed() ) 
      println ("GAME END"); 
  }  
}
