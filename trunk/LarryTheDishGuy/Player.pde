class Player {

  private int id;
  private String name;
  public int x;            // Position in x
  public int y;            // Position in y
  private boolean isRemote; // whether this player is the remote player (client) or not
  private PImage[] sprites;
  public int stateId;    // 0 is step1, 1 is step2, 3 is kick1, 4 is kick2

  private int numberOfDishes;

  // isRemote = true, then this instance is the client
  Player(String name, boolean isRemote) {
    // Default for now
    if( isRemote )  x = 200;
    else            x = 400;
    y = 0;
    numberOfDishes = 1;
    this.name = name;
    this.isRemote = isRemote;
    this.stateId = 0;
    sprites = new PImage[4];
    sprites[0] = loadImage("waiter_step01.png");
    sprites[1] = loadImage("waiter_step02.png");
    sprites[2] = loadImage("waiter_kick01.png");
    sprites[3] = loadImage("waiter_kick02.png");
  }

  public void draw(int time) {
    int frameTimer = frameCount % 30;
    if (frameTimer < 15 ) {
      this.stateId = 0;
    } else if (frameTimer >=15) {
      this.stateId = 1;
    }
    
    y = (int) map(time, 0, 30000, 0, height);
    noStroke();
    if (this.stateId == 0) {
      image(sprites[0], x-sprites[0].width, y-sprites[0].height, sprites[0].width*2, sprites[0].height*2);
      this.stateId = 1;
    } 
    else if (this.stateId == 1) {
      image(sprites[1], x-sprites[1].width, y-sprites[1].height, sprites[1].width*2, sprites[1].height*2);
      this.stateId = 0;
    } 
    else if (this.stateId == 2) {
      image(sprites[2], x-sprites[2].width, y-sprites[2].height, sprites[2].width*2, sprites[2].height*2);
      this.stateId = 3;
    }
    else if (this.stateId == 3) {
      image(sprites[2], x-sprites[2].width, y-sprites[2].height, sprites[2].width*2, sprites[2].height*2);
      this.stateId = 0;
    }
  }

  void goLeft() {
    x-=4;
  }

  void goRight() {
    x+=4;
  }
}

