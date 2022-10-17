#include <cstdlib>
#include <iostream>
using namespace std;

#include "Pessoa.h"

int main(int argc, char const *argv[]) {
    
    Pessoa p1;
    Pessoa p2;
    p1.setNome("Aaaaa");
    p2.setNome("Bbbbb");

    cout << p1.getNome() << endl;
    cout << p2.getNome() << endl;

    return 0;
}
