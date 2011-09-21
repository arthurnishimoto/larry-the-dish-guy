class DishTestScene extends Game{
  
  Dish baseDish;
  Dish dish1;
  Dish dish2;
  
  int playerForce = 0;
  
  DishTestScene(PApplet p){  
    baseDish = new Dish();
    dish1 = new Dish( baseDish, 0, 12, 5 );
    dish2 = new Dish( dish1, 0, 12, 5 );
  }

  public void draw(){
    background(10);
    
    baseDish.draw();
    baseDish.playerForce += playerForce / 10000.0;
    
    dish1.draw();
    dish2.draw();
    
    rectMode(CORNER);
    fill(255);
    noStroke();
    rect( width/2, height - 20, playerForce, 10 );
  }
  
  public void handleKeyEvent() {
    if( key == CODED && keyCode == LEFT ) {
      playerForce--;
      //dish1.slideX--;
    }
    else if( key == CODED && keyCode == RIGHT ) {
      playerForce++;
      //dish1.slideX++;
    } else if( key == CODED && keyCode == UP ) {
      baseDish.yPos--;
    }
    else if( key == CODED && keyCode == DOWN ) {
      baseDish.yPos++;
      dish1.state = Dish.FALLING;
    }
  }
  
  public void handleKeyEvent(int state){
    switch(state){
      case(PRESSED):
        break;
      case(DRAGGED):
        break;
      case(RELEASED):
        playerForce = 0;
        break;
    }
  }
}
