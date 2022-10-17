#include <bits/stdc++.h>
 
using namespace std;
 
int main() {
    int n;
    int t[100010];
    int a[100010];
    cin >> n;

    for (int i = 0; i < n; i++) {
        cin >> t[i];
    }
    
    int s = t[0];
    int c = 0;

    for (int i = 0; i < n; i++) {
        if(s == t[i]) {
            a[c]++;
        } else {
            c++;
            a[c] = 1;
            s = t[i];
        }
    }

    int maximo = 0;

    for (int i = 1; i <= c; i++) {
        int b = min(a[i], a[i - 1]);
        maximo = max(maximo, b);
    }
    
    cout << maximo * 2 << endl;
}