def resto():
  retorno = ""
  
  num_1 = float(input("primeiro n�mero: "))
  num_2 = float(input("segundo n�mero: "))
  print()

  if num_2 == 0:
    retorno = "dx de ser pilantra"
    return retorno

  divisao = num_1 / num_2
  resto = num_1 % num_2

  retorno = "O n�mero {} dividido por {} � igual a: {}" .format(num_1,num_2, divisao)

  if resto == 0:
    retorno += "\na divis�o � exata, poiso resto � zero"
  else:
    retorno += "\no resto da divis�o �: %f" %resto

  return retorno

print(resto())