#include <bits/stdc++.h>

using namespace std;

int main() {
    int x; cin >> x;

    for (int i = 0; i < x; i++) {
        long long a = 0; long long b = 1; long long c = 1; int n;
        cin >> n;

        if (n == 0) 
            cout << "Fib(0) = 0\n";
        else if (n == 1)
            cout << "Fib(1) = 1\n";
        else {
            for (int j = 2; j <= n; j++) {
                c = a + b;
                a = b;
                b = c;
            }

            cout << "Fib(" << n << ") = " << c << endl; 
        }
    }
    return 0;
}