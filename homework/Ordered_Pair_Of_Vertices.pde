// 노드의 총 개수 (0번 ~ 6번, 총 7개)
int numNodes = 7;

// 각 노드의 (x, y) 좌표 설정
float[] x = { 200, 150, 300, 350, 450, 100, 400 };
float[] y = { 350, 150, 200, 350, 250, 100, 400 };

// 꼭짓점의 순서쌍(Ordered Pair)으로 표현된 간선 리스트: {시작점, 도착점}
int[][] edges = {
  {0, 1},  // (0, 1) 순서쌍
  {0, 2},  // (0, 2) 순서쌍
  {1, 2},  // (1, 2) 순서쌍
  {1, 5},  // (1, 5) 순서쌍
  {2, 3},  // (2, 3) 순서쌍
  {2, 4},  // (2, 4) 순서쌍
  {3, 6},  // (3, 6) 순서쌍
  {4, 6}   // (4, 6) 순서쌍
};

void setup() {
  size(600, 500);
  smooth();
}

void draw() {
  background(240); // 배경색 설정
  
  // 1. 순서쌍(Edges)을 순회하며 화살표 간선 그리기
  for (int i = 0; i < edges.length; i++) {
    int u = edges[i][0]; // 시작점 노드
    int v = edges[i][1]; // 도착점 노드
    
    drawArrow(x[u], y[u], x[v], y[v]);
  }
  
  // 2. 노드(Vertex)와 번호 그리기
  for (int i = 0; i < numNodes; i++) {
    fill(210); // 원 내부 색상 (연한 회색)
    stroke(50);
    strokeWeight(2);
    ellipse(x[i], y[i], 40, 40); // 노드 크기 40x40
    
    // 노드 번호 텍스트
    fill(0);
    textSize(18);
    textAlign(CENTER, CENTER);
    text(i, x[i], y[i]);
  }
}

// 순서쌍의 방향(시작점 -> 도착점)을 나타내는 화살표 함수
void drawArrow(float x1, float y1, float x2, float y2) {
  stroke(100);
  strokeWeight(2);
  
  // 노드 원의 경계에서 선이 시작하고 끝나도록 거리 계산 (반지름 r = 20)
  float r = 20; 
  float angle = atan2(y2 - y1, x2 - x1);
  float startX = x1 + cos(angle) * r;
  float startY = y1 + sin(angle) * r;
  float endX = x2 - cos(angle) * r;
  float endY = y2 - sin(angle) * r;
  
  // 선 그리기
  line(startX, startY, endX, endY);
  
  // 도착점에 화살표 머리(Triangle) 그리기
  pushMatrix();
  translate(endX, endY);
  rotate(angle);
  fill(100);
  noStroke();
  triangle(0, 0, -10, -5, -10, 5);
  popMatrix();
}
