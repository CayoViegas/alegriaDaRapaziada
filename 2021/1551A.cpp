#include <stdio.h>

int a = 0; int b = 0;

int main() {
    int t; int n;
    double x; double y;
    scanf("%d", &t);

    for (int i = 0; i < t; i++) {
        scanf("%d", &n);

        x = n * 0.33333;
        y = (n * 0.66666) / 2;

        printf("%f %f\n", x, y);

        if (x == y)
            b = int(y) + 1;
        else
            b = int(y);
        
        a =  int(x);

        printf("%d %d\n", a, b);
    }

    return 0;
}