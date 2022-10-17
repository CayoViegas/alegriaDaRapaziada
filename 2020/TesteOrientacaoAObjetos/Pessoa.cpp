#include "Pessoa.h"

#include <string>
using namespace std;

void Pessoa::setNome(string novoNome) {
    this->nome = novoNome;
}

string Pessoa::getNome() {
    return this->nome;
}