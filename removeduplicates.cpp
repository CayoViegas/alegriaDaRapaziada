#include <bits/stdc++.h>
 
using namespace std;
 
int main() {
    int n;
    string retorno = "";
    cin >> n;
    vector<int> a;
    vector<int> r;
    set<int> e;

    for (int i = 0; i < n; i++) {
        int d;
        cin >> d;
        a.push_back(d);
    }

    for (int i = n - 1; i >= 0; i--) {
        if(e.count(a[i]) == 0) {
            e.insert(a[i]);
            r.push_back(a[i]);
        }
    }

    cout << r.size() << endl;

    for (int i = int(r.size()) - 1; i >= 0; i--) {
        cout << r[i] << " ";
    }
}