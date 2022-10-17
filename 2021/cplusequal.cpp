#include <bits/stdc++.h>
 
using namespace std;
 
int cpe(int a, int b, int n) {
    int retorno = 0;
 
    while (a <= n && b <= n) {
        if(a > b) {
            b = a + b;
            retorno++;
        } else {
            a = a + b;
            retorno++;
        }
    }
    
    return retorno;
}
 
int main() {
    int t;
    cin >> t;
 
    for (int i = 0; i < t; i++) {
        int a, b, n;
        cin >> a >> b >> n;
        cout << cpe(a, b, n) << endl;
    }
}