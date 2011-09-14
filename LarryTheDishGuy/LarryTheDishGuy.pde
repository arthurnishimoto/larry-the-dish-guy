Game theGame;

void setup() {
  size(600, 400);
  
  theGame = new Game();
  
}

void draw() {
  background(255);
  theGame.draw();
}

void keyPressed() {
  theGame.handleKeyEvent();
}
