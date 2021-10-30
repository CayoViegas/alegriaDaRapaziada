#include <stdio.h>
#include <math.h>

int main() {
    int n; int query;
    scanf("%d", &n);

    for (int i = 0; i < n; i++) {
        scanf("%d", &query);

        long long grain = (pow(2, query) -1) / 12000;

        printf("%lld kg\n", grain);
    }

    return 0;
}