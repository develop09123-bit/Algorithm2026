int[] arr;

void setup() {
  intArr(16);
  printArr();
  insertionSorting();
  printArr();
}

void intArr(int n) {
  int i;
  arr = new int[n];
  for(i=0; i<arr.length; i++) {
    arr[i] = (int) random(100);
  }
}

void printArr() {
  int i;
  for(i=0; i<arr.length; i++) {
    print(arr[i], " ");
  }
  println();
}

void insertionSorting() {
  int i, j, key;
  for (i = 1; i < arr.length; i++) {
    key = arr[i];
    j = i - 1;
    // 현재 원소보다 큰 값들을 오른쪽으로 한 칸씩 이동
    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];
      j = j - 1;
    }
    arr[j + 1] = key;
  }
}

void draw() {
}
