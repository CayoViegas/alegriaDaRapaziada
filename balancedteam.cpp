#include <bits/stdc++.h>
 
using namespace std;

int main() {
    int n;
    cin >> n;
    vector<int> a;
    
    for (int i = 0; i < n; i++) {
        int d;
        cin >> d;
        a.push_back(d);
    }
    
    sort(a.begin(), a.end());

    int retorno = 0;
    int j = 0;

    for (int i = 0; i < n; i++) {
        while(j < n && a[j] - a[i] <= 5) {
            ++j;
            retorno = max(retorno, j - i);
        }
    }
    
    cout << retorno << endl;
}