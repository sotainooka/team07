// app.pde
import java.util.ArrayList; // 必要に応じて追加

// === グローバル変数 ===
Player player;
UI ui;
Attack attack;
ArrayList<Enemy> enemies; // このリストはAttackクラスと共有

enum ScreenState { TITLE, GAME, GAMEOVER }
ScreenState currentScreen = ScreenState.TITLE;

// === 初期化 ===
void setup() {
  size(800, 600);
  player = new Player(width / 2, height - 60); // PlayerクラスにmaxHPが含まれるように
  ui = new UI();
  attack = new Attack(); // Attackクラスのコンストラクタは引数なし
  
  // enemies リストはAttackクラスと共有するため、setupで生成してAttackクラスのenemiesフィールドにセットする
  enemies = new ArrayList<Enemy>(); // app.pde 内の enemies リストとして定義
  attack.enemies = enemies; // Attackクラスがこのリストを直接操作できるようにセット
  
  // 敵を仮に3体追加
  enemies.add(new Enemy(100, 100, "blue"));
  enemies.add(new Enemy(300, 100, "red"));
  enemies.add(new Enemy(500, 100, "yellow"));
}

// === メインループ ===
void draw() {
  background(0); // 背景を黒に設定

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
  text("ゲームタイトル", width / 2, height / 2 - 50); // タイトル表示
  textSize(24);
  text("スペースキーでスタート", width / 2, height / 2 + 20);
}

// === キー入力 ===
void keyPressed() {
  if (currentScreen == ScreenState.TITLE && key == ' ') {
    currentScreen = ScreenState.GAME;
  } else if (currentScreen == ScreenState.GAME) {
    if (key == ' ') { // スペースキーで通常弾
      attack.playerShoot(player.x, player.y, false, player.bullets); // player.bullets を渡す
      player.addGauge(1); // 弾を撃つとゲージ増加 (仮)
    } else if (key == 'l' || key == 'L') { // Lキーでレーザー
      if (player.getGauge() >= player.getGaugeMax()) {
        attack.playerShoot(player.x, player.y, true, player.bullets); // player.bullets を渡す
        player.useGauge(player.getGaugeMax()); // レーザーゲージをリセット
      }
    } else if (key == 'k' || key == 'K') {
      player.takeDamage(1); // テスト用ダメージ
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
  player.move(); // プレイヤーの移動

  // 敵の移動と更新
  for (int i = enemies.size() - 1; i >= 0; i--) { // 逆順ループで削除に対応
    Enemy e = enemies.get(i);
    e.move(); // 敵の移動
    // 敵のHPが0になったらリストから削除
    if (!e.alive) { // enemy.alive を直接参照
      enemies.remove(i);
    }
  }

  // 弾の更新（プレイヤーと敵）
  attack.updateBullets(player.bullets); // player.bullets を渡す

  // 当たり判定
  attack.checkHits(enemies, player); // enemies リストを渡す

  // UI更新
  ui.update(player.hp, player.maxHP, player.gauge, player.gaugeMax);

  // 敵の攻撃
