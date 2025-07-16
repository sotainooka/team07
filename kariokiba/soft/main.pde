// main.pde

// Processingのグローバル変数として利用される
Player player;
Attack attackManager;
UI uiManager;

void settings() {
  size(800, 600); // ウィンドウサイズの設定
}

void setup() {
  player = new Player(100, height / 2); // プレイヤーの初期位置
  attackManager = new Attack(); // AttackManagerの初期化
  uiManager = new UI(); // UIManagerの初期化
  
  // 仮の敵を生成 (テスト用) - setup()内で敵を生成しないと、checkHitsでエラーになる
  // ArrayList<Enemy> enemiesList = new ArrayList<Enemy>(); // 敵のリストを生成
  // enemiesList.add(new Enemy(width - 100, height / 3, "blue"));
  // enemiesList.add(new Enemy(width - 200, height / 2, "yellow"));
  // enemiesList.add(new Enemy(width - 300, height * 2 / 3, "red"));
  // attackManager.enemies = enemiesList; // Attackクラスのenemiesリストに設定
}

void draw() {
  background(50); // 背景を暗く設定

  // 各オブジェクトの更新
  player.update();
  attackManager.updateAttacks(); // 弾の移動と寿命処理
  
  // 当たり判定 (必ず引数を渡す)
  // attackManager.checkHits(attackManager.enemies, player); // コメントアウトを解除する場合は、attackManager.enemiesに有効なEnemyインスタンスが必要

  // PlayerのHPとレーザーゲージの値をUIに渡して更新
  uiManager.update(player.getHP(), player.getMaxHP(), player.getLaserGauge(), player.getMaxLaserGauge());

  // 各オブジェクトの描画
  player.display();
  attackManager.displayAttacks(); // 弾の描画
  uiManager.display(); // UIの描画
  
  // プレイヤーの攻撃 (キー入力などと連動させる)
  if (keyPressed) {
    if (key == 'z') { // zキーで通常の弾
      attackManager.playerShoot(player.x, player.y, "bullet");
    } else if (key == 'x') { // xキーでレーザー
      // レーザーゲージが十分な場合のみ発射できるようにする
      if (player.getLaserGauge() >= player.getMaxLaserGauge()) {
        attackManager.playerShoot(player.x, player.y, "laser");
        player.useLaserGauge(player.getMaxLaserGauge()); // レーザーゲージを消費
      }
    }
  }

  // 敵の攻撃 (例: 一定間隔で発射させる)
  long currentTime = millis();
  // 仮の敵のリストにアクセスできるようにする
  if (attackManager.enemies.size() > 0) { // 敵がいる場合のみ攻撃させる
    Enemy blueEnemy = attackManager.enemies.get(0); // 仮に最初の敵を青敵とする
    if (currentTime - attackManager.lastBlueShotTime > 5000) { // 5秒に1回
      attackManager.enemyShoot(blueEnemy.getX(), blueEnemy.getY(), "blue");
      attackManager.lastBlueShotTime = currentTime;
    }
    
    // 仮に2番目の敵を黄敵とする
    if (attackManager.enemies.size() > 1) {
      Enemy yellowEnemy = attackManager.enemies.get(1);
      if (currentTime - attackManager.lastYellowLaserTime > 60000) { // 1分に1回
        attackManager.enemyShoot(yellowEnemy.getX(), yellowEnemy.getY(), "yellow"); // 画面中央から発射
        attackManager.lastYellowLaserTime = currentTime;
      }
    }
  }
}

// Playerクラス (main.pde内で仮定義、別途ファイルに分けるのがProcessingの慣習)
// 実際のゲームではPlayer.pdeなどの別ファイルに記述
class Player {
  float x, y;
  int hp;
  int maxHp;
  float laserGauge;
  float maxLaserGauge;

  Player(float startX, float startY) {
    x = startX;
    y = startY;
    maxHp = 10;
    hp = maxHp;
    maxLaserGauge = 100;
    laserGauge = 0; // 仮の初期値
  }

  void update() {
    // プレイヤーの移動ロジックなどをここに記述 (例: マウスのX座標に追従)
    // x = mouseX; 
    // y = mouseY;

    // レーザーゲージを回復 (仮)
    if (laserGauge < maxLaserGauge) {
      laserGauge += 0.5;
    }
  }

  void display() {
    pushStyle();
    fill(0, 0, 255); // 青色のプレイヤー
    ellipse(x, y, 40, 40);
    popStyle();
  }

  int getHP() { return hp; }
  int getMaxHP() { return maxHp; }
  float getLaserGauge() { return laserGauge; }
  float getMaxLaserGauge() { return maxLaserGauge; }
  
  // 新しく追加: レーザーゲージを消費するメソッド
  void useLaserGauge(float amount) {
    laserGauge -= amount;
    if (laserGauge < 0) laserGauge = 0;
  }

  void takeDamage(int dmg) {
    hp -= dmg;
    if (hp < 0) hp = 0;
  }
  
  // 新しく追加: 当たり判定で必要なX, Y座標と幅、高さを返すゲッター
  float getX() { return x; }
  float getY() { return y; }
  float getWidth() { return 40; } // プレイヤーの幅
  float getHeight() { return 40; } // プレイヤーの高さ
}

// Enemyクラス (main.pde内で仮定義、別途ファイルに分けるのがProcessingの慣習)
// 実際のゲームではEnemy.pdeなどの別ファイルに記述
class Enemy {
  float x, y;
  String type;
  int hp;
  boolean dead = false;

  Enemy(float startX, float startY, String t) {
    x = startX;
    y = startY;
    type = t;
    hp = 10; // 仮のHP
  }

  void update() {
    // 敵の移動ロジックなどをここに記述
  }

  void display() {
    pushStyle();
    if (type.equals("blue")) fill(0, 0, 150);
    else if (type.equals("yellow")) fill(150, 150, 0);
    else if (type.equals("red")) fill(150, 0, 0);
    ellipse(x, y, 30, 30);
    popStyle();
  }

  void takeDamage(int dmg) {
    hp -= dmg;
    if (hp <= 0) dead = true;
  }

  boolean isDead() { return dead; }
  boolean isRushing() { return type.equals("red") && millis() % 2000 < 1000; } // 仮の突進状態
  
  // 新しく追加: 当たり判定で必要なX, Y座標を返すゲッター
  float getX() { return x; }
  float getY() { return y; }
  float getWidth() { return 30; } // 敵の幅
  float getHeight() { return 30; } // 敵の高さ
}
