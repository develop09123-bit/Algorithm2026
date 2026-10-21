int[] arr;

void setup() {
  intArr(16);
  printArr();
  quickSorting();
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

void quickSorting() {
  quickSort(0, arr.length - 1);
}

void quickSort(int low, int high) {
  if (low < high) {
    int pi = partition(low, high);
    quickSort(low, pi - 1);
    quickSort(pi + 1, high);
  }
}

int partition(int low, int high) {
  int pivot = arr[high];
  int i = (low - 1);
  for (int j = low; j < high; j++) {
    if (arr[j] <= pivot) {
      i++;
      swap(i, j);
    }
  }
  swap(i + 1, high);
  return i + 1;
}

void swap(int i, int j) {
  int tmp;
  tmp = arr[j];
  arr[j] = arr[i];
  arr[i] = tmp;  
}

void draw() {
}
