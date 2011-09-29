int nDishes = 10;

class DishTestScene extends Game{
  
  Dish baseDish;
  Dish dish1;
  Dish dish2;
  
  int playerForce = 0;
  
  ArrayList dishes;
  
  DishTestScene(PApplet p){  
    baseDish = new Dish();
    dishes = new ArrayList();
    
    Dish lastDish = new Dish( baseDish, 0, 12, 5, 0 );
    
    for( int i = 0; i < nDishes; i++ ){
      Dish curDish = new Dish( lastDish, 0, 12, 5, nDishes - i );
      dishes.add(lastDish);
      lastDish = curDish;
    }
  }

  public void draw(){
    background(10);
    
    baseDish.draw();
    baseDish.playerForce += playerForce / 10000.0;
    
    for( int i = 0; i < dishes.size(); i++ ){
      Dish d = (Dish)dishes.get(i);
      d.draw();
    }
    //dish1.draw();
    //dish2.draw();
    
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
