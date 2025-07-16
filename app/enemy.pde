class Enemy {
  float x, y;
  float w = 30, h = 20;
  float speed = 1.5;
  int direction = 1;
  boolean alive = true;

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void move() {
    x += speed * direction;
    if (x < 0 || x + w > width) {
      direction *= -1;
      y += 20;
    }
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
