*** Settings ***
Library  SeleniumLibrary
Resource  teste.resource
Test Setup  Abrir Site
Test Teardown  Close Browser

*** Test Cases ***

Logar e Comprar 1 item
  Logar no Saucedemo com usuário padrão
  Adicionar 1 item no carrinho
  Ir para Carrinho
  Verificar se Carrinho Contem item
  Ir Para Checkout
  Preencher dados
  Finalizar Checkout
  Verificar Se Checkout foi bem Sucedido

Logar e Comprar 2 itens
  Logar no Saucedemo com usuário padrão
  Adicionar 2 itens no carrinho
  Ir para Carrinho
  Verificar se Carrinho Contem 2 itens
  Ir Para Checkout
  Preencher dados
  Finalizar Checkout
  Verificar Se Checkout foi bem Sucedido

Logar e Tentar Fazer Checkout sem item
  Logar no Saucedemo com usuário padrão
  Verificar se Carrinho está Vazio
  Ir para Carrinho
  Ir Para Checkout
  Preencher dados
  Finalizar Checkout Nao deve Funcionar
  Verificar Se Checkout falhou
