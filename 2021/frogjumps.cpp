#include <bits/stdc++.h>
 
using namespace std;
 
void fj(string s) {
    int retorno = 0;
    vector<int> v;
    v.push_back(0);

    for (int i = 0; i < int(s.size()); i++) {
        if(s[i] == 'R') {
            v.push_back(i + 1);
        }
    }

    v.push_back(s.size() + 1);
    
    for (int i = 0; i < int(v.size()) - 1; i++) {
        retorno = max(retorno, v[i + 1] - v[i]);
    }
    
    cout << retorno << endl;
}

int main() {
    int t;
    cin >> t;
 
    while(t--) {
        string s;
        cin >> s;
        fj(s);
    }
}