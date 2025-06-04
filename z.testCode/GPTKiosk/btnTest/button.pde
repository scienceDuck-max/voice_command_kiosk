
class Button {
  private int x, y;
  private int width, height;
  private PImage background;
  private boolean clicked;

  public Button(int x, int y, int width, int height, PImage background) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.background = background;
    this.clicked = false;
  }

  public void draw() {
    image(background, x, y, width, height);
  }

  public boolean isClicked() {
    if (mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height) {
      this.clicked = true;
    }
    else {
      this.clicked = false;
    }
    return this.clicked;
  }
}
