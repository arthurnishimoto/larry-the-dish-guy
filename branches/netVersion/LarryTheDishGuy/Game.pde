public AudioSample[] sounds;

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

  public Minim minim;
  private ControlP5 controlP5;
  private Button rematchButton;
  private Button quitButton;
  
  private boolean serverWin = false;
  private boolean clientWin = false;
  private boolean gameOverSound = false;
  
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

    //Setup sound
    String[] soundList = {    
      "select.wav", "kick.wav", "kickhit.wav", "tick.wav", "tock.wav", "lose.wav", "win.wav", "dishhit.wav", "platepickup.wav"
    };
    minim = new Minim(this.theApplet);
    sounds = new AudioSample[soundList.length];
    for (int i=0; i< soundList.length; i++) {
      sounds[i] = this.minim.loadSample(soundList[i], 2048);
    }
  }

  /**
   * Start the game!
   */
  public void start() {
    theIntro.isServer();
    //    theIntro.isServer();
    theIntro.hide();
    sounds[0].trigger();
    // Free up intro memory ??
  }

  public void draw() {

    if ( theIntro.enabled ) {
      theIntro.draw();
    }
    else { // Game has started!
      if ( !hasPlayStarted ) {
        startOfGame();
        hasPlayStarted = true;
          //theCounter.startCounting();
      }
      if ( clientConnected || singlePlayerTest ) {
        
        // Don't start the counter until the client is connected
        // Prevents server 'head start'
        if( !theCounter.counting )
          theCounter.startCounting();
          
        if ( !theCounter.gameTimePassed() ) {
          if( theCounter.getTime() < 20000 ){
            if (theCounter.getTime() % 2000 < 50) {
              sounds[4].trigger(); //tock
            } 
            else if ( theCounter.getTime() % 1000 < 50 ) {
              sounds[3].trigger(); //tick
            }
          } else if( theCounter.getTime() < 25000 ) {
            if (theCounter.getTime() % 1000 < 50) {
              sounds[4].trigger(); //tock
            } 
            else if ( theCounter.getTime() % 500 < 50 ) {
              sounds[3].trigger(); //tick
            }
          } else if( theCounter.getTime() < 30000 ) {
            if (theCounter.getTime() % 500 < 50) {
              sounds[4].trigger(); //tock
            } 
            else if ( theCounter.getTime() % 250 < 50 ) {
              sounds[3].trigger(); //tick
            }
          }
 
          theCounter.tick();
          imageMode(CORNER);
          image(backgroundImage, 0, 0, width, height);

          // Draw the tables
          for ( int i = 0; i < theTable.length; i++ ) {
            if ( theTable[i].checkCollision(leftPlayer) ) {
              leftPlayer.addDish();
            }

            if ( theTable[i].checkCollision(rightPlayer) ) {
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
            if ( rightPlayer.winner == true && leftPlayer.winner == true ) { // Draw
              textAlign(CENTER, CENTER);
              text("DRAW", 320, 240);
              networkMessageC += "OD,";
            }
            else if ( rightPlayer.winner == true ) {
              textAlign(CENTER, CENTER);
              text("WINNER", 320, 240);
              networkMessageC += "OW,";
              if( !gameOverSound ){
                sounds[6].trigger();
                gameOverSound = true;
              }
            }
            else { 
              textAlign(CENTER, CENTER);
              text("LOSER", 320, 240);
              networkMessageC += "OL,";
              if( !gameOverSound ){
                sounds[5].trigger();
                gameOverSound = true;
              }
            }
          }
          else { // Send to client whether he won or not
            if( clientWin == true && serverWin == true ) { // Draw
              textAlign(CENTER,CENTER);
              text("DRAW", 320, 240);
            }
            else if( clientWin == true ) {
              textAlign(CENTER,CENTER);
              text("WINNER", 320, 240);
            }
            else{ 
              textAlign(CENTER,CENTER);
              text("LOSER", 320, 240);
            }
          }
        }
      }
      else {
        fill( 236, 220, 19);
        textAlign(CENTER, CENTER);
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
      }
      networkMessageC += "L,";
    }
    else if ( key == CODED && keyCode == RIGHT ) {
      if ( isServer ) {
        rightPlayer.goRight();
      }
      else {
        if ( rightPlayer.x - 35 > leftPlayer.x )
          leftPlayer.goRight();
      }
      networkMessageC += "R,";
    }

    if ( key == ' ' ) {
      sounds[1].trigger();
      if ( isServer ) { //player is the server
        rightPlayer.stateId = 3;
        if ( leftPlayer.x + 35 > rightPlayer.x && leftPlayer.x + 35 < rightPlayer.x + 20 ) {
          sounds[2].trigger();
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
          sounds[2].trigger();
          rightPlayer.stateId = 2;
          leftPlayer.goLeft();
          rightPlayer.goRight();
          rightPlayer.goRight();
          rightPlayer.goRight();
        }
      }
      networkMessageC += "K,";
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
      if( isServer){
        leftPlayer.goLeft();
      }else {
        if ( leftPlayer.x + 35 < rightPlayer.x ) 
          rightPlayer.goLeft();
      }
    }

    if ( action.equals("R")) {
      if ( (rightPlayer.x - 35 > leftPlayer.x) && isServer ) {
        leftPlayer.goRight();
      }else if(!isServer) {
        rightPlayer.goRight();
      }
    }

    if ( action.equals("K")) {
      if( isServer) {
        leftPlayer.stateId = 3;
        if ( leftPlayer.x + 35 > rightPlayer.x && leftPlayer.x + 35 < rightPlayer.x + 20 ) {
          rightPlayer.stateId = 2;
          leftPlayer.goLeft();
          rightPlayer.goRight();
          rightPlayer.goRight();
          rightPlayer.goRight();
        }
      }else {
        rightPlayer.stateId = 3;
        if ( leftPlayer.x + 35 > rightPlayer.x && leftPlayer.x + 35 < rightPlayer.x + 20 ) {
          leftPlayer.stateId = 2;
          rightPlayer.goRight();
          leftPlayer.goLeft();
          leftPlayer.goLeft();
          leftPlayer.goLeft();
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

  private void startOfGame() {
    isServer      = theIntro.isServer();
    initNetwork(theIntro.getIP());
  }
  
  public Player getRightPlayer() {
    return rightPlayer;
  }
  
  public Player getLeftPlayer() {
    return leftPlayer;
  }
}

