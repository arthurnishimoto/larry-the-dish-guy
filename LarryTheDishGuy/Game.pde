class Game {
  
  private Player   rightPlayer;
  private Player   leftPlayer;
  private Counter  theCounter;
  private Table    []theTable;
  
  private Intro theIntro;
  
  private Dish testDish;
  private PApplet theApplet;
  
  Game() {
  }
  
  Game(PApplet theApplet) {
    this.theApplet = theApplet;
    
    rightPlayer   = new Player("Player1", false);
    leftPlayer    = new Player("Player2", true);
    theCounter    = new Counter();
    isServer      = true;
    
    theTable      = new Table[6];
    theIntro      = new Intro(theApplet);
    
    // Left tables
    for( int i = 0; i < 3; i++ ) {
      int yTable = (int) map(i, 0, 2, 50, height - 50);
      theTable[i] = new Table(70, yTable, 30, 30);
    }
    
    // Right tables
    for( int i = 3; i < 6; i++ ) {
      int yTable = (int) map(i, 3, 5, 50, height - 50);
      theTable[i] = new Table(width - 70, yTable, 30, 30);
    }
  }
  
  /**
   * Start the game!
   */
  public void start() {
    theIntro.hide();
    theCounter.startCounting();
  }
  
  public void draw() {
    
    if( theIntro.enabled ) {
      theIntro.draw();
    }
    else { // Game has started!
      theCounter.tick();
      
      // Draw the tables
      for( int i = 0; i < theTable.length; i++ ) {
       theTable[i].checkCollision(leftPlayer);
       theTable[i].checkCollision(rightPlayer);
       theTable[i].draw();
      }
      
      // Draw the players
      rightPlayer.draw( theCounter.getTime() );
      leftPlayer.draw( theCounter.getTime() );
      
      if( theCounter.gameTimePassed() ) 
        println ("GAME END");
    }     
  }

  public void handleKeyEvent() {
    if( key == CODED && keyCode == LEFT ) {
      if( isServer )  rightPlayer.goLeft();
      else            leftPlayer.goLeft();
    }
    else if( key == CODED && keyCode == RIGHT ) {
      if( isServer )  rightPlayer.goRight();
      else            leftPlayer.goRight();
    }
  }
  
  // Overidden
  public void handleKeyEvent(int state) {
    switch(state){
      case(PRESSED):
        break;
      case(DRAGGED):
        break;
      case(RELEASED):
        break;
    }
  }
}
