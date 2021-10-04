#include <bits/stdc++.h>
 
using namespace std;

int main() {
    long long a, b, c, n, k, retorno, r;

    while(cin >> n >> a >> b >> c) {
        retorno = 0;

        for (int i = 0; i * a <= n; ++i) {
            for (int j = 0; i * a + j * b <= n; ++j) {
                r = n - i * a - j * b;

                if(r % c == 0) {
                    k = r / c;
                    retorno = max(retorno, i + j + k);
                }
            }
        }

        cout << retorno << endl;
    }

    return 0;
}