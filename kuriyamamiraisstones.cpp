#include <bits/stdc++.h>
 
using namespace std;
 
int main() {
    int n, m;
    cin >> n;
    long long a1[n] = {};
    long long a2[n] = {};

    for (int i = 0; i < n; i++) {
        cin >> a1[i];
        a2[i] = a1[i];
    }

    sort(a2, a2 + n);
    
    for (int i = 1; i < n; i++) {
        a1[i] = a1[i - 1] + a1[i];
        a2[i] = a2[i - 1] + a2[i];
    }
    
    cin >> m;

    for (int i = 0; i < m; i++) {
        int t, l, r;
        cin >> t >> l >> r;
        l -= 1;
        r -= 1;

        if(t == 1) {
            if(l == 0) {
                cout << a1[r] << endl;
            } else {
                cout << a1[r] - a1[l - 1] << endl;
            }
        } else {
            if(l == 0) {
                cout << a2[r] << endl;
            } else {
                cout << a2[r] - a2[l - 1] << endl;
            }
        }
    }
}