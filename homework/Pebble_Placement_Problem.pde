final int ROWS = 3;
final int COLS = 8;

// 4가지 유효 패턴 (패턴 0: 1행, 패턴 1: 2행, 패턴 2: 3행, 패턴 3: 1행+3행)
final int[][] PATTERNS = {
  {1, 0, 0},
  {0, 1, 0},
  {0, 0, 1},
  {1, 0, 1}
};

// 각 패턴 i 다음에 올 수 있는 양립 가능한 패턴 목록
final int[][] COMPATIBLE = {
  {1, 2},    // 패턴 0(1행) 다음엔 2행(1) 또는 3행(2) 가능
  {0, 2, 3}, // 패턴 1(2행) 다음엔 1행(0), 3행(2), 1+3행(3) 가능
  {0, 1},    // 패턴 2(3행) 다음엔 1행(0) 또는 2행(1) 가능
  {1}        // 패턴 3(1+3행) 다음엔 2행(1)만 가능
};

int[][] grid = new int[ROWS][COLS];
int[][] dp = new int[COLS][4];
int[][] prevPattern = new int[COLS][4];
int[] bestPath = new int[COLS];

int currentCol = 0;
boolean finished = false;
int maxScore = 0;

void setup() {
  size(860, 520);
  initProblem();
}

void initProblem() {
  currentCol = 0;
  finished = false;
  maxScore = 0;

  for (int r = 0; r < ROWS; r++) {
    for (int c = 0; c < COLS; c++) {
      grid[r][c] = int(random(-5, 16)); // 음수~양수 가중치 생성
    }
  }

  for (int c = 0; c < COLS; c++) {
    bestPath[c] = -1;
    for (int p = 0; p < 4; p++) {
      dp[c][p] = -999999;
      prevPattern[c][p] = -1;
    }
  }

  // 첫 번째 열(0열) 초기값 계산
  for (int p = 0; p < 4; p++) {
    dp[0][p] = getPatternScore(0, p);
  }
  updateBestPathUpTo(0);
}

int getPatternScore(int col, int p) {
  int sum = 0;
  for (int r = 0; r < ROWS; r++) {
    if (PATTERNS[p][r] == 1) {
      sum += grid[r][col];
    }
  }
  return sum;
}

void stepDP() {
  if (finished) return;

  currentCol++;
  if (currentCol >= COLS) {
    finished = true;
    return;
  }

  // 점화식: dp[c][p] = score(c, p) + max(dp[c-1][prev])
  for (int p = 0; p < 4; p++) {
    int score = getPatternScore(currentCol, p);
    int bestPrevVal = -999999;
    int bestPrevIdx = -1;

    for (int prev : COMPATIBLE[p]) {
      if (dp[currentCol - 1][prev] > bestPrevVal) {
        bestPrevVal = dp[currentCol - 1][prev];
        bestPrevIdx = prev;
      }
    }
    dp[currentCol][p] = score + bestPrevVal;
    prevPattern[currentCol][p] = bestPrevIdx;
  }

  updateBestPathUpTo(currentCol);

  if (currentCol == COLS - 1) {
    finished = true;
  }
}

void updateBestPathUpTo(int targetCol) {
  int bestEndP = 0;
  for (int p = 1; p < 4; p++) {
    if (dp[targetCol][p] > dp[targetCol][bestEndP]) {
      bestEndP = p;
    }
  }
  maxScore = dp[targetCol][bestEndP];

  // 역추적(Backtracking)으로 최적 패턴 경로 복원
  for (int c = 0; c < COLS; c++) bestPath[c] = -1;
  int currP = bestEndP;
  for (int c = targetCol; c >= 0; c--) {
    bestPath[c] = currP;
    currP = prevPattern[c][currP];
  }
}

void draw() {
  background(250);

  float cellW = 80;
  float cellH = 70;
  float startX = (width - COLS * cellW) * 0.5;
  float startY = 110;

  // 상단 안내 텍스트
  fill(25);
  textAlign(LEFT, TOP);
  textSize(16);
  String status = finished ? "완료 (최적 배치 확정)" : "진행 중 (" + (currentCol + 1) + " / " + COLS + " 열 계산)";
  text("Pebble Placement Problem (DP) | " + status + " | 현재 최대 점수: " + maxScore, 30, 22);

  textSize(12);
  fill(90);
  text("클릭 또는 SPACE: 다음 열 계산 | R: 새 숫자판 생성 | 인접(상하좌우) 칸에는 조약돌을 동시에 놓을 수 없음", 30, 48);

  // 격자 및 조약돌 그리기
  for (int c = 0; c < COLS; c++) {
    float x = startX + c * cellW;

    // 현재 계산된 열 강조
    if (c == currentCol) {
      noStroke();
      fill(30, 15);
      rect(x - 4, startY - 8, cellW + 8, ROWS * cellH + 16, 8);
    }

    for (int r = 0; r < ROWS; r++) {
      float y = startY + r * cellH;
      boolean hasPebble = (bestPath[c] != -1 && PATTERNS[bestPath[c]][r] == 1);

      stroke(180);
      strokeWeight(1.5);
      fill(hasPebble ? color(235) : color(255));
      rect(x, y, cellW, cellH);

      // 조약돌 표시 (단일 색상 통일)
      if (hasPebble) {
        stroke(30);
        strokeWeight(2.5);
        fill(30, 35);
        ellipse(x + cellW * 0.5, y + cellH * 0.5, 46, 46);
      }

      // 칸 점수 텍스트
      fill(20);
      textAlign(CENTER, CENTER);
      textSize(16);
      text(grid[r][c], x + cellW * 0.5, y + cellH * 0.5);
    }

    // 하단 DP 테이블(4가지 패턴별 누적 최대값) 표시
    float dpStartY = startY + ROWS * cellH + 35;
    fill(60);
    textSize(11);
    textAlign(CENTER, CENTER);
    if (c == 0) {
      textAlign(RIGHT, CENTER);
      String[] pNames = {"패턴1 (상)", "패턴2 (중)", "패턴3 (하)", "패턴4 (상+하)"};
      for (int p = 0; p < 4; p++) {
        text(pNames[p], startX - 12, dpStartY + p * 26);
      }
    }

    if (c <= currentCol) {
      for (int p = 0; p < 4; p++) {
        boolean isSelectedPattern = (bestPath[c] == p);
        fill(isSelectedPattern ? color(20) : color(130));
        textSize(isSelectedPattern ? 13 : 11);
        textAlign(CENTER, CENTER);
        text(dp[c][p], x + cellW * 0.5, dpStartY + p * 26);
      }
    }
  }
}

void mousePressed() {
  stepDP();
}

void keyPressed() {
  if (key == ' ') {
    stepDP();
  } else if (key == 'r' || key == 'R') {
    initProblem();
  }
}
