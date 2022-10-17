*** Variables ***
${SITE}  https://www.saucedemo.com/
${NAVEGADOR}  Chrome 
${USUARIO}  standard_user
${SENHA}  secret_sauce
${CAMPO_USUARIO}  css=#user-name
${CAMPO_SENHA}  css=#password
${BOTAO_LOGIN}  css=#login-button
${BOTAO_ITEM_1}  css=#add-to-cart-sauce-labs-backpack
${BOTAO_ITEM_2}  css=#add-to-cart-sauce-labs-bike-light
${BOTAO_CARRINHO}  css=#shopping_cart_container > a
${ITEM_1}  Sauce Labs Backpack
${ITEM_2}  Sauce Labs Bike Light
${BOTAO_CHECKOUT}  css=#checkout
${CAMPO_NOME}  css=#first-name
${CAMPO_SOBRENOME}  css=#last-name
${CAMPO_CEP}  css=#postal-code
${NOME}  Usuário
${SOBRENOME}  Sobrenome
${CEP}  12345678
${BOTAO_CONTINUAR}  css=#continue
${BOTAO_FINALIZAR}  css=#finish
${MSG_CHKOT}  Item total
${MSG_SUCEDIDA}  THANK YOU FOR YOUR ORDER
${TXT_1}  REMOVE

*** Keywords ***
Abrir Site
  Open Browser  ${SITE}  ${NAVEGADOR}

Wait and Click
  [Arguments]  ${ELEMENTO}
  Wait Until Element is Visible  ${ELEMENTO}
  Wait Until Element is Enabled  ${ELEMENTO}
  Click Element  ${ELEMENTO}

Logar no Saucedemo com usuário padrão
  Input Text  ${CAMPO_USUARIO}  ${USUARIO}
  Input Text  ${CAMPO_SENHA}  ${SENHA}
  Wait and Click  ${BOTAO_LOGIN}

Adicionar 1 item no carrinho
  Wait and Click  ${BOTAO_ITEM_1}

Adicionar 2 itens no carrinho
  Wait and Click  ${BOTAO_ITEM_1}
  Wait and Click  ${BOTAO_ITEM_2}

Ir para Carrinho
  Wait and Click  ${BOTAO_CARRINHO}

Verificar se Carrinho Contem item
  Page Should Contain  ${ITEM_1}

Verificar se Carrinho Contem 2 itens
  Page Should Contain  ${ITEM_1}
  Page Should Contain  ${ITEM_2}

Verificar se Carrinho está Vazio
  Page Should Not Contain  ${TXT_1}  

Ir Para Checkout
  Wait and Click  ${BOTAO_CHECKOUT}

Preencher dados
  Input Text  ${CAMPO_NOME}  ${NOME}
  Input Text  ${CAMPO_SOBRENOME}  ${SOBRENOME}
  Input Text  ${CAMPO_CEP}  ${CEP}

Finalizar Checkout
  Wait and Click  ${BOTAO_CONTINUAR}
  Page Should Contain  ${MSG_CHKOT}
  Wait and Click  ${BOTAO_FINALIZAR}

Finalizar Checkout Nao deve Funcionar
  Run keyword and ignore error  Wait and Click  ${BOTAO_CONTINUAR}
  Run keyword and ignore error  Page Should Not Contain  ${MSG_CHKOT}
  Run keyword and ignore error  Wait and Click  ${BOTAO_FINALIZAR}
  

Verificar Se Checkout foi bem Sucedido
  Page Should Contain  ${MSG_SUCEDIDA}

Verificar Se Checkout falhou
  Page Should Not Contain  ${MSG_SUCEDIDA}