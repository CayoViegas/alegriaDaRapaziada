#include <iostream>

using namespace std;

typedef long long ll;

int find(ll a, ll b, ll c)
{
    if (c < a)
    {
        return c;
    }
    else
    {
        return ((b / c) + 1) * c;
    }
}

int main(int argc, char const *argv[])
{
    int n;
    cin >> n;

    ll a, b, c;

    while (n--)
    {
        cin >> a >> b >> c;
        cout << find(a, b, c) << endl;
    }
}
