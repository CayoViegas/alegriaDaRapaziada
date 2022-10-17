#include <iostream>
#include <bits/stdc++.h>
#include <string>

using namespace std;

void broken(string &input)
{
    int c[26] = {0};
    for (int i = 0; i < input.length(); ++i)
    {
        int j = i;

        while (j + 1 < input.length() && input[j + 1] == input[i])
        {
            j++;
        }
        if ((j - i) % 2 == 0)
            c[input[i] - 'a'] = 1;
        i = j;
    }
    for (int i = 0; i < 26; ++i)
    {
        if (c[i] == 1)
        {
            cout << (char)(i + 'a');
        }
    }
    cout << endl;
}

int main(int argc, char const *argv[])
{
    int n;
    string input;

    cin >> n;
    while (n--)
    {
        cin >> input;
        broken(input);
    }

    return 0;
}
