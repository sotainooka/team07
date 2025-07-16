// Bullet.pde

class Bullet {
  float x, y;
  float speedX, speedY;
  int damage;
  boolean isPlayerBullet; // プレイヤーの弾かどうか
  float width, height; // 弾のサイズ

  // 新しいコンストラクタ (isPlayerBullet を受け取る)
  Bullet(float startX, float startY, float sX, float sY, int dmg, boolean isPlayer) {
    this.x = startX;
    this.y = startY;
    this.speedX = sX;
    this.speedY = sY;
    this.damage = dmg;
    this.isPlayerBullet = isPlayer;

    if (isPlayerBullet) {
      this.width = 10;
      this.height = 10;
    } else { // 敵の弾の場合（新しいBulletは敵専用ではないので注意）
      this.width = 8;
      this.height = 8;
    }
    // lifeTime はこのコンストラクタでは扱わない
  }
  
  // レーザー用のコンストラクタ (仮の想定)
  Bullet(float startX, float startY, float sX, float sY, int dmg, boolean isPlayer, int life) {
      this(startX, startY, sX, sY, dmg, isPlayer);
      // レーザーのサイズは別途設定が必要
      if (isPlayer) { // プレイヤーレーザー
          this.width = 50;
          this.height = 5;
      } else { // 敵レーザー (仮)
          this.width = width; // 画面幅
          this.height = 20;
      }
      this.lifeTime = life; // 寿命を設定
  }
  int lifeTime = -1; // 寿命 -1はなし

  void update() {
    x += speedX;
    y += speedY;

    if (lifeTime > 0) {
      lifeTime--;
    }
  }

  // 弾が画面外に出たか、寿命が尽きたらfalse
  boolean isAlive() {
    if (lifeTime == 0) return false; // 寿命が尽きた
    // 画面外判定
    return x > -50 && x < width + 50 && y > -50 && y < height + 50;
  }

  void display() {
    pushStyle();
    if (isPlayerBullet) {
      fill(0, 255, 0); // プレイヤーの弾は緑
      // レーザーの場合の描画は別途処理が必要
      if (damage == 2 && lifeTime != -1) { // 強力レーザーを想定
          fill(255, 0, 0, 150); // 半透明の赤いレーザー
          rect(x, y, width, height); // rect(x,y,w,h)は左上座標
      } else {
          ellipse(x, y, width, height);
      }
    } else { // 敵の弾
      fill(255, 0, 0); // 敵の弾は赤
      ellipse(x, y, width, height);
    }
    popStyle();
  }

  // ゲッターメソッド
  float getX() { return x; }
  float getY() { return y; }
  int getDamage() { return damage; }
  float getWidth() { return width; }
  float getHeight() { return height; }
  boolean isPlayerBullet() { return isPlayerBullet; }
  
  // 新しく追加: 弾の種類を文字列で返す (互換性のため)
  String getType() {
      if (isPlayerBullet) {
          if (damage == 2) return "player_laser"; // 仮にダメージ2がレーザー
          return "player_bullet";
      } else {
          return "enemy_bullet"; // 敵の通常弾
      }
  }
}
