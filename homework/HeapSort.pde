int   n = 16;
int[] myArray = new int[n];
int[] myArray1 = new int[n];
int   w = 12;
int l = 0;

void setup()
{
    size(600, 400);
    background(255);
    for(int i = 0; i < n; i++)
        myArray[i] = int(random(255));
    printArray();    
    //mergeSort(0, n - 1);  //merge sort 실행    
    heapSort(n);          //heap sort 실행    
    rectMode(CORNERS);
}

void printArray()
{
    for(int i = 0; i < n; i++)
      print(myArray[i] + " ");    
    println();
}

void swap(int i, int j)
{
    int t;
    t = myArray[i];
    myArray[i] = myArray[j];
    myArray[j] = t;
}

void mousePressed()
{
    if(l < n - 1)   l++;
}

void draw()
{
    stroke(128);
    fill(255);
    background(32);    
    for(int i = 0; i < n; i++)
        rect(i * w,  height, (i + 1) * w, height - myArray[i]);
}

void mergeSort(int p, int r)
{
    printArray();    
    if(r - p < 1)   return;    
    int q = (p + r) / 2;        
    mergeSort(p, q);
    mergeSort(q + 1, r);
    merge(p, q, r);    
}

void merge(int p, int q, int r)
{
    int a = 0;
    int i = p;
    int j = q + 1;
    int k = 0;
    while(i <= q && j <= r){
        if(myArray[i] < myArray[j]){
            myArray1[k] = myArray[i];
            ++i;
        }
        else{
            myArray1[k] = myArray[j];
            ++j;
        }
        ++k;
    }
    
    while(i <= q)
        myArray1[k++] = myArray[i++];    
    while(j <= r)
        myArray1[k++] = myArray[j++];        
    k = 0;
    for(a = p; a <= r; a++)
        myArray[a] = myArray1[k++];
}

void buildHeap(int n)
{
    for(int i = n / 2; i >= 0; --i)
        heapify(i, n);
}

void heapify(int k, int n)
{
    printArray();
    int left = 2 * k;
    int right = 2 * k + 1;
    int smaller = left;    
    if(left >= n)   return;
    if(right < n && myArray[right] < myArray[left])   smaller = right;
    if(myArray[k] > myArray[smaller]){
        swap(k, smaller);
        heapify(smaller, n);
    }
}

void heapSort(int n)
{
    buildHeap(n);
    for(int i = n - 1; i > 0; i--){
        swap(0, i);
        heapify(0, i);
    }
}
