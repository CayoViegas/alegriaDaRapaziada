#include <iostream>
#include <string>

using namespace std;

int main(int argc, char const *argv[])
{
    /* code */

    bool *chars = new bool[28];
    string input;
    int count = 0;

    cin >> input;

    for (int i = 0; i < 28; i++)
    {
        chars[i] = false;
    }

    for (int i = 0; i < input.length(); i++)
    {
        chars[input[i] - 'a'] = true;
    }

    for (int i = 0; i < 28; i++)
    {
        if (chars[i])
            count++;
    }

    if (count % 2 == 1)
    {
        cout << "IGNORE HIM!" << endl;
    }
    else
    {
        cout << "CHAT WITH HER!" << endl;
    }

    return 0;
}
