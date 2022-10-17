def jogar():
    
    print("*******************")
    print("Jogo de Adivinhação")
    print("*******************")
    
    import random
    
    numero_secreto = random.randrange(1,101)
    total_tentativas = 0
    rodada = 1
    pontos = 1000
    
    
    print("Qual a dificuldade?")
    print('(1) Fácil (2) Médio (3) Difícil')
    
    
    nivel = int(input ("escolha a dificuldade: "))
    
    if(nivel == 1):
        total_tentativas = 20
    elif(nivel == 2):
        total_tentativas = 10
    else:
        total_tentativas = 5
    
    
    
    for rodada in range (1, total_tentativas + 1):
        
        
        print("tentativa {} de {}". format(rodada, total_tentativas))
        chute = int(input("Digite um número entre 1 e 100: "))
    
        
    
        if(chute < 1 or chute > 100):
            print("Número Inválido")
            continue
    
        acertou = numero_secreto == chute
        maior = chute > numero_secreto
        menor = chute < numero_secreto
    
    
        if(acertou):
            print("***você acertou***", "total de pontos: ", pontos)
            break
        else:
            if(maior):
                print("Muito alto, chute mais baixo")
            elif(menor):
                print("muito baixo, chute mais alto")
            pontos_perdidos = abs(numero_secreto - chute)
            pontos = pontos - pontos_perdidos
            
        
            
    print("Fim de Jogo") 
    
if(__name__ == "__main__"):
    jogar() 