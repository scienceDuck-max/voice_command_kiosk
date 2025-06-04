
Button button;

void setup() {
  size(800, 600);
  background(255);

  // Load the button image
  PImage buttonImage = loadImage("btn.png");

  // Create a button instance
  button = new Button(100, 100, 100, 100, buttonImage);
}

void draw() {
  background(255);
  button.draw();
}


void mouseReleased() {
  if(button.isClicked())
    println("clicked!!");
}
