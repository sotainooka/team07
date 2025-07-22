class Player {
  float x, y;
  float speed = 5;
  PImage img;

  Player() {
    x = width / 2;
    y = height - 50;
    img = loadImage("player.png");
  }

  void move() {
    if (keyPressed) {
      if (keyCode == LEFT) x -= speed;
      if (keyCode == RIGHT) x += speed;
    }
    x = constrain(x, 0, width);
  }

  void display() {
     if (img != null) {
    image(img, x, y, 60, 60);  // 40×40 にリサイズ表示
  } else {
    fill(0, 255, 255);
    noStroke();
    triangle(x, y, x - 15, y + 30, x + 15, y + 30);
  }
  }
}
