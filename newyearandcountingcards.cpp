#include <bits/stdc++.h>
 
using namespace std;
 
int x(string s) {
    int retorno = 0;
 
    for (int i = 0; i < s.size(); i++) {
        if((int)s[i] == 49 || (int)s[i] == 51 || (int)s[i] == 53 || (int)s[i] == 55 || (int)s[i] == 57 ||
         (int)s[i] == 97 || (int)s[i] == 101 || (int)s[i] == 105 || (int)s[i] == 111 || (int)s[i] == 117) {
             retorno++;
        }
    }
 
    return retorno;
}
 
int main() {
    string s;
    cin >> s;
    cout << x(s) << endl;
}