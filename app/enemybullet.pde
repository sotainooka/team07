class EnemyBullet {
  float x, y;
  float r = 4;
  float speed = 4;

  EnemyBullet(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void move() {
    y += speed;
  }

  void display() {
    fill(255, 255, 0);
    ellipse(x, y, r * 2, r * 2);
  }

  boolean offScreen() {
    return y > height;
  }
}
