class Player {
  float x, y;
  float speed;
  int hp;
  int gauge;          // レーザーゲージ
  int gaugeMax = 5;
  PImage img;

  Player(float x, float y) {
    this.x = x;
    this.y = y;
    this.speed = 5;
    this.hp = 10;
    this.gauge = 0;
    img = loadImage("player.png");
  }

  void display() {
    if (img != null) {
    image(img, x, y, 40, 40);  // 40×40 にリサイズ表示
  } else {
    fill(255, 204, 0);
    rect(x, y, 40, 40);
  }// 自機本体
    displayHP();
    displayGauge();
  }

  void move() {
    if (keyPressed) {
      if (key == 'a' || keyCode == LEFT) x -= speed;
      if (key == 'd' || keyCode == RIGHT) x += speed;
    }
  }

  void shoot(ArrayList<Bullet> bullets) {
    bullets.add(new Bullet(x + 20, y, 0, -8, 1, true));  // 通常弾
  }

  void shootLaser(ArrayList<Bullet> bullets) {
    if (gauge >= gaugeMax) {
      bullets.add(new Bullet(x + 20, y, 0, -10, 2, true)); // 強力レーザー
      gauge = 0;  // リセット
    }
  }

  void takeDamage(int damage) {
    hp -= damage;
    if (hp <= 0) {
      hp = 0;
      die();  // 死亡処理を呼び出す
    }
  }
  
  void die() {
  currentScreen = ScreenState.GAMEOVER;  // メイン側の変数を変更
}

  void addGauge(int amount) {
    gauge = min(gauge + amount, gaugeMax);
  }

  void displayHP() {
    fill(255);
    text("HP: " + hp, 10, 20);
  }

  void displayGauge() {
    fill(0, 255, 255);
    text("ゲージ: " + gauge + "/" + gaugeMax, 10, 40);
  }
}
