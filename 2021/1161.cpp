#include <stdio.h>

long long fat1 = 1;
long long fat2 = 1;
long long soma = 0;

int main() {

    int n, m;

    while(scanf("%d %d", &n, &m) != EOF) {

        for (int i = n; i > 0; i--)
             fat1 *= i;

        for (int j = m; j > 0; j--)
            fat2 *= j;

        soma = fat1 + fat2;
        fat1=fat2=1;

        printf("%lld\n", soma);

    }

    return 0;
}