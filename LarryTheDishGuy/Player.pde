

class Player {

  private int id;
  private String name;
  public int x;            // Position in x
  public int y;            // Position in y
  private boolean isRemote; // whether this player is the remote player (client) or not
  private PImage[] sprites;
  public int stateId;    // 0 is step1, 1 is step2, 2 is kick1, 3 is kick2
  private float animationTimer; //used to time sprite changes

  private int numberOfDishes;
  private Dish baseDish;
  private Dish lastDish;
  private ArrayList dishes;
  float playerForce = 0;
  int forceIncrement = 5;
  private int dt = 0;
  private int prevMillis = 0;
  
  private int addDelay;
  private boolean winner; 
  
  // isRemote = true, then this instance is the client
  Player(String name, boolean isRemote) {
    // Default for now
    if ( isRemote )  x = 200;
    else            x = 400;
    y = 50;
    numberOfDishes = 4;
    this.name = name;
    this.isRemote = isRemote;
    this.stateId = 0;
    animationTimer = millis();
    sprites = new PImage[4];
    if ( isRemote) {
      sprites[0] = loadImage("waiter02_step01.png");
      sprites[1] = loadImage("waiter02_step02.png");
      sprites[2] = loadImage("waiter02_kick01.png");
      sprites[3] = loadImage("waiter02_kick02.png");
    }
    else {
      sprites[0] = loadImage("waiter_step01.png");
      sprites[1] = loadImage("waiter_step02.png");
      sprites[2] = loadImage("waiter_kick01.png");
      sprites[3] = loadImage("waiter_kick02.png");
    }

    baseDish = new Dish();
    playerForce = random(-1,1);
    dishes = new ArrayList();
    lastDish = new Dish( baseDish, 0, 12, 5, 0 );
    winner = true;

    for ( int i = 0; i < numberOfDishes; i++ ) {
      Dish curDish = new Dish( lastDish, 0, 12, 5, numberOfDishes - i );
      dishes.add(lastDish);
      lastDish = curDish;
    }
  }

  public void draw(int time) {
    float now = millis() - this.animationTimer;
    if (this.stateId == 0 && now > 300 ) {
      this.stateId = 1;
      animationTimer = millis();
    } 
    else if (this.stateId == 1 && now > 300) { 
      this.stateId = 0;
      animationTimer = millis();
    } 
    else if (this.stateId == 2 && now > 500) {
      this.stateId = 0;
      animationTimer = millis();
    } 
    else if (this.stateId == 3 && now > 300) {
      this.stateId = 0;
      animationTimer = millis();
    }

    y = (int) map(time, 0, 30000, 60, height - 60);
    noStroke();
    imageMode(CORNER);
    if (this.stateId == 0) {
      image(sprites[0], x-sprites[0].width, y-sprites[0].height, sprites[0].width*2, sprites[0].height*2);
    } 
    else if (this.stateId == 1) {
      image(sprites[1], x-sprites[1].width, y-sprites[1].height, sprites[1].width*2, sprites[1].height*2);
    } 
    else if (this.stateId == 2) {
      image(sprites[2], x-sprites[2].width, y-sprites[2].height, sprites[2].width*2, sprites[2].height*2);
    }
    else if (this.stateId == 3) {
      image(sprites[3], x-sprites[3].width, y-sprites[3].height, sprites[3].width*2, sprites[3].height*2);
    }

    if ( name == "Player1" )
      baseDish.xPos = x + sprites[0].width - 18;
    else
      baseDish.xPos = x - sprites[0].width + 18;
    baseDish.yPos = y - sprites[0].height + 20;
    //baseDish.draw();
    if( isServer) {
      baseDish.process();
    }
    baseDish.playerForce += playerForce / 100000.0;

    for ( int i = 0; i < dishes.size(); i++ ) {
      Dish d = (Dish)dishes.get(i);
      d.draw();
      if( isServer) {
        d.process();
      }
      if( d.getState() == 1 ) winner = false;
    }
  }

  void goLeft() {
    if( x > 150 ) {
      playerForce += forceIncrement;
      x-=4;
    }
  }

  void goRight() {
    if ( x < 450 ) { 
      playerForce -= forceIncrement;
      x+=4;
    }
  }

  void stopForce() {
    playerForce = 0;
  }
  
