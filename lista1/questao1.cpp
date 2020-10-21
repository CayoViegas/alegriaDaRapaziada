#include <iostream>

using namespace std;

int main(int argc, char const *argv[])
{
    int x;
    cin >> x;

    for (int a = 1; a <= x; a++)
    {
        for (int b = 1; b <= x; b++)
        {
            if ((a % b == 0) && (a * b > x) && ((a / b) < x))
            {
                cout << a << " " << b << endl;

                exit(0);
            }
        }
    }

    cout << -1 << endl;
}
