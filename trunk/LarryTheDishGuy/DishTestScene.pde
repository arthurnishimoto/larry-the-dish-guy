class DishTestScene {
  
  Dish testDish;
  
  DishTestScene(){  
    testDish = new Dish();
  }

  public void draw(){
    background(10);
    testDish.draw();
  }
  
}
