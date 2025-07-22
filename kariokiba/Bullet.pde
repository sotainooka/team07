class Bullet {
  float x, y;
  float speedX, speedY;
  int damage;
  String type;
  int lifeTime;
  float width = 8, height = 8;

  Bullet(float startX, float startY, float sX, float sY, int dmg, String t) {
    x = startX;
    y = startY;
    speedX = sX;
    speedY = sY;
    damage = dmg;
    type = t;
    lifeTime = Integer.MAX_VALUE;
  }

  Bullet(float startX, float startY, int dmg, String t, int life) {
    x = startX;
    y = startY;
    speedX = 0;
    speedY = -10;
    damage = dmg;
    type = t;
    lifeTime = life;
    width = 12;
    height = 40;
  }

  void update() {
    x += speedX;
    y += speedY;
    if (lifeTime < Integer.MAX_VALUE) {
      lifeTime--;
    }
  }

  void display() {
    if (type.contains("laser")) {
      fill(255, 0, 255); // レーザー：ピンク
      rect(x - width/2, y - height, width, height);
    } else if (type.contains("enemy")) {
      fill(255, 0, 0);   // 敵弾：赤
      ellipse(x, y, width, height);
    } else {
      fill(255);         // 通常弾：白
      ellipse(x, y, width, height);
    }
  }

  boolean isAlive() {
    return lifeTime > 0;
  }

  float getX() { return x; }
  float getY() { return y; }
  int getDamage() { return damage; }
  String getType() { return type; }
  float getWidth() { return width; }
  float getHeight() { return height; }
}
