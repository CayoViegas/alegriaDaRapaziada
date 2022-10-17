#include <bits/stdc++.h>
#include <iostream>
#include <string>

using namespace std;

int main(int argc, char const *argv[])
{
    int n;

    cin >> n;
    while (n--)
    {
        string password;
        string hash;
        string passwordhash = "";

        cin >> password;
        cin >> hash;

        sort(password.begin(), password.end());
        if (hash.length() >= password.length())
            for (int x = 0; x < (hash.length() - password.length()) + 1; x++)
            {
                for (int i = x; i < password.length() + x; i++)
                {
                    passwordhash += hash[i];
                }

                sort(passwordhash.begin(), passwordhash.end());
                if (passwordhash == password)
                {
                    cout << "YES" << endl;
                    passwordhash = "zzz01";
                    break;
                }
                passwordhash = "";
            }
        if (passwordhash != "zzz01")
            cout << "NO" << endl;
    }

    return 0;
}
