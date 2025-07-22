class Enemy {
  float x, y;
  float w = 30, h = 20;
  float speed = 1.5;
  int direction = 1;
  boolean alive = true;
  String type; // ← 敵のタイプを追加（blue, red, yellow）

  Enemy(float x, float y, String type) {
    this.x = x;
    this.y = y;
    this.type = type;
  }

  void move() {
    x += speed * direction;
    if (x < 0 || x + w > width) {
      direction *= -1;
      y += 20;
    }
  }

  void display() {
    if (!alive) return;
    if (type.equals("blue")) fill(0, 128, 255);
    else if (type.equals("red")) fill(255, 0, 0);
    else if (type.equals("yellow")) fill(255, 255, 0);
    else fill(0, 255, 0); // fallback

    rect(x, y, w, h);
  }

  boolean isHit(Bullet b) {
      return b.getX() + b.getWidth()/2 > x &&
         b.getX() - b.getWidth()/2 < x + width &&
         b.getY() + b.getHeight()/2 > y &&
         b.getY() - b.getHeight()/2 < y + height;
  }
}
