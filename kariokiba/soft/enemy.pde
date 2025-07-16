// enemy.pde
class Enemy {
  float x, y;
  float w = 30, h = 20;
  float speed = 1.5;
  int direction = 1;
  boolean alive = true;
  String type; // 敵の種類を追加
  int hp = 5; // HPの初期値 (仮)

  Enemy(float x, float y, String type) { // コンストラクタにtypeを追加
    this.x = x;
    this.y = y;
    this.type = type;
  }

  void move() {
    // 画面外に出ないように制限
    x += speed * direction;
    if (x < 0 || x + w > width) { // w を考慮
      direction *= -1;
      y += 20; // 画面端で反転してY座標を増やす
    }
  }

  void display() {
    pushStyle();
    if (alive) {
      if (type.equals("blue")) {
        fill(0, 0, 150); // 青色の敵
      } else if (type.equals("red")) {
        fill(150, 0, 0); // 赤色の敵
      } else if (type.equals("yellow")) {
        fill(150, 150, 0); // 黄色の敵
      }
      rect(x, y, w, h); // (x,y は左上)
    }
    popStyle();
  }

  boolean isHit(Bullet b) { // 敵と弾の当たり判定
    // 弾の中心座標 b.getX() + b.getWidth()/2, b.getY() + b.getHeight()/2
    // 敵の矩形 x, y, w, h
    return (b.getX() + b.getWidth() / 2 > x &&
            b.getX() - b.getWidth() / 2 < x + w &&
            b.getY() + b.getHeight() / 2 > y &&
            b.getY() - b.getHeight() / 2 < y + h);
  }
  
  // 敵がダメージを受ける
  void takeDamage(int damage) {
      hp -= damage;
      if (hp <= 0) {
          hp = 0;
          alive = false; // 死亡
      }
  }
  
  // 敵が生きているか
  boolean isDead() {
      return !alive;
  }
  
  // 突進状態の判定 (仮)
  boolean isRushing() {
      if (type.equals("red")) {
          // 赤い敵の突進ロジックをここに記述
          // 例えば、一定時間ごとにspeedを上げてプレイヤーに向かうなど
          // 現時点では、仮のisRushing()を返します
          return (millis() / 1000) % 5 == 0; // 5秒に一度突進状態になる仮のロジック
      }
      return false;
  }

  // === ゲッターメソッド ===
  float getX() { return x; }
  float getY() { return y; }
  float getWidth() { return w; }
  float getHeight() { return h; }
  String getType() { return type; }
}
