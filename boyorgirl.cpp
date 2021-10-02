#include <bits/stdc++.h>
 
using namespace std;
 
string x(string a) {
    string retorno = "IGNORE HIM!";
    int x = 0;
    int arr [26] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
 
    for (int i = 0; i < a.length(); i++) {
        arr[(int)a[i] - 97]++;
    }
 
    for (int i = 0; i < 26; i++) {
        if(arr[i] != 0) {
            x++;
        }
    }
    
    if(x % 2 == 0){
        retorno = "CHAT WITH HER!";
    }
    
    return retorno;
}
 
int main() {
    string a;
    cin >> a;
    cout << x(a) << endl;
}