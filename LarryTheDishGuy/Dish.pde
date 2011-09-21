class Dish{
  
  // States
  final static int PLAY = 0; // In play
  final static int FALLING = 1;
  final static int COLLIDED = 2; // Collided with floor
  int state = PLAY;
  
  float xPos;
  float yPos;
  float w, h;
  
  float currentTilt = 0;
  float distanceFromParent = 0;
  float force;
  float playerForce;
  
  // Max tilt/distance from base before
  // dish is falling
  float tiltThreshold = 0;
  float distanceThreshold = 0;
  
  
  // Test mouse controls
  int lastMouseX, lastMouseY;
  
  Dish parentDish;
  float slideX = 0;
  float slideY = 0;
  
  PImage dishImage;
  Dish(){
    xPos = 300;
    yPos = 300;
    w = 100;
    h = 10;
    
    dishImage = loadImage("plate.png");
  }// CTOR
  
  Dish( Dish p, float x, float y, int _h ){
    parentDish = p;
    xPos = x;
    yPos = y;
    w = 100;
    h = _h;
    dishImage = loadImage("plate.png");
  }// CTOR
  
  void draw(){
    rectMode(CENTER);
    
    if( parentDish != null && state == PLAY){
      currentTilt = parentDish.currentTilt;
      
      xPos = parentDish.xPos + 0 * cos(currentTilt) + slideX;
      yPos = parentDish.yPos + slideX * sin(currentTilt) - h;
      
      if( currentTilt > 0 )
        slideX += 0.1;
      else if( currentTilt < 0 )
        slideX -= 0.1;
    } else if( parentDish != null && state == FALLING ){
      currentTilt = parentDish.currentTilt;
      
      xPos += slideX / 20;
      yPos += 0.98;
    }
    pushMatrix();
    translate( xPos, yPos );
    rotate( currentTilt );    
    
    image( dishImage, 0, 0 );
    //fill(250,250,250);
    //noStroke();
    //rect( 0, 0, w, h );
    popMatrix();
    
    // Calculate tilt
    currentTilt += playerForce;
    
    // Test interaction
    //if( lastMouseX == 0 )
   //   lastMouseX = mouseX;  
   // float diff = mouseX - lastMouseX;
   // playerForce += diff / 10000.0;
   // lastMouseX = mouseX;
  }// draw

}// class
