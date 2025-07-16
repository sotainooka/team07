class Bullet {
  float x, y;
  float r = 4;

  Bullet(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void move() {
    y -= 8;
  }

  void display() {
    fill(255, 0, 0);
    ellipse(x, y, r * 2, r * 2);
  }

  boolean offScreen() {
    return y < 0;
  }
}
