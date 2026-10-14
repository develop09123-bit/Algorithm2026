ArrayList<Array> lists;
Array list, plist, tlist;
int type = 0, napTime = 100, len = 16, index = 0, loop = 0;
boolean autoFlag = true;
String[] titles = {"selectionSort", "bubbleSort", "insertSort", "mergeSort", "quickSort"};
PFont f;

void setup() {
  size(900, 600);  
  // 기본 폰트(Arial) 사용으로 외부 .vlw 파일 에러 방지
  f = createFont("Arial", 24);
  textFont(f);
  run(type);
}

void draw() {
  background(200);
  list = lists.get(index);
  list.draw();
  fill(0);
  
  if (list.i0 <= 0)
    text("(" + nf(-list.i0, 2) + "," + nf(-list.j0, 2) + ") - " + index + "/" + loop 
      + " napTime:" + napTime + "(a/s)" + " type:" + type + "(z/x)", 20, height - 20);
  else
    text("(" + nf(list.i0, 2) + "," + nf(list.j0, 2) + ") - " + index + "/" + loop 
      + " napTime:" + napTime + "(a/s)" + " type:" + type + "(z/x)", 20, height - 20);
      
  text(titles[type], 20, 40);
  if (autoFlag) nextStep();
}

void nextStep() {
  if (index == 0)
    delay(10 * napTime);
  else 
    delay(napTime);
    
  if (index < loop) index++;
  else index = 0;
}

void keyPressed() {
  if (key == ' ') {
    autoFlag = !autoFlag;
  }
  else if (key == 'a') {
    if (napTime > 100)
      napTime -= 100;
  }
  else if (key == 's') {
    napTime += 100;
  }
  else if (key == 'z') {
    if (type > 0) {
      type--;
      run(type);
    }  
  }
  else if (key == 'x') {
    // 3(mergeSort)까지 전환 가능하도록 설정
    if (type < titles.length - 2) { 
      type++;
      run(type);
    }  
  }
  else if (key == CODED) {
    if (keyCode == LEFT) {
      if (index > 0) index--;
    } else if (keyCode == RIGHT) {
      if (index < loop) index++;
    } 
  }
}

void mousePressed() {
  if (autoFlag) autoFlag = false;
  if (mouseButton == LEFT) {
    if (index > 0) index--;
  }
  else if (mouseButton == RIGHT) {
    if (index < loop) index++;
  }
}

void run(int type) {
  loop = index = 0;
  tlist = new Array(len, 0, -1);
  lists = new ArrayList<Array>();
  lists.add(new Array(len, 0, -1));
  list = lists.get(0);
  list.printData(); // 충돌 방지를 위해 printData()로 변경
  
  if (type == 0) selectionSort();
  else if (type == 1) bubbleSort();
  else if (type == 2) insertSort();
  else if (type == 3) mergeSort();
  
  list = lists.get(loop);
  list.printData(); // 충돌 방지를 위해 printData()로 변경
}

void selectionSort() {
  int i, j, max, index, tlen = len;
  for (i = 0; i < len; i++) {
    plist = lists.get(i);
    lists.add(new Array(len, plist.arr, i + 1, len - i - 1));
    loop++;
    list = lists.get(i + 1);    
    max = -1;
    index = -1;
    for (j = 0; j < tlen; j++) {
      if (max < list.arr[j]) {
        max = list.arr[j];
        index = j;
      }
    }
    if (index != -1) swap(list.arr, index, tlen - 1);
    tlen--;
  }
}

void bubbleSort() {
  int i, j;
  for (j = 0; j < len - 1; j++) {
    plist = lists.get(loop);
    lists.add(new Array(len, plist.arr, j + 1, 0));
    loop++;
    for (i = 0; i < len - j - 1; i++) {
      plist = lists.get(loop);
      lists.add(new Array(len, plist.arr, j + 1, i + 1));
      loop++;
      list = lists.get(loop);    
      if (list.arr[i] > list.arr[i + 1])
        swap(list.arr, i, i + 1);
    }
  }
}

void insertSort() {
  int i, j, temp;
  for (i = 1; i < len; i++) {
    plist = lists.get(loop);
    lists.add(new Array(len, plist.arr, i, i));
    loop++;
    list = lists.get(loop);    
    temp = list.arr[i];
    for (j = i - 1; j >= 0 && temp < list.arr[j]; j--) {
      list.arr[j + 1] = list.arr[j];
    }
    list.arr[j + 1] = temp;
  }
}

void mergeSort() {
  mergeSort(0, len - 1);
}

void mergeSort(int low, int high) {
  if (low < high) {
    int middle = low + (high - low) / 2;
    plist = lists.get(loop);
    lists.add(new Array(len, plist.arr, -low, -high));
    loop++;
    list = lists.get(loop);    
    mergeSort(low, middle);
    mergeSort(middle + 1, high);
    merge(list, low, middle, high);
  }
}

void merge(Array list, int low, int middle, int high) {
  int i, j, k;
  i = low;
  j = middle + 1;
  k = low;
  for (i = low; i <= high; i++) 
    tlist.arr[i] = list.arr[i];
  for (i = low; i <= high; i++) {
    while (i <= middle && j <= high) {
      if (tlist.arr[i] <= tlist.arr[j]) {
        list.arr[k] = tlist.arr[i];
        i++;
      } 
      else {
        list.arr[k] = tlist.arr[j];
        j++;
      }
      k++;
    }
    while (i <= middle) {
      list.arr[k] = tlist.arr[i];
      k++;
      i++;
    }
  }
}

void swap(int[] arr, int i, int j) {
  int tmp = arr[j];
  arr[j] = arr[i];
  arr[i] = tmp;
}

// ==========================================
// Array 클래스 정의 (printData로 충돌 해결)
// ==========================================
class Array {
  int[] arr;
  int i0, j0;

  // 최초 생성자 (무작위 높이 값 부여)
  Array(int len, int val, int marker) {
    arr = new int[len];
    for (int i = 0; i < len; i++) {
      arr[i] = int(random(30, 400));
    }
    i0 = marker;
    j0 = 0;
  }

  // 복사 생성자 (이전 상태 기록용)
  Array(int len, int[] src, int i, int j) {
    arr = new int[len];
    arrayCopy(src, arr);
    i0 = i;
    j0 = j;
  }

  // 막대그래프 시각화 드로잉
  void draw() {
    int w = width / arr.length;
    for (int i = 0; i < arr.length; i++) {
      if (i == abs(i0) || i == abs(j0)) {
        fill(255, 0, 0); // 현재 비교/변경 중인 막대: 빨간색
      } else {
        fill(100, 150, 255); // 일반 막대: 파란색
      }
      stroke(0);
      rect(i * w + 5, height - 120 - arr[i], w - 10, arr[i]);
      
      fill(0);
      textAlign(CENTER);
      textSize(11);
      text(arr[i], i * w + w / 2, height - 95);
    }
  }

  // 내장 함수 printArray와의 충돌을 피하기 위해 printData로 변경
  void printData() {
    printArray(arr);
  }
}
