#include <iostream>
#include <bits/stdc++.h>
#include <exception>

using namespace std;

typedef long long ll;

int main(int argc, char const *argv[])
{

    ll n, k;

    cin >> n >> k;

    int *id = new int[n];
    int *sum = new int[n];

    int num = 2;
    sum[0] = 1;
    for (int i = 1; i < n; i++)
    {
        sum[i] = num + sum[i - 1];
        num++;
    }

    for (int i = 0; i < n; i++)
    {
        cin >> id[i];
    }

    for (int i = 0; i < n; i++)
    {
        if (k <= sum[i])
        {
            cout << id[i - (sum[i] - k)];
            break;
        }
    }

    return 0;
}
