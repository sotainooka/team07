class Player {
  float x, y;
  float speed = 5;

  Player() {
    x = width / 2;
    y = height - 50;
  }

  void move() {
    if (keyPressed) {
      if (keyCode == LEFT) x -= speed;
      if (keyCode == RIGHT) x += speed;
    }
    x = constrain(x, 0, width);
  }

  void display() {
    fill(0, 255, 255);
    noStroke();
    triangle(x, y, x - 15, y + 30, x + 15, y + 30);
  }
}
