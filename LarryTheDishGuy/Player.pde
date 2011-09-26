

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
    addDelay = 0;
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
    baseDish.process();
    baseDish.playerForce += playerForce / 100000.0;

    for ( int i = 0; i < dishes.size(); i++ ) {
      Dish d = (Dish)dishes.get(i);
      d.draw(); // Draw the dish
      d.process(); // Process physics
      if( d.getState() == 1 ) winner = false;
    }
  }

  void goLeft() {
    playerForce += forceIncrement;
    x-=4;
  }

  void goRight() {
    playerForce -= forceIncrement;
    x+=4;
  }

  void stopForce() {
    playerForce = 0;
  }
  
  void addDish() {
    if( addDelay == 0 ) {
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
}

