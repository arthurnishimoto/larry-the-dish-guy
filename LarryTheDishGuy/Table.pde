class Table {
  
  private int x;
  private int y;
  private int tWidth;
  private int tHeight;
  private int id;
  private PImage sprite;
  
  Table(int x, int y, int tWidth, int tHeight) {
    this.x = x;
    this.y = y;
    this.tWidth = tWidth;
    this.tHeight = tHeight;
    this.sprite = loadImage("table.png");
  }
  
  public void draw() {
    imageMode(CORNER);
    noStroke();
    image(this.sprite, x - sprite.width, y - sprite.height, sprite.width * 2, sprite.height * 2);
  }
  
  public void checkCollision(Player aPlayer) {
    if( aPlayer.x > x - tWidth / 2 && aPlayer.x < x + tWidth / 2 && aPlayer.y > y - tHeight / 2 && aPlayer.y < y + tHeight / 2 )
    println("ON TABLE");
  }
}
