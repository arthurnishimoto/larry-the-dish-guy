class Game {
  

  private Player   rightPlayer;
  private Player   leftPlayer;
  private Counter  theCounter;
  private Table    []theTable;
  private boolean  hasPlayStarted;
  
  private Intro theIntro;
  
  private Dish testDish;
  private PApplet theApplet;
  
  private PImage lastFrame;
  
  private ControlP5 controlP5;
  private Button rematchButton;
  private Button quitButton;
  
  private boolean serverWin = false;
  private boolean clientWin = false;
  
  Game() {
  }
  
  Game(PApplet theApplet) {
    this.theApplet = theApplet;
    this.controlP5 = new ControlP5(theApplet);
    
    rematchButton = controlP5.addButton("Restart", 0, 300 - 150, 300, 100, 50);
    quitButton = controlP5.addButton("Quit", 0, 300 + 50, 300, 100, 50);
    rematchButton.hide();
    quitButton.hide();
    
    rightPlayer   = new Player("Player1", false);
    rightPlayer.x = 400;

    leftPlayer    = new Player("Player2", true);

    theCounter    = new Counter();
    isServer      = true;
    

    theTable      = new Table[8];
    theIntro      = new Intro(theApplet);
    hasPlayStarted = false;

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
//    theIntro.isServer();
    theIntro.hide();

    // Free up intro memory ??
  }

  public void draw() {

    if ( theIntro.enabled ) {
      theIntro.draw();
    }
    else { // Game has started!
      if( !hasPlayStarted ) {
        startOfGame();
        hasPlayStarted = true;
          //theCounter.startCounting();
      }
      if( clientConnected || singlePlayerTest ) {
        
        // Don't start the counter until the client is connected
        // Prevents server 'head start'
        if( !theCounter.counting )
          theCounter.startCounting();
          
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
          rematchButton.show();
          quitButton.show();
          
          if( rematchButton.booleanValue() ){
            rematchButton.hide();
            quitButton.hide();
            reset();
          }
          if( quitButton.booleanValue() ){
            rematchButton.hide();
            quitButton.hide();
            exit();
          }
          
          fill( 236, 220, 19);
          if( isServer ) {
            // Draw winner - loser
            if( rightPlayer.winner == true && leftPlayer.winner == true ) { // Draw
              textAlign(CENTER,CENTER);
              text("DRAW", 320, 240);
              networkMessageC += "OD,";
            }
            else if( rightPlayer.winner == true ) {
              textAlign(CENTER,CENTER);
              text("WINNER", 320, 240);
              networkMessageC += "OW,";
            }
            else { 
              textAlign(CENTER,CENTER);
              text("LOSER", 320, 240);
              networkMessageC += "OL,";
            }
          }
          else { // Send to client whether he won or not
            if( clientWin == true && serverWin == true ) { // Draw
              textAlign(CENTER,CENTER);
              text("DRAW", 320, 240);
            }
            else if( clientWin == false ) {
              textAlign(CENTER,CENTER);
              text("WINNER", 320, 240);
            }
            else{ 
              textAlign(CENTER,CENTER);
              text("LOSER", 320, 240);
            }
          }
        }
      }else {
        fill( 236, 220, 19);
        textAlign(CENTER,CENTER);
        text("waiting for connection...", width/2, 50);
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
        leftPlayer.goLeft();
        networkMessageC += "L,";
      }
    }
    else if ( key == CODED && keyCode == RIGHT ) {
      if ( isServer ) {
        rightPlayer.goRight();
      }
      else {
        networkMessageC += "R,";
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
        networkMessageC += "K,";
        if ( leftPlayer.x + 35 > rightPlayer.x && leftPlayer.x + 35 < rightPlayer.x + 20 ) {
          rightPlayer.stateId = 2;
          leftPlayer.goLeft();
          rightPlayer.goRight();
          rightPlayer.goRight();
          rightPlayer.goRight();
        }
      }
    }
  }
  
  // this handles the key presses from client
  public void handleClientKeys( String action) {
    if ( action.equals("OD") ) {
      serverWin = true;
      clientWin = true;
    }
    if ( action.equals("OW") ) {
      serverWin = true;
    }
    if ( action.equals("OL") ) {
      clientWin = false;
    }
    
    if ( action.equals("L") ) {
      leftPlayer.goLeft();
    }
    
    if ( action.equals("R")) {
      if ( rightPlayer.x - 35 > leftPlayer.x ) {
        leftPlayer.goRight();
      }
    }
    
    if ( action.equals("K")) {
      leftPlayer.stateId = 3;
      if ( leftPlayer.x + 35 > rightPlayer.x && leftPlayer.x + 35 < rightPlayer.x + 20 ) {
        rightPlayer.stateId = 2;
        leftPlayer.goLeft();
        rightPlayer.goRight();
        rightPlayer.goRight();
        rightPlayer.goRight();
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
  
  private void startOfGame(){
    isServer      = theIntro.isServer();
    initNetwork(theIntro.getIP());
  }
}

