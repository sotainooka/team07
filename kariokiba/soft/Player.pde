// Player.pde
import java.util.ArrayList; // ArrayList を使用するために追加

class Player {
  float x, y;
  float speed;
  int hp;
  int gauge; // レーザーゲージ
  int gaugeMax = 5; // レーザー発射に必要なゲージ量
  int maxHP = 10; // maxHP をここで定義
  PImage img;
  
  ArrayList<Bullet> bullets; // プレイヤーの弾リストをPlayerクラス内で管理

  Player(float x, float y) {
    this.x = x;
    this.y = y;
    this.speed = 5;
    this.hp = this.maxHP; // hpの初期値をmaxHPに設定
    this.gauge = 0;
    
    // loadImage は Processing のグローバル関数なので、setup() か PApplet インスタンス経由でロードが安全
    // ここでは仮に直接呼び出す形にしますが、エラーが出る場合は setup() でロードして渡してください
    img = loadImage("player.png"); // player.png ファイルをスケッチのdataフォルダに置いてください
    
    bullets = new ArrayList<Bullet>(); // 弾リストを初期化
  }

  void display() {
    pushStyle(); // スタイルを保存
    if (img != null && img.width > 0 && img.height > 0) { // 画像が正常にロードされたか確認
      image(img, x, y, 40, 40); // 40x40 にリサイズ表示 (x,y は左上)
    } else {
      fill(255, 204, 0); // 画像がない場合は矩形で表示 (黄色)
      rect(x, y, 40, 40); // (x,y は左上)
    }
    popStyle(); // スタイルを復元

    // displayHP() と displayGauge() は UI クラスが担当するため、Playerクラスからは削除します。
    // UI クラスの update メソッドで player.hp, player.gauge を UI に渡す形になりました。
  }

  void move() {
    // 画面外に出ないように制限
    if (keyPressed) {
      if ((key == 'a' || keyCode == LEFT) && x > 0) {
        x -= speed;
      }
      if ((key == 'd' || keyCode == RIGHT) && x + 40 < width) { // プレイヤーの幅を考慮
        x += speed;
      }
      if ((key == 'w' || keyCode == UP) && y > 0) { // 上方向移動を追加
        y -= speed;
      }
      if ((key == 's' || keyCode == DOWN) && y + 40 < height) { // 下方向移動を追加
        y += speed;
      }
    }
  }

  // プレイヤーの通常弾発射 (app.pdeのplayerShootを呼び出すため削除)
  // void shoot(ArrayList<Bullet> bullets) {
  //   bullets.add(new Bullet(x + 20, y, 0, -8, 1, true)); // 通常弾
  // }

  // プレイヤーのレーザー発射 (app.pdeのplayerShootを呼び出すため削除)
  // void shootLaser(ArrayList<Bullet> bullets) {
  //   if (gauge >= gaugeMax) {
  //     bullets.add(new Bullet(x + 20, y, 0, -10, 2, true)); // 強力レーザー
  //     gauge = 0; // リセット
  //   }
  // }

  void takeDamage(int damage) {
    hp -= damage;
    if (hp <= 0) {
      hp = 0;
      die(); // 死亡処理を呼び出す
    }
  }

  void die() {
    // currentScreen は app.pde のグローバル変数なので直接アクセス
    // ただし、クラスからはグローバル変数に直接アクセスしない方が良い
    // app.pde で player.hp <= 0 の時に currentScreen を変更するのが安全
  }

  void addGauge(int amount) {
    gauge = min(gauge + amount, gaugeMax);
  }
  
  // レーザーゲージを消費するメソッドを追加
  void useGauge(int amount) {
      gauge -= amount;
      if (gauge < 0) gauge = 0;
  }

  // === ゲッターメソッド ===
  float getX() { return x; }
  float getY() { return y; }
  float getWidth() { return 40; } // プレイヤーの表示幅
  float getHeight() { return 40; } // プレイヤーの表示高さ
  int getHP() { return hp; }
  int getMaxHP() { return maxHP; }
  int getGauge() { return gauge; }
  int getGaugeMax() { return gaugeMax; }
  
  // === 当たり判定メソッド ===
  // プレイヤーと弾の当たり判定
  boolean isHit(Bullet b) {
    // 弾の中心座標 b.x + b.width/2, b.y + b.height/2
    // プレイヤーの矩形 x, y, width, height
    return (b.getX() + b.getWidth() / 2 > x &&
            b.getX() - b.getWidth() / 2 < x + getWidth() &&
            b.getY() + b.getHeight() / 2 > y &&
            b.getY() - b.getHeight() / 2 < y + getHeight());
  }
  // プレイヤーと敵の当たり判定
  boolean isHit(Enemy e) {
      // 敵の中心座標 e.x + e.w/2, e.y + e.h/2
      // プレイヤーの矩形 x, y, width, height
      return (e.getX() + e.getWidth() / 2 > x &&
              e.getX() - e.getWidth() / 2 < x + getWidth() &&
              e.getY() + e.getHeight() / 2 > y &&
              e.getY() - e.getHeight() / 2 < y + getHeight());
  }
}
