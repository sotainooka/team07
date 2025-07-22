String currentScreen = "title";

Player player;
ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;

int buttonX = 160;
int buttonY = 300;
int buttonW = 160;
int buttonH = 50;

float enemySpeed = 2;
int enemyDirection = 1;  // 1: 右, -1: 左
ArrayList<EnemyBullet> enemyBullets;
int enemyFireInterval = 90;  // 何フレームに1発撃つか（約1.5秒）
int enemyFireTimer = 0;
boolean isGameOver = false;
boolean isGameClear = false;
int startTime;
int clearTime = 0;  // クリア時の時間
int difficulty = 2;  // 1: Easy, 2: Normal, 3: Hard

void setup() {
  size(480, 640);
  PFont font = createFont("MS Gothic", 16);  // Windowsなら"MS Gothic"が定番
  textFont(font);
  initGame();
  imageMode(CENTER);
}

void initGame() {
  setDifficulty(difficulty);
  startTime = millis(); 
  player = new Player();
  bullets = new ArrayList<Bullet>();
  enemies = new ArrayList<Enemy>();
  enemyBullets = new ArrayList<EnemyBullet>();
enemyFireTimer = 0;

  int cols = 8;   // 横に8体
  int rows = 3;   // 縦に3行
  int spacingX = 50;
  int spacingY = 40;
  int startX = 40;
  int startY = 60;

  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      float x = startX + col * spacingX;
      float y = startY + row * spacingY;
      enemies.add(new Enemy(x, y));
    }
  }
}

void draw() {
  background(0);


  if (currentScreen.equals("title")) {
    drawTitleScreen();
  } else if (currentScreen.equals("game")) {
    drawGameScreen();
  }
}

void drawTitleScreen() {
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("SHOOTING GAME", width / 2, 200);

  // ボタンの表示
  fill(100, 200, 255);
  rect(buttonX, buttonY, buttonW, buttonH, 10);
  fill(0);
  textSize(20);
  text("START", buttonX + buttonW / 2, buttonY + buttonH / 2);
  
  // 難易度選択ボタン
  fill(difficulty == 1 ? color(100, 255, 100) : 200);
  rect(70, 360, 100, 40, 10);
  fill(0);
  textSize(18);
  text("Easy", 120, 380);

  fill(difficulty == 2 ? color(255, 255, 100) : 200);
  rect(190, 360, 100, 40, 10);
  fill(0);
  text("Normal", 240, 380);

  fill(difficulty == 3 ? color(255, 100, 100) : 200);
  rect(310, 360, 100, 40, 10);
  fill(0);
  text("Hard", 360, 380);
}

void drawGameScreen() {
  if (isGameOver) {
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(36);
    text("GAME OVER", width / 2, height / 2);
    textSize(16);
    text("スペースキーでタイトルへ", width / 2, height / 2 + 40);
    return;
  }

if (isGameClear) {
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    textSize(36);
    text("GAME CLEAR!", width / 2, height / 2);
    textSize(20);
    text("タイム: " + nf(clearTime / 1000.0, 0, 2) + " 秒", width / 2, height / 2 + 35);
    textSize(16);
    text("スペースキーでタイトルへ", width / 2, height / 2 + 60);
    return;
  }

  player.move();
  player.display();

  // 弾処理
for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.move();
    b.display();

    if (b.offScreen()) {
      bullets.remove(i);
      continue;
    }

    for (Enemy e : enemies) {
      if (e.alive && e.isHit(b)) {
        e.alive = false;
        bullets.remove(i);
        break;
      }
    }
  }
  // 敵の移動と描画
  boolean needToReverse = false;

  for (Enemy e : enemies) {
    if (e.alive) {
      e.x += enemySpeed * enemyDirection;

      // 一番端の敵が端に着いたかをチェック
      if (e.x < 0 || e.x + e.w > width) {
        needToReverse = true;
      }
    }
  }

  // 方向反転（全体）
  if (needToReverse) {
    enemyDirection *= -1;
  }

  // 敵の描画
  for (Enemy e : enemies) {
    if (e.alive) {
      e.display();
    }
  }
  
  // 敵弾の発射タイミング
enemyFireTimer++;
if (enemyFireTimer >= enemyFireInterval) {
  enemyFireTimer = 0;

  // 生きている敵からランダムに1体選んで弾を撃たせる
  ArrayList<Enemy> aliveEnemies = new ArrayList<Enemy>();
  for (Enemy e : enemies) {
    if (e.alive) aliveEnemies.add(e);
  }

  if (aliveEnemies.size() > 0) {
    Enemy shooter = aliveEnemies.get((int)random(aliveEnemies.size()));
    enemyBullets.add(new EnemyBullet(shooter.x + shooter.w / 2, shooter.y + shooter.h));
  }
}
 // 敵弾の移動と描画
for (int i = enemyBullets.size() - 1; i >= 0; i--) {
  EnemyBullet eb = enemyBullets.get(i);
  eb.move();
  eb.display();

  if (eb.offScreen()) {
    enemyBullets.remove(i);
    continue;
  }

  //  プレイヤーとの当たり判定
  float dx = abs(eb.x - player.x);
  float dy = abs(eb.y - player.y);
  if (dx < 15 && dy < 15) {  // 判定サイズは自機サイズに合わせて調整
    isGameOver = true;
  }
}
// 全ての敵が倒されていたらクリア
boolean allEnemiesDead = true;
for (Enemy e : enemies) {
  if (e.alive) {
    allEnemiesDead = false;
    break;
  }
}
if (allEnemiesDead) {
  isGameClear = true;
  clearTime = millis() - startTime;  // クリア時の経過時間を保存
}
}

void mousePressed() {
  if (currentScreen.equals("title")) {
        // 難易度ボタン
    if (mouseX >= 100 && mouseX <= 200 && mouseY >= 360 && mouseY <= 400) {
      difficulty = 1;  // Easy
    } else if (mouseX >= 220 && mouseX <= 320 && mouseY >= 360 && mouseY <= 400) {
      difficulty = 2;  // Normal
    } else if (mouseX >= 340 && mouseX <= 440 && mouseY >= 360 && mouseY <= 400) {
      difficulty = 3;  // Hard
    }
    if (mouseX >= buttonX && mouseX <= buttonX + buttonW &&
        mouseY >= buttonY && mouseY <= buttonY + buttonH) {
      currentScreen = "game";
      initGame();  // ゲーム初期化
    }
  }
 
}

void keyPressed() {
  if (currentScreen.equals("game")) {
    if (!isGameOver && !isGameClear && key == ' ') {
      bullets.add(new Bullet(player.x, player.y));
    }
    if ((isGameOver || isGameClear) && key == ' ') {
      currentScreen = "title";
      isGameOver = false;
      isGameClear = false;
    }
  }
}

void setDifficulty(int level) {
  difficulty = level;
  if (difficulty == 1) {  // Easy
    enemySpeed = 1.5;
    enemyFireInterval = 120;
  } else if (difficulty == 2) {  // Normal
    enemySpeed = 2.0;
    enemyFireInterval = 90;
  } else if (difficulty == 3) {  // Hard
    enemySpeed = 3.0;
    enemyFireInterval = 30;
  }
}
