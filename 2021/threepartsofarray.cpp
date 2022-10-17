#include <bits/stdc++.h>
 
using namespace std;
 
int main() {
    int n, d;
    cin >> n;
    vector<int> a;
 
    for (int i = 0; i < n; i++) {
        cin >> d;
        a.push_back(d);
    }
 
    set<long long> soma;
    long long l = 0;
 
    for (int i = 0; i < n; i++) {
        l += a[i];
        soma.insert(l);
    }
    
    long long retorno = 0;
    long long r = 0;
 
    for (int i = n - 1; i >= 0; --i) {
        soma.erase(l);
        l -= a[i];
        r += a[i];
 
        if(soma.count(r)) {
            retorno = max(retorno, r);
        }
    }
    
    cout << retorno << endl;
}