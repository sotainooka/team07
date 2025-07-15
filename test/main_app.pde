// ==== グローバル変数 ====

Player player;
ArrayList<Bullet> bullets;

enum ScreenState { TITLE, GAME, GAMEOVER }
ScreenState currentScreen = ScreenState.TITLE;

// ==== 初期化処理 ====

void setup() {
  size(800, 600);
  player = new Player(width/2, height - 60);
  bullets = new ArrayList<Bullet>();
}

// ==== メインループ ====

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

// ==== タイトル画面 ====

void drawTitleScreen() {
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(48);
  text("ここにタイトル", width/2, height/2 - 50);
  textSize(24);
  text("スペースキーでスタート", width/2, height/2 + 20);
}

void keyPressed() {
  if (currentScreen == ScreenState.TITLE && key == ' ') {
    currentScreen = ScreenState.GAME;
  } else if (currentScreen == ScreenState.GAME) {
    if (key == ' ') {
      player.shoot(bullets);
    } else if (key == 'l' || key == 'L') {
      player.shootLaser(bullets);
    }
  } else if (currentScreen == ScreenState.GAMEOVER && key == ' ') {
    restartGame();
  }
}

// ==== ゲームオーバー画面 ====

void drawGameOver() {
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  textSize(48);
  text("GAME OVER", width/2, height/2 - 20);
  textSize(24);
  text("スペースキーで再スタート", width/2, height/2 + 40);
}

// ==== ゲーム本編 ====

void updateGame() {
  player.move();

  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.move();
    if (b.isOffScreen()) {
      bullets.remove(i);
    }
  }

  // テスト：強制的に死亡するキー（例: 'k'）でHP確認
  if (keyPressed && key == 'k') {
    player.takeDamage(1);
  }
}

void drawGame() {
  player.display();
  for (Bullet b : bullets) {
    b.display();
  }
}

// ==== ゲーム再スタート ====

void restartGame() {
  player = new Player(width/2, height - 60);
  bullets.clear();
  currentScreen = ScreenState.GAME;
}
