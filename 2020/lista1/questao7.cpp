#include <iostream>
#include <string>

using namespace std;

int main(int argc, char const *argv[])
{
    string p;

    cin >> p;

    int count = 0;

    for (int i = 0; i < p.length(); i++)
    {
        if (p[i] == 'a' || p[i] == 'e' || p[i] == 'i' || p[i] == 'o' || p[i] == 'u')
        {
            count++;
        }
        else if ((p[i] - '0') <= 9 && (p[i] - '0') >= 0 && (p[i] - '0') % 2 == 1)
        {
            count++;
        }
    }

    cout << count << endl;

    return 0;
}
