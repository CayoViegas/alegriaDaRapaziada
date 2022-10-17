#include <bits/stdc++.h>

using namespace std;

bool dfs(int n, int color, int other, bool *visited, vector<pair<int, int>> *arr)
{
    visited[n] = true;
    if (n == other)
        return true;

    for (int x = 0; x < arr[n].size(); x++)
    {
        if (!visited[arr[n][x].first] && arr[n][x].second == color)
        {
            if (dfs(arr[n][x].first, color, other, visited, arr))
                return true;
        }
    }
    return false;
}

int main(int argc, char const *argv[])
{

    int n, m;

    cin >> n >> m;
    bool visited[120];
    vector<pair<int, int>> arr[120];
    int a, b, c;
    // printf("%d m \n", m);
    for (int i = 1; i <= m; i++)
    {
        cin >> a >> b >> c;
        arr[a].push_back(make_pair(b, c));
        arr[b].push_back(make_pair(a, c));
    }

    int q;
    cin >> q;
    for (int i = 0; i < q; i++)
    {
        int res = 0;
        int p, s;
        cin >> p >> s;
        for (int x = 0; x < 120; x++)
        {
            memset(visited, 0, sizeof(visited));
            if (dfs(p, x, s, visited, arr))
                res++;
        }

        printf("%d\n", res);
    }

    return 0;
}
