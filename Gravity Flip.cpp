#include <cstdio>
 
void printArray(int arr[], int size)
{
    int i;
    for (i=0; i < size; i++)
        printf("%d ", arr[i]);
    printf("\n");
}
 
void swap(int *xp, int *yp)
{
        int aux = *xp;
        *xp = *yp;
        *yp = aux;
}
 
void bubbleSort(int arr[], int n)
{
 
        int i, j;
        for (i = 0; i < n-1; i++)
 
                for (j = 0; j < n-i-1; j++)
                        if (arr[j] > arr[j+1])
                                swap(&arr[j], &arr[j+1]);
}
 
int main()
{
        int t;
        scanf("%i", &t);
        int arr[t];
        for(int i = 0; i < t; i++){
                scanf("%d", &arr[i]);
        }
        bubbleSort(arr, t);
        printArray(arr, t);
        return 0;
}
