#include <bits/stdc++.h>
 
using namespace std;

bool vis[2001];
vector<int> v[2001];
int c = 1;
int d[2001];

void dfs(int x, int d) {
    c = max(c, d);

    for (int i = 0; i < v[x].size(); i++) {
        dfs(v[x][i], d + 1);
    }
}

int main() {
    int t;
    memset(vis, false, sizeof vis);

    for (int i = 0; i < 2000; i++) {
        d[i] = 1;
    }
    
    cin >> t;

    for (int i = 0; i < 2001; i++) {
        v[i].clear();
    }
    
    for (int i = 1; i <= t; i++) {
        int x;

        cin >> x;

        if(x == -1) {
            continue;
        }

        v[x].push_back(i);
    }
    
    for (int i = 1; i <= t; i++) {
        dfs(i, 1);
    }
    
    cout << c << endl;
}