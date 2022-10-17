#include <iostream>

using namespace std;

int isPrime(int number)
{
    if (number < 2)
        return 0;
    else if (number % 2 == 0)
        return 0;
    else
    {
        for (int i = 3; i * i <= number; i += 2)
        {
            if ((number % i) == 0)
                return 0;
        }
    }

    return 1;
}

int getCounterexample(int n, int m)
{
    if (!isPrime(n * m + 1))
        return m;
    else
        return getCounterexample(n, m + 1);
}

int main(int argc, char const *argv[])
{

    int prime;
    cin >> prime;
    int result;

    result = (prime % 2 == 1 && prime > 1) ? 1 : getCounterexample(prime, 2);
    cout << result << endl;
}
