class Table {
  
  private int x;
  private int y;
  private int tWidth;
  private int tHeight;
  private int id;
  
  Table(int x, int y, int tWidth, int tHeight) {
    this.x = x;
    this.y = y;
    this.tWidth = tWidth;
    this.tHeight = tHeight;
  }
  
  public void draw() {
    stroke(0);
    fill(255);
    rectMode(CENTER);
    rect(x, y, tWidth, tHeight);
  }
  
  public void checkCollision(Player aPlayer) {
    if( aPlayer.x > x - tWidth / 2 && aPlayer.x < x + tWidth / 2 && aPlayer.y > y - tHeight / 2 && aPlayer.y < y + tHeight / 2 )
    println("ON TABLE");
  }
}
