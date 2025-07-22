class Attack {
  ArrayList<Bullet> playerBullets;
  ArrayList<Bullet> enemyBullets;
  int frameCountBlue = 0;
  int frameCountRed = 0;
  int frameCountYellow = 0;

  Attack() {
    playerBullets = new ArrayList<Bullet>();
    enemyBullets = new ArrayList<Bullet>();
  }

  void playerShoot(float x, float y, boolean isLaser) {
    if (isLaser) {
      playerBullets.add(new Bullet(x, y, 2, "player_laser", 30));
    } else {
      playerBullets.add(new Bullet(x, y, 0, -8, 1, "player_bullet"));
    }
  }

  void enemyShoot(float x, float y, String enemyType) {
    if (enemyType.equals("blue")) {
      frameCountBlue++;
      if (frameCountBlue % (60 * 5) == 0) {
        enemyBullets.add(new Bullet(x, y, 0, 4, 1, "enemy_blue_bullet"));
      }
    }
    else if (enemyType.equals("yellow")) {
      frameCountYellow++;
      if (frameCountYellow >= 60 * 60) {  // 1分後
        enemyBullets.add(new Bullet(x, y, 0, 6, 7, "enemy_yellow_laser"));
        frameCountYellow = 0;
      }
    }
    // 赤は突進系のため、ここでは弾は生成しない
  }

  void updateBullets() {
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      Bullet b = playerBullets.get(i);
      b.update();
      if (!b.isAlive() || b.y < 0) {
        playerBullets.remove(i);
      }
    }

    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet b = enemyBullets.get(i);
      b.update();
      if (!b.isAlive() || b.y > height) {
        enemyBullets.remove(i);
      }
    }
  }

  void checkHits(ArrayList<Enemy> enemies, Player player) {
    // プレイヤーの弾が敵に当たる
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      Bullet b = playerBullets.get(i);
      for (Enemy e : enemies) {
        if (e.alive && e.isHit(b)) {
          e.alive = false;
          player.addGauge(1);
          playerBullets.remove(i);
          break;
        }
      }
    }

    // 敵の弾がプレイヤーに当たる
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet b = enemyBullets.get(i);
      if (b.x > player.x && b.x < player.x + 40 &&
          b.y > player.y && b.y < player.y + 40) {
        player.takeDamage(b.getDamage());
        enemyBullets.remove(i);
      }
    }
  }

  void displayBullets() {
    for (Bullet b : playerBullets) {
      b.display();
    }
    for (Bullet b : enemyBullets) {
      b.display();
    }
  }
}
