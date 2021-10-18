def resto():
  retorno = ""
  
  num_1 = float(input("primeiro número: "))
  num_2 = float(input("segundo número: "))
  print()

  if num_2 == 0:
    retorno = "dx de ser pilantra"
    return retorno

  divisao = num_1 / num_2
  resto = num_1 % num_2

  retorno = "O número {} dividido por {} é igual a: {}" .format(num_1,num_2, divisao)

  if resto == 0:
    retorno += "\na divisão é exata, poiso resto é zero"
  else:
    retorno += "\no resto da divisão é: %f" %resto

  return retorno

print(resto())