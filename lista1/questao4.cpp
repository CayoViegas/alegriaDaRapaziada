#include <iostream>

using namespace std;

int getOperations(int a, int b, int c, int n)
{
    if (a > c || b > c)
    {
        return n;
    }
    else
    {
        return a < b ? getOperations(a + b, b, c, n + 1) : getOperations(a, b + a, c, n + 1);
    }
}

int main(int argc, char const *argv[])
{
    int n;
    cin >> n;
    int a, b, c;
    while (n--)
    {
        cin >> a >> b >> c;
        cout << getOperations(a, b, c, 0) << endl;
    }
}
