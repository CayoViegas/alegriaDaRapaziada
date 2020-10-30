#ifndef PESSOA_H
#define PESSOA_H

#include <string>
using namespace std;

class Pessoa {
public:
    void setNome(string novoNome);
    string getNome();
private:
    string nome;
};

#endif