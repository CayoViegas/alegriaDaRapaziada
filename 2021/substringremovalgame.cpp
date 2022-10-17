#include <bits/stdc++.h>
 
using namespace std;

void srg() {
    string s;
    cin >> s;
    vector<int> a;

    for (int i = 0; i < s.size(); i++) {
        if(s[i] == '1') {
            int j = i;

            while(j + 1 < s.size() && s[j + 1] == '1') {
                ++j;
            }

            a.push_back(j - i + 1);
            i = j;
        }
    }

    sort(a.rbegin(), a.rend());
    int retorno = 0;

    for (int i = 0; i < a.size(); i += 2) {
        retorno += a[i];
    }

    cout << retorno << endl;
}

int main() {
    int t;
    cin >> t;
 
    while(t--) {
        srg();
    }
}