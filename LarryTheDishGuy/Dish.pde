class Dish{
  
  // States
  final static int PLAY = 0; // In play
  final static int FALLING = 1;
  final static int CRASHED = 2; // Collided with floor
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
  
  float slideSpeed = 0.05;
  
  // Test mouse controls
  int lastMouseX, lastMouseY;
  
  Dish parentDish;
  float slideX = 0;
  float slideY = 0;
  
  int nDishesAbove = 0;
  float maxFallDistance = 0;
  
  PImage dishImage;
  Dish(){
    xPos = 300;
    yPos = 300;
    w = 100;
    h = 10;
    
    dishImage = loadImage("plate.png");
  }// CTOR
  
  Dish( Dish p, float x, float y, int _h, int _nDishesAbove ){
    parentDish = p;
    xPos = x;
    yPos = y;
    w = 100;
    h = _h;
    nDishesAbove = _nDishesAbove;
    dishImage = loadImage("plate.png");
    maxFallDistance = 100;
  }// CTOR
  
  void process(){
    if( parentDish != null && state == PLAY){
      if( currentTilt != 0 && dist( xPos, yPos, parentDish.xPos, parentDish.yPos ) > dishImage.width * 0.7 ){
        state = FALLING;
      }
      if( abs(currentTilt) > radians(70) ){
        state = FALLING;
      }
      //println( dist( xPos, yPos, parentDish.xPos, parentDish.yPos ) );
      currentTilt = parentDish.currentTilt;
      
      xPos = parentDish.xPos + 0 * cos(currentTilt) + slideX;
      yPos = parentDish.yPos + slideX * sin(currentTilt) - h;
      
      float slideSpeedWMass = slideSpeed * ( nDishesAbove / (float)nDishes );
      if( currentTilt > 0 )
        slideX += slideSpeedWMass;
      else if( currentTilt < 0 )
        slideX -= slideSpeedWMass;
      //textFont( font, 10 );
      //fill(255);
      //text( slideSpeedWMass , xPos + 20, yPos );
    } else if( parentDish != null && state == FALLING ){
      currentTilt = parentDish.currentTilt;
      
      xPos += slideX / 20;
      yPos += 0.98;
      maxFallDistance--;
      
      if( maxFallDistance < 0 || parentDish.state == CRASHED ){
        state = CRASHED;
        sounds[7].trigger();
      }
    }

    // Calculate tilt
    currentTilt += playerForce;
    
    // Test interaction
    //if( lastMouseX == 0 )
   //   lastMouseX = mouseX;  
   // float diff = mouseX - lastMouseX;
   // playerForce += diff / 10000.0;
   // lastMouseX = mouseX; 
  }
  
  void draw(){
    if( state == CRASHED )
      return;
     
    imageMode(CENTER);
    rectMode(CENTER);
    
    pushMatrix();
    translate( xPos, yPos );
    rotate( currentTilt );    
    
    image( dishImage, 0, 0 );
    //fill(250,250,250);
    //noStroke();
    //rect( 0, 0, w, h );
    popMatrix();
  }// draw

  public int getState() {
    return state;
  } //getState
  
  public void updatePlate( float x, float y, float tilt) {
    xPos = x;
    yPos = y;
    currentTilt = tilt;
  }
  
  public float getX() {
    return xPos;
  }
  
  public float getY() {
    return yPos;
  }
  
  public float getTilt() {
    return currentTilt;
  }
  
}// class
