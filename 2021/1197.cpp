#include <stdio.h>

int main() {
    int v; int t;

    while(scanf("%d %d", &v, &t) != EOF) {
        int query = (2 * t) * v;
        printf("%d\n", query);
    }

    return 0;
}