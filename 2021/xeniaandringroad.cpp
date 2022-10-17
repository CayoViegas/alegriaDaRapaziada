#include <bits/stdc++.h>
 
using namespace std;

int main() {
    int n, m;

    cin >> n >> m;

    int l = 1;
    long long retorno = 0;

    for (int i = 0; i < m; i++) {
        int agr;

        cin >> agr;

        if(agr >= l) {
            retorno += agr - l;
        } else {
            retorno += n - (l - agr);
        }

        l = agr;
    }
    
    cout << retorno << endl;
    return 0;
}