import controlP5.*;

class Intro {
  
  private PApplet theApplet;
  private PFont font;
  
  public boolean enabled;
  
  private ControlP5 controlP5;
  private Toggle serverT;
  private Toggle clientT;
  private Button b;
  private Textfield t;
  private RadioButton r;
  private int stateId;
  
  // Animation sprites
  private PImage[] sprites;
  
  private int animationX;
  private int animationDirection = 0; // 0 is right, 1 is left
  
  Intro(PApplet theApplet) {
    this.theApplet = theApplet;
    this.controlP5 = new ControlP5(theApplet);
    this.animationX = 0;
    this.stateId = 0;
    
    b = controlP5.addButton("Start", 0, 300 - 50, 300, 100, 50);
    t = controlP5.addTextfield("Address", 300, 250, 100, 20);
    r = controlP5.addRadioButton("radio", 200, 250);
    
    serverT = r.addItem("Server", 0);
    clientT = r.addItem("Client", 1);
    t.setText("127.0.0.1");
    t.hide();
  
    serverT.setState(true);
    
    this.enabled = true;
    font = createFont("Cambria", 32);
    textFont( font );
    
    loadSprites();
  }
  
  private void loadSprites() {
    sprites = new PImage[4];
    sprites[0] = loadImage("waiter_step01.png");
    sprites[1] = loadImage("waiter_step02.png");
    sprites[2] = loadImage("waiter_kick01.png");
    sprites[3] = loadImage("waiter_kick02.png");
  }
  public void draw() {
    // Check for toggled modes
    checkModesToggled();
    
    fill(255);
    text("Larry and Billy the dish guys", 105, 50);
    
    // Animate
    animate();
  }
  
  private void animate() {
    int frameTimer = frameCount % 30;
    if (frameTimer < 15 ) {
      this.stateId = 0;
    } else if (frameTimer >=15) {
      this.stateId = 1;
    }
    
    int y = 150;
    if( animationX < 600 && animationDirection == 0 ) animationX++;
    else if( animationX == 600 ) {
      animationDirection = 1;
      animationX--;
    }
    else if( animationX > 0 && animationDirection == 1 ) animationX--;
    else if( animationX == 0 ) {
      animationDirection = 0;
      animationX++;
    } 
    
    noStroke();
    if (this.stateId == 0) {
      image(sprites[0], animationX-sprites[0].width, y-sprites[0].height, sprites[0].width*2, sprites[0].height*2);
      this.stateId = 1;
    } 
    else if (this.stateId == 1) {
      image(sprites[1], animationX-sprites[1].width, y-sprites[1].height, sprites[1].width*2, sprites[1].height*2);
      this.stateId = 0;
    } 
    else if (this.stateId == 2) {
      image(sprites[2], animationX-sprites[2].width, y-sprites[2].height, sprites[2].width*2, sprites[2].height*2);
      this.stateId = 3;
    }
    else if (this.stateId == 3) {
      image(sprites[2], animationX-sprites[2].width, y-sprites[2].height, sprites[2].width*2, sprites[2].height*2);
      this.stateId = 0;
    }
  }
  
  public void hide() {
    r.hide();
    t.hide();
    b.hide();
    
    enabled = false;
  }
  
  private void checkModesToggled() {
    if( clientT.getState()  == true )  t.show();
    else                               t.hide();
   
    if( clientT.getState() == false && serverT.getState() == false ) b.hide();
    else                                                             b.show(); 
  }
}
