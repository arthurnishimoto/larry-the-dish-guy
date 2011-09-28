import processing.net.*;
import ddf.minim.*;

Game currentGame;
Game theGame;
DishTestScene dishTest;


Server s; // Transmits data to other app
Client c; // Receives data from other app
boolean isNetworkInit = false; //wheter the network has been initialized

boolean isServer = false;       // Whether this instance is server.
boolean clientConnected = false;



boolean singlePlayerTest = true; // Don't wait on client for testing purposes

String networkMessageC;
String[] keysFromClient;

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

  isServer = false;
  clientConnected = false;
  isNetworkInit = false;
  
  theGame = new Game(this);
  dishTest = new DishTestScene(this);

  currentGame = theGame; // initial scene
  

  rectMode(CENTER);
  backgroundImage = loadImage("background.png");
  networkMessageC = "";
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
  
  if( isNetworkInit)
    processNetwork();
}

void keyPressed() {
  currentGame.handleKeyEvent();
  
  if( key == 'r' ){
    reset();
  }
}

void reset(){
  // Close the existing network components and run setup again
  if( c != null )
    c.stop();
  if( s != null )
    s.stop();
  setup();
}

void keyReleased() {
  currentGame.handleKeyEvent(RELEASED);
}

// Simple two-way communication between server and client
void processNetwork() {
  if ( isServer ) {
    //s.write("Server:1,2,3,4 "); // Send message to client
    if ( clientConnected ) { 
      if (c.available() > 0) { // Read message from client
        String dataString = c.readString();
        keysFromClient = dataString.split(",|:");
        for ( int i = 1; i < keysFromClient.length; i++) {
          theGame.handleClientKeys(keysFromClient[i]);
        }  
        println("Client sent: "+dataString);
      }
    }
  }
  else {
//    s.write("Client:5,6,7,8 "); // Send message to server
      if( !networkMessageC.equals("") ){ // Don't constantly send blank data
        s.write("Client:" + networkMessageC);
        networkMessageC = "";
      }
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

void initNetwork(String theIP) {
  // Network
  if ( isServer )
    s = new Server( this, serverPort );
  else
    s = new Server( this, clientPort );
    
  if ( !isServer ) {
    println("Waiting to connect to server");
    c = new Client( this, theIP, serverPort );
    println("Connected to server");
    clientConnected = true;
  }
  
  isNetworkInit = true;
}

void stop() {
  theGame.minim.stop();
  super.stop();
}
