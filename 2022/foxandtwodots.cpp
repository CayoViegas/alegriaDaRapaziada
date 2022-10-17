#include <bits/stdc++.h>
 
using namespace std;

const int mm = 51;
bool vis[mm][mm];
char g[mm][mm];
int dx[] = {1, -1, 0, 0};
int dy[] = {0, 0, 1, -1};
int m, n;
bool ok = false;

void dfs(int i, int j, int frmi, int frmj, char co) {
    if(i < 1 || j < 1 || i > m || j > n) {
        return;
    }

    if(g[i][j] != co) {
        return;
    }

    if(vis[i][j]) {
        ok = true;
        return;
    }

    vis[i][j] = true;

    for (int y = 0; y < 4; y++) {
        int nxti = i + dx[y];
        int nxtj = j + dy[y];

        if(nxti == frmi && nxtj == frmj) {
            continue;
        }

        dfs(nxti, nxtj, i, j, co);
    }
}

int main() {
    cin.tie(NULL);
    cout.tie(NULL);
    memset(vis, false, sizeof(vis));
    int x, y, u, v;
    char c;

    cin>> m >> n;

    for(int i = 1; i <= m; i++) {
        for(int j = 1; j <= n; j++) {
            cin >> g[i][j];
        }
    }

    for(int i = 1; i <= m; i++) {
        for(int j = 1; j <= n; j++) {
            char z = g[i][j];

            if(!vis[i][j]) {
                dfs(i, j, -1, -1, z);

                if(ok) {
                    cout << "Yes" << endl;
                    return 0;
                }
            }
        }
    }

    cout << "No" << endl;
}