import processing.net.*;

Game currentGame;
Game theGame;
DishTestScene dishTest;

Server s; // Transmits data to other app
Client c; // Receives data from other app

boolean isServer = false;       // Whether this instance is server.
boolean clientConnected = false;

int serverPort = 12345;
String serverIP = "10.28.206.117";
int clientPort = 23456;

int currentScene = 0;

// Key states
final int PRESSED = 0;
final int DRAGGED = 1;
final int RELEASED = 2;

PImage backgroundImage;
void setup() {
  size(600, 400);

  theGame = new Game(this);
  dishTest = new DishTestScene(this);

  currentGame = theGame; // initial scene
  
  // Network
  if ( isServer )
    s = new Server( this, serverPort );
  else
    s = new Server( this, clientPort );

  if ( !isServer ) {
    println("Waiting for to connect to server");
    c = new Client( this, serverIP, serverPort );
    println("Connected to server");
  }
  rectMode(CENTER);
  backgroundImage = loadImage("background.png");
}

void draw() {
  background(128, 96, 64);

  switch( currentScene ) {
    case(0):
      currentGame = theGame;
      break;
    case(1):
      currentGame = dishTest;
      break;
  }// switch

  currentGame.draw();
  processNetwork();
}

void keyPressed() {
  currentGame.handleKeyEvent();
  
  if( key == 'r' )
    setup();
}

void keyReleased() {
  currentGame.handleKeyEvent(RELEASED);
}

// Simple two-way communication between server and client
void processNetwork() {
  if ( isServer ) {
    s.write("Server:1,2,3,4 "); // Send message to client
    if ( clientConnected ) { 
      if (c.available() > 0) { // Read message from client
        String dataString = c.readString();
        String[] params = dataString.split(",|:");
        println("Client sent: "+dataString);
      }
    }
  }
  else {
    s.write("Client:5,6,7,8 "); // Send message to server
    if (c.available() > 0) { 
      String dataString = c.readString(); // Receive message from client
      String[] params = dataString.split(",|:");
      println("Server sent: "+dataString);
    }
  }
}

// If this is the server, create a client when a client
// connects. This allows for two-way communication
void serverEvent( Server server, Client client ) {
  if ( isServer ) {
    println("Client "+client+" connected");
    c = new Client( this, client.ip(), clientPort );
    clientConnected = true;
  }
}

/**
 *
 * Event controlers for controlP5
 */
void Start(int value) {
  theGame.start();
}