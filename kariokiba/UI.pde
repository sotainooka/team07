// UI.pde

import processing.core.PFont;

class UI {
  int playerHP;
  int playerMaxHP; // Playerクラスから取得するmaxHP
  int playerGauge; // Playerクラスから取得するgauge
  int playerGaugeMax; // Playerクラスから取得するgaugeMax
  PFont font;

  UI() {
    font = createFont("sans-serif", 16);
    textFont(font);
  }

  // UI表示用の値を更新 (Playerから直接受け取る)
  void update(int currentHP, int maxHP, int currentGauge, int maxGauge) { // gaugeはint型
    this.playerHP = currentHP;
    this.playerMaxHP = maxHP;
    this.playerGauge = currentGauge;
    this.playerGaugeMax = maxGauge;
  }

  void display() {
    pushStyle();

    // HPバーの描画
    float hpRatio = (float)playerHP / playerMaxHP;
    float hpBarWidth = 200;
    float hpBarHeight = 15;
    float currentHpBarWidth = hpRatio * hpBarWidth;

    stroke(0);
    fill(50);
    rect(20, 20, hpBarWidth, hpBarHeight); // HPバー背景

    if (hpRatio > 0.6) {
      fill(0, 200, 0); // 緑
    } else if (hpRatio > 0.3) {
      fill(200, 200, 0); // 黄
    } else {
      fill(200, 0, 0); // 赤
    }
    rect(20, 20, currentHpBarWidth, hpBarHeight); // 現在のHPバー
    
    fill(255);
    textSize(14);
    textAlign(CENTER, CENTER);
    text("HP: " + playerHP + "/" + playerMaxHP, 20 + hpBarWidth / 2, 20 + hpBarHeight / 2);

    // ゲージの描画
    float gaugeBarWidth = 200;
    float gaugeBarHeight = 15;
    float currentGaugeBarWidth = (float)playerGauge / playerGaugeMax * gaugeBarWidth;

    stroke(0);
    fill(50);
    rect(20, 50, gaugeBarWidth, gaugeBarHeight); // ゲージ背景

    fill(0, 100, 200); // ゲージ色（青）
    rect(20, 50, currentGaugeBarWidth, gaugeBarHeight); // 現在のゲージ

    fill(255);
    textSize(12);
    textAlign(LEFT, CENTER);
    text("LASER GAUGE: " + playerGauge + "/" + playerGaugeMax, 25, 50 + gaugeBarHeight / 2);

    // ゲージが満タンになった時の表示
    if (playerGauge >= playerGaugeMax) {
      fill(255, 255, 0);
      textSize(20);
      textAlign(CENTER, CENTER);
      text("LASER READY!", width / 2, height - 50);
    }

    popStyle();
  }
}
