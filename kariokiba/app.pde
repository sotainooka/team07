// === グローバル変数 ===
Player player;
UI ui;
Attack attack;
ArrayList<Enemy> enemies;

enum ScreenState { TITLE, GAME, GAMEOVER }
ScreenState currentScreen = ScreenState.TITLE;

// === 初期化 ===
void setup() {
  size(800, 600);
  player = new Player(width / 2, height - 60);
  ui = new UI();
  attack = new Attack();
  enemies = new ArrayList<Enemy>();

  // 敵を仮に3体追加
  enemies.add(new Enemy(100, 100, "blue"));
  enemies.add(new Enemy(300, 100, "red"));
  enemies.add(new Enemy(500, 100, "yellow"));
}

// === メインループ ===
void draw() {
  background(0);

  switch (currentScreen) {
    case TITLE:
      drawTitleScreen();
      break;
    case GAME:
      updateGame();
      drawGame();
      break;
    case GAMEOVER:
      drawGameOver();
      break;
  }
}

// === タイトル画面 ===
void drawTitleScreen() {
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(48);
  text("ここにタイトル", width / 2, height / 2 - 50);
  textSize(24);
  text("スペースキーでスタート", width / 2, height / 2 + 20);
}

// === キー入力 ===
void keyPressed() {
  if (currentScreen == ScreenState.TITLE && key == ' ') {
    currentScreen = ScreenState.GAME;
  } else if (currentScreen == ScreenState.GAME) {
    if (key == ' ') {
      attack.playerShoot(player.x + 20, player.y, false);
    } else if (key == 'l' || key == 'L') {
      if (player.gauge >= player.gaugeMax) {
        attack.playerShoot(player.x + 20, player.y, true);
        player.gauge = 0;
      }
    } else if (key == 'k' || key == 'K') {
      player.takeDamage(1); // テスト用
    }
  } else if (currentScreen == ScreenState.GAMEOVER && key == ' ') {
    restartGame();
  }
}

// === ゲームオーバー画面 ===
void drawGameOver() {
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  textSize(48);
  text("GAME OVER", width / 2, height / 2 - 20);
  textSize(24);
  text("スペースキーで再スタート", width / 2, height / 2 + 40);
}

// === ゲーム更新処理 ===
void updateGame() {
  player.move();
  for (Enemy e : enemies) {
    e.move();
  }

  attack.updateBullets();
  attack.checkHits(enemies, player);

  // UI更新
  ui.update(player.hp, player.maxHP, player.gauge, player.gaugeMax);

  // 敵の攻撃（簡易タイミングで自動発射）
  for (Enemy e : enemies) {
    if (e.alive) {
      attack.enemyShoot(e.x + e.width / 2, e.y + e.height, e.type);
    }
  }

  if (player.hp <= 0) {
    currentScreen = ScreenState.GAMEOVER;
  }
}

void drawGame() {
  player.display();
  for (Enemy e : enemies) {
    e.display();
  }
  attack.displayBullets();
  ui.display();
}

// === 再スタート ===
void restartGame() {
  player = new Player(width / 2, height - 60);
  ui = new UI();
  attack = new Attack();
  enemies.clear();
  enemies.add(new Enemy(100, 100, "blue"));
  enemies.add(new Enemy(300, 100, "red"));
  enemies.add(new Enemy(500, 100, "yellow"));
  currentScreen = ScreenState.GAME;
}
