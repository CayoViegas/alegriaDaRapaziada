#include <stdio.h>

int main(){
    int n = 0; float query = 0; int dias = 0;
    scanf("%d", &n);

    for (int i = 0; i < n; i++) {
        scanf("%f", &query);

        while (query > 1.0) {
            query /= 2.0;
            dias++;
        }

        printf("%d dias\n", dias);

        dias = 0;

    }

    return 0;
}