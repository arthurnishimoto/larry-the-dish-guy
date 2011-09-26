class Game {
  

  private Player   rightPlayer;
  private Player   leftPlayer;
  private Counter  theCounter;
  private Table    []theTable;
  
  private Intro theIntro;
  
  private Dish testDish;
  private PApplet theApplet;
  
  private PImage lastFrame;
  

  Game() {
  }
  

  Game(PApplet theApplet) {
    this.theApplet = theApplet;
    

    rightPlayer   = new Player("Player1", false);

    leftPlayer    = new Player("Player2", true);

    theCounter    = new Counter();
    isServer      = true;
    

    theTable      = new Table[8];
    theIntro      = new Intro(theApplet);

    // Left tables
    for ( int i = 0; i < 4; i++ ) {
      int yTable = (int) map(i, 0, 3, 50, height - 50);
      theTable[i] = new Table(70, yTable, 30, 30);
    }

    // Right tables
    for ( int i = 4; i < 8; i++ ) {
      int yTable = (int) map(i, 4, 7, 50, height - 50);
      theTable[i] = new Table(width - 70, yTable, 30, 30);
    }
  }

  /**
   * Start the game!
   */
  public void start() {
    theIntro.isServer();
    theIntro.hide();
    theCounter.startCounting();

    // Free up intro memory ??
  }

  public void draw() {

    if ( theIntro.enabled ) {
      theIntro.draw();
    }
    else { // Game has started!
      if ( !theCounter.gameTimePassed() ) {
        theCounter.tick();
        imageMode(CORNER);
        image(backgroundImage, 0, 0, width, height);
  
        // Draw the tables
        for ( int i = 0; i < theTable.length; i++ ) {
          if( theTable[i].checkCollision(leftPlayer) ) {
            leftPlayer.addDish();
          }
          
          if( theTable[i].checkCollision(rightPlayer) ) {
            rightPlayer.addDish();
          }
          theTable[i].draw();
        }
  
        // Draw the players
        rightPlayer.draw( theCounter.getTime() );
        leftPlayer.draw( theCounter.getTime() );
        lastFrame = get();
      }
      else {
        imageMode(CORNER);
        image(lastFrame, 0, 0);
        
        if( isServer ) {
          // Draw winner - loser
          if( rightPlayer.winner == true && leftPlayer.winner == true ) { // Draw
            textMode(CENTER);
            text("DRAW", 320, 240);
          }
          else if( rightPlayer.winner == true ) {
            textMode(CENTER);
            text("WINNER", 320, 240);
          }
          else { 
            textMode(CENTER);
            text("LOSER", 320, 240);
          }
        }
        else { // Send to client whether he won or not
        }
      }
    }
  }
    

  public void handleKeyEvent() {
    if ( key == CODED && keyCode == LEFT ) {
      if ( isServer ) {
        if ( leftPlayer.x + 35 < rightPlayer.x ) 
          rightPlayer.goLeft();
      }
      else {
        if ( leftPlayer.x > 150 )
          leftPlayer.goLeft();
      }
    }
    else if ( key == CODED && keyCode == RIGHT ) {
      if ( isServer ) {
        if ( rightPlayer.x < 450 ) 
          rightPlayer.goRight();
      }
      else {
        if ( rightPlayer.x - 35 > leftPlayer.x )
          leftPlayer.goRight();
      }
    }

    if ( key == ' ' ) {
      if ( isServer ) { //player is the server
        rightPlayer.stateId = 3;
        if ( leftPlayer.x + 35 > rightPlayer.x && leftPlayer.x + 35 < rightPlayer.x + 20 ) {
          leftPlayer.stateId = 2;
          rightPlayer.goRight();
          leftPlayer.goLeft();
          leftPlayer.goLeft();
          leftPlayer.goLeft();
        }
      } 
      else {  //player is not the server
        leftPlayer.stateId = 3;
        if ( leftPlayer.x + 35 > rightPlayer.x && leftPlayer.x + 35 < rightPlayer.x + 20 ) {
          rightPlayer.stateId = 2;
          leftPlayer.goRight();
          rightPlayer.goLeft();
          rightPlayer.goLeft();
          rightPlayer.goLeft();
        }
      }
    }
  }

  // Overidden
  public void handleKeyEvent(int state) {
    switch(state) {
      case(PRESSED):
      break;
      case(DRAGGED):
      break;
      case(RELEASED):
      if ( key == CODED && keyCode == LEFT ) {
        if ( isServer )  rightPlayer.stopForce();
        else            leftPlayer.stopForce();
      }
      else if ( key == CODED && keyCode == RIGHT ) {
        if ( isServer )  rightPlayer.stopForce();
        else            leftPlayer.stopForce();
      }
      break;
    }
  }
}
