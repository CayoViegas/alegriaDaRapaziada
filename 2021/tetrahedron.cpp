#include <bits/stdc++.h>
 
using namespace std;

int main() {
    int n;

    cin >> n;

    long long a[4][4] = {{0, 1, 1, 1}, {1, 0, 1, 1}, {1, 1, 0, 1}, {1, 1, 1, 0}};
    long long b[4][4] = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    
    while (n != 0) {
        if(n % 2 == 1) {
            long long c[4][4] = {0};

            for (int i = 0; i < 4; ++i) {
                for (int j = 0; j < 4; ++j) {
                    for (int k = 0; k < 4; ++k) {
                        c[i][j] += a[i][k] * b[k][j];
                    }

                    c[i][j] %= 1000000007LL;
                }
            }

            memcpy(b, c, sizeof(b));
        }

        long long c[4][4] = {0};

        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                for (int k = 0; k < 4; ++k) {
                    c[i][j] += a[i][k] * a[k][j];
                }

                c[i][j] %= 1000000007LL;
            }
        }
        memcpy(a, c, sizeof(a));

        n /= 2;
    }

    cout << b[0][0] << endl;
    return 0;
}