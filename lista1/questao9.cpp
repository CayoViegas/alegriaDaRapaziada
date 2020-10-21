#include <iostream>
#include <queue>

using namespace std;

void resposta(int order[], int res[], queue<int> fila, int n, bool arr[])
{

    for (int i = 0; i < n; i++)
    {
        int count = 0;
        if (!arr[order[i] - 1])
            while (!fila.empty())
            {

                if (fila.front() == order[i])
                {

                    arr[fila.front() - 1] = true;
                    fila.pop();
                    count++;
                    break;
                }
                else
                {

                    arr[fila.front() - 1] = true;

                    fila.pop();
                    count++;
                }
            }
        res[i] = count;
    }
}

int main(int argc, char const *argv[])
{
    int n;
    int iterations = 2;
    cin >> n;

    queue<int> fila;

    int *order = new int[n];
    bool *check = new bool[n];
    int *res = new int[n];

    int x;

    for (int i = 0; i < n; i++)
    {
        cin >> x;
        fila.push(x);
        check[i] = false;
    }

    for (int i = 0; i < n; i++)
    {
        cin >> order[i];
    }

    resposta(order, res, fila, n, check);
    for (int i = 0; i < n; i++)
    {
        cout << res[i] << " ";
    }

    cout << endl;

    return 0;
}