  void addDish() {
    if( winner == false ) // Already lost, don't add more dishes
      return;
      
    if( addDelay == 0 ) {
      sounds[8].trigger();
      numberOfDishes++;
      Dish curDish = new Dish( lastDish, 0, 12, 5, numberOfDishes);
      dishes.add(lastDish);
      lastDish = curDish;
      prevMillis = millis();
      addDelay += 1;
    }
    else {
      if( addDelay > 200 ) addDelay = 0;
      else {
        int curMillis = millis();
        dt = curMillis - prevMillis;
        addDelay += dt;
        prevMillis = curMillis;
      }
    }
  }
  
  public String dishesToString() {
    String plateInfo = "";
    for( int i = 0; i < dishes.size(); i ++) {
      plateInfo += ("p," + ((Dish)(dishes.get(i))).getX() + "," + ((Dish)(dishes.get(i))).getY() + "," + ((Dish)(dishes.get(i))).getTilt() + ",");
    }
    return plateInfo;
  }
  
  public void updateDishes( String[] serverData) {
    //do some stuff here
    int numberOfDishesUpdated = 0;
    boolean handlingLeftPlates = true;
    boolean handlingRightPlates = true;
//    println("number of dishes in arraylist = " + dishes.size());
    if( isRemote) {
      if( serverData[0].equals("Server")){
        for( int i = 0; i < serverData.length; i++) {
          if( serverData[i].equals("l")) {
            while(handlingLeftPlates && (i < serverData.length)) {
//              println(serverData[i]);
              if( serverData[i].equals("p")) {
                i++;
                if( dishes.size() == numberOfDishesUpdated) {
                  if( (i+2) < serverData.length){//check to make sure data wasn't dropped
                    Dish curDish = new Dish( lastDish, 0, 12, 5, dishes.size());
                    try {
                      curDish.updatePlate( Float.parseFloat(serverData[i]), Float.parseFloat(serverData[i+1]), Float.parseFloat(serverData[i+2]));
                      i+=2;
                    }catch (NumberFormatException e) {
                      System.err.println("NumberFormatException: " + e.getMessage());
                    }
                    dishes.add(lastDish);
                    lastDish = curDish;
                    numberOfDishesUpdated++;
                  }
                }else {
//                  println("dishes.size() = " + dishes.size() + "\nnumberOfDishesUpdated = " + numberOfDishesUpdated);
                  if( (i+2) < serverData.length){//check to make sure data wasn't dropped
                    try {
                      ((Dish)(dishes.get(numberOfDishesUpdated))).updatePlate( Float.parseFloat(serverData[i]), Float.parseFloat(serverData[i+1]), Float.parseFloat(serverData[i+2]));
                      i+=2;
                      numberOfDishesUpdated++;
                    }catch (NumberFormatException e) {
                      System.err.println("NumberFormatException: " + e.getMessage());
                    }
                  }
                }
              }else if(serverData[i].equals("r")){
                handlingLeftPlates = false;
              }
              i++;
            }
          }
          if(!handlingLeftPlates) {
            break;
          }
        }
      }
    }else {
      if( serverData.length > 0){
        for( int i = 0; i < serverData.length; i++) {
          if( serverData[i].equals("r")) {
            while(handlingRightPlates && (i < serverData.length)) {
//              println(serverData[i]);
              if( serverData[i].equals("p")) {
                i++;
                if( dishes.size() == numberOfDishesUpdated) {
                  if( (i+2) < serverData.length){//check to make sure data wasn't dropped
                    Dish curDish = new Dish( lastDish, 0, 12, 5, dishes.size());
                    try {
                      curDish.updatePlate( Float.parseFloat(serverData[i]), Float.parseFloat(serverData[i+1]), Float.parseFloat(serverData[i+2]));
                      i+=2;
                    }catch (NumberFormatException e) {
                      System.err.println("NumberFormatException: " + e.getMessage());
                    }
                    dishes.add(lastDish);
                    lastDish = curDish;
                    numberOfDishesUpdated++;
                  }
                }else {
//                  println("dishes.size() = " + dishes.size() + "\nnumberOfDishesUpdated = " + numberOfDishesUpdated);
                  if( (i+2) < serverData.length){//check to make sure data wasn't dropped
                    try {
                      ((Dish)(dishes.get(numberOfDishesUpdated))).updatePlate( Float.parseFloat(serverData[i]), Float.parseFloat(serverData[i+1]), Float.parseFloat(serverData[i+2]));
                      i+=2;
                      numberOfDishesUpdated++;
                    }catch( NumberFormatException e) {
                      System.err.println("NumberFormatException: " + e.getMessage());
                    }
                  }
                }
              }
              i++;
            }
          }
          if(!handlingLeftPlates) {
            break;
          }
        }
      }
    }
  }
}

