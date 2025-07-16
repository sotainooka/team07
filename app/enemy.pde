class Enemy {
  float x, y;
  float w = 30, h = 20;
  boolean alive = true;

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    fill(0, 255, 0);
    rect(x, y, w, h);
  }

  boolean isHit(Bullet b) {
    return b.x > x && b.x < x + w &&
           b.y > y && b.y < y + h;
  }
}
