#include <bits/stdc++.h>
 
using namespace std;
 
int main() {
    int n, d, max, min;
    cin >> n;
    vector<int> a;
 
    for (int i = 0; i < n; i++) {
        cin >> d;
        a.push_back(d);
    }
 
    for (int i = 0; i < n; i++) {
        if(i == 0) {
            min = a[1] - a[0];
            max = a[n - 1] - a[0];
        } else if(i == (n - 1)) {
            min = a[n - 1] - a[n - 2];
            max = a[n - 1] - a[0];
        } else {
            min = a[i] - a[i - 1];
 
            if(a[i + 1] - a[i] < min) {
                min = a[i + 1] - a[i];
            }
 
            max = a[n - 1] - a[i];
 
            if(a[i] - a[0] > max) {
                max = a[i] - a[0];
            }
        }
        
        cout << min << " " << max << endl;
    }
}