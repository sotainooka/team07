// Attack.pde

import java.util.ArrayList;

class Attack {
  // playerBullets は Playerクラスから受け取るArrayList
  // enemyBullets も同様
  ArrayList<Bullet> enemyBullets; // 敵の弾用リスト

  // 敵の攻撃間隔管理用
  long lastBlueShotTime = 0;
  long lastYellowLaserTime = 0;
  long lastRedRushTime = 0;

  // コンストラクタ (リストは外部から渡されるか、ここで初期化)
  Attack() {
    enemyBullets = new ArrayList<Bullet>(); // 敵の弾リストはここで管理
  }

  // プレイヤーの弾を生成し、リストに追加
  // playerBullets リストはメインスケッチで管理し、ここに渡す
  void playerShoot(float playerX, float playerY, boolean isLaser, ArrayList<Bullet> playerBulletsList) {
    if (isLaser) {
      // レーザー用のBulletコンストラクタを呼び出す
      playerBulletsList.add(new Bullet(playerX - 25, playerY - 2.5, 0, -10, 2, true, 60)); // 強力レーザー, 寿命60フレーム
    } else {
      playerBulletsList.add(new Bullet(playerX + 20, playerY, 0, -8, 1, true)); // 通常弾
    }
  }

  // 敵の弾を生成し、リストに追加 (敵の種類に応じて弾を生成)
  void enemyShoot(float enemyX, float enemyY, String enemyType) {
    long currentTime = millis();

    if (enemyType.equals("blue")) {
      if (currentTime - lastBlueShotTime > 2000) { // 2秒に1回
        // 敵の弾は下方向に飛ぶように調整 (y軸正方向)
        enemyBullets.add(new Bullet(enemyX, enemyY + 10, 0, 3, 1, false)); // 通常敵弾
        lastBlueShotTime = currentTime;
      }
    } else if (enemyType.equals("yellow")) {
      if (currentTime - lastYellowLaserTime > 15000) { // 15秒に1回レーザー
        // 敵レーザーは画面横断を想定
        enemyBullets.add(new Bullet(0, enemyY, 0, 0, 3, false, 90)); // 敵の強力レーザー, 寿命90フレーム
        lastYellowLaserTime = currentTime;
      }
    } else if (enemyType.equals("red")) {
      // 赤い敵の突進はEnemyクラスで直接移動を管理するため、ここでは弾は生成しない
      // ここは「弾」の発射のみに限定
    }
  }

  // 弾の移動と寿命処理
  void updateBullets(ArrayList<Bullet> playerBulletsList) { // playerBulletsList を引数として受け取る
    // プレイヤーの弾の更新
    for (int i = playerBulletsList.size() - 1; i >= 0; i--) {
      Bullet b = playerBulletsList.get(i);
      b.update();
      if (!b.isAlive()) { // 画面外か寿命切れ
        playerBulletsList.remove(i);
      }
    }

    // 敵の弾の更新
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet b = enemyBullets.get(i);
      b.update();
      if (!b.isAlive()) { // 画面外か寿命切れ
        enemyBullets.remove(i);
      }
    }
  }

  // 当たり判定とダメージ処理
  // enemiesList と player はメインスケッチから渡される
  void checkHits(ArrayList<Enemy> enemiesList, Player player) {
    // プレイヤーの弾と敵の当たり判定
    for (int i = player.bullets.size() - 1; i >= 0; i--) { // Playerクラスがbulletsリストを持っていると仮定
      Bullet pBullet = player.bullets.get(i);
      boolean hitEnemy = false;

      for (int j = enemiesList.size() - 1; j >= 0; j--) {
        Enemy enemy = enemiesList.get(j);

        if (enemy.alive) { // 敵が生きている場合のみ判定
          if (pBullet.isHit(enemy)) { // EnemyクラスにisHitメソッドが必要
            enemy.takeDamage(pBullet.getDamage());

            if (pBullet.getType().equals("player_bullet")) { // 通常弾は当たったら消える
              hitEnemy = true;
            }
            // レーザーは複数の敵に当たるので、すぐには消さない（寿命で消える）
          }
        }
      }
      if (hitEnemy) {
        player.bullets.remove(i); // 弾が当たったら削除
      }
    }

    // 敵の弾とプレイヤーの当たり判定
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet eBullet = enemyBullets.get(i);
      // PlayerクラスにisHitメソッドが必要
      if (player.isHit(eBullet)) {
        player.takeDamage(eBullet.getDamage());

        // 敵の通常弾は当たったら消える。レーザーは寿命で消える
        if (!eBullet.getType().equals("enemy_yellow_laser")) {
          enemyBullets.remove(i);
        }
      }
    }

    // 赤い敵の突進とプレイヤーの当たり判定
    long currentTime = millis();
    for (Enemy enemy : enemiesList) {
      if (enemy.type.equals("red") && enemy.isRushing() && enemy.alive) { // 赤い敵が突進中で生きている
        if (player.isHit(enemy)) { // PlayerクラスにEnemyとのisHitメソッドが必要
          if (currentTime - lastRedRushTime > 1000) { // 1秒に1回のみダメージ
            player.takeDamage(3); // 赤い敵の突進ダメージ
            lastRedRushTime = currentTime;
          }
        }
      }
    }
  }

  // 描画メソッド
  void displayBullets(ArrayList<Bullet> playerBulletsList) { // playerBulletsList を引数として受け取る
    for (Bullet b : playerBulletsList) {
      b.display();
    }
    for (Bullet b : enemyBullets) {
      b.display();
    }
  }
}
