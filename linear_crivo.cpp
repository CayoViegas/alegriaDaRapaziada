#include <stdio.h>
#include <math.h>

int arr[100];

int main() {

    for (int i = 1; i <= 100; i++)
        arr[i - 1] = i;

    for (int i = 1; i < int(sqrt(100)); i++) {

        for (int j = i; j < 100; j++)
            if (arr[j] % arr[i] == 0 && arr[j] != arr[i]) arr[j] = 0;
    }

    for (int i = 0; i < 100; i++)
        printf("%d\n", arr[i]);

    return 0;
}