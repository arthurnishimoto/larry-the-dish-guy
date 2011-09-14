class Player {
  
  private int id;
  private String name;
  public int x;            // Position in x
  public int y;            // Position in y
  private boolean isRemote; // whether this player is the remote player (client) or not
  
  private int numberOfDishes;
  
  Player(String name, boolean isRemote) {
    // Default for now
    x = 200;
    y = 0;
    numberOfDishes = 1;
    this.name = name;
    this.isRemote = isRemote;
  }
  
  public void draw(int time) {
    // Draw a rect for now
    fill(0);
    rectMode(CENTER);
    y = (int) map(time, 0, 30000, 0, height);
    rect(x, y, 10, 10);
  }
  
  void goLeft() {
    x-=2;
  }
  
  void goRight() {
    x+=2;
  }
}
