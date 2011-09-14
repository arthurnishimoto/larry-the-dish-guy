class Dish{
  float xPos;
  float yPos;
  float w, h;
  
  float currentTilt;
  float force;
  float playerForce;
  
  float tiltThreshold;
  
  // Test mouse controls
  int lastMouseX, lastMouseY;
  
  Dish(){
    xPos = 300;
    yPos = 300;
    w = 100;
    h = 10;
  }// CTOR
  
  void draw(){
    pushMatrix();
    translate( xPos, yPos );
    rotate( currentTilt );    
    
    fill(250,250,250);
    noStroke();
    rect( 0, 0, w, h );
    popMatrix();
    
    // Calculate tilt
    currentTilt += playerForce;
    
    // Test interaction
    if( lastMouseX == 0 )
      lastMouseX = mouseX;  
    float diff = mouseX - lastMouseX;
    playerForce += diff / 10000.0;
    lastMouseX = mouseX;
  }// draw
  
  void mousePressed(){
    playerForce = 0;
  }
}// class
