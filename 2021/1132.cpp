#include <stdio.h>

int soma = 0;

int main(){
    int a; int b;

    scanf("%d", &a);
    scanf("%d", &b);

    int comeco = a;
    int fim = b;

    if (a > b) {
        comeco = b;
        fim = a;
    }

    for (int i = comeco; i <= fim; i++) {
        if (i % 13 != 0) soma += i;
    }

    printf("%d\n", soma);

    return 0;

}