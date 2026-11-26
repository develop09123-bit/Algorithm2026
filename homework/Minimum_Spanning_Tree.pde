import java.util.ArrayList;
import java.util.Collections;

ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();
int[] parent;
int currentEdgeIdx = 0;
int totalCost = 0;
boolean finished = false;

final int NUM_NODES = 7;
final int AUTO_INIT_STEPS = 3; // 시작 시 자동으로 연결할 횟수

class Node {
  int id;
  float x, y;
  Node(int id, float x, float y) {
    this.id = id;
    this.x = x;
    this.y = y;
  }
  void display() {
    fill(255);
    stroke(30);
    strokeWeight(2);
    ellipse(x, y, 32, 32);
    fill(20);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(id, x, y);
  }
}

class Edge implements Comparable<Edge> {
  int u, v;
  int weight;
  boolean selected = false;
  boolean rejected = false;

  Edge(int u, int v, int weight) {
    this.u = u;
    this.v = v;
    this.weight = weight;
  }

  int compareTo(Edge other) {
    return Integer.compare(this.weight, other.weight);
  }

  void display(boolean isCurrent) {
    Node a = nodes.get(u);
    Node b = nodes.get(v);

    // 단일 색상(검은색: 30)으로 통일하고 굵기와 투명도로만 상태 구분
    if (selected) {
      stroke(30, 255);
      strokeWeight(4);
    } else if (isCurrent) {
      stroke(30, 180);
      strokeWeight(2.5);
    } else if (rejected) {
      stroke(30, 35);
      strokeWeight(1);
    } else {
      stroke(30, 80);
      strokeWeight(1.5);
    }

    line(a.x, a.y, b.x, b.y);

    float mx = (a.x + b.x) * 0.5;
    float my = (a.y + b.y) * 0.5;
    fill(250);
    noStroke();
    ellipse(mx, my, 22, 22);

    fill(selected ? color(20, 255) : (rejected ? color(20, 80) : color(20, 170)));
    textAlign(CENTER, CENTER);
    textSize(12);
    text(weight, mx, my);
  }
}

int find(int x) {
  if (parent[x] == x) return x;
  parent[x] = find(parent[x]);
  return parent[x];
}

void union(int a, int b) {
  int rootA = find(a);
  int rootB = find(b);
  if (rootA != rootB) {
    parent[rootB] = rootA;
  }
}

void initGraph(int numNodes) {
  nodes.clear();
  edges.clear();
  currentEdgeIdx = 0;
  totalCost = 0;
  finished = false;
  parent = new int[numNodes];

  for (int i = 0; i < numNodes; i++) {
    parent[i] = i;
    float angle = TWO_PI * i / numNodes - HALF_PI;
    float radius = min(width, height) * 0.32;
    float nx = width * 0.5 + cos(angle) * radius;
    float ny = height * 0.52 + sin(angle) * radius;
    nodes.add(new Node(i, nx, ny));
  }

  for (int i = 0; i < numNodes; i++) {
    for (int j = i + 1; j < numNodes; j++) {
      if (random(1) < 0.65 || j == i + 1) {
        int w = int(random(1, 20));
        edges.add(new Edge(i, j, w));
      }
    }
  }

  Collections.sort(edges);

  int connectedCount = 0;
  while (!finished && connectedCount < AUTO_INIT_STEPS) {
    if (stepKruskal()) {
      connectedCount++;
    }
  }
}

boolean stepKruskal() {
  if (finished) return false;

  int mstEdgeCount = 0;
  for (Edge e : edges) {
    if (e.selected) mstEdgeCount++;
  }

  if (mstEdgeCount >= nodes.size() - 1 || currentEdgeIdx >= edges.size()) {
    finished = true;
    return false;
  }

  boolean connected = false;
  Edge e = edges.get(currentEdgeIdx);
  if (find(e.u) != find(e.v)) {
    union(e.u, e.v);
    e.selected = true;
    totalCost += e.weight;
    connected = true;
  } else {
    e.rejected = true;
  }

  currentEdgeIdx++;

  int updatedCount = 0;
  for (Edge ed : edges) {
    if (ed.selected) updatedCount++;
  }
  if (updatedCount >= nodes.size() - 1 || currentEdgeIdx >= edges.size()) {
    finished = true;
  }

  return connected;
}

void setup() {
  size(800, 600);
  initGraph(NUM_NODES);
}

void draw() {
  background(250);

  for (int i = 0; i < edges.size(); i++) {
    if (i != currentEdgeIdx) {
      edges.get(i).display(false);
    }
  }
  if (!finished && currentEdgeIdx < edges.size()) {
    edges.get(currentEdgeIdx).display(true);
  }

  for (Node n : nodes) {
    n.display();
  }

  fill(25);
  textAlign(LEFT, TOP);
  textSize(15);
  String status = finished ? "완료 (MST 완성)" : "진행 중: 가중치 오름차순 검사";
  text("Kruskal's Algorithm | " + status + " | 총 비용: " + totalCost, 20, 18);
  textSize(12);
  fill(90);
  text("클릭/SPACE: 다음 단계 | R: 새 그래프 | 굵은 선: 채택, 옅은 선: 미채택/제외", 20, 42);
}

void mousePressed() {
  stepKruskal();
}

void keyPressed() {
  if (key == ' ') {
    stepKruskal();
  } else if (key == 'r' || key == 'R') {
    initGraph(NUM_NODES);
  }
}
