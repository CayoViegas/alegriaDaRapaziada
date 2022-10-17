
import random


def jogar():
    
    mensagem_inicial()
    
    palavra_secreta = geração_palavra()
    letras_acertadas = cria_incognitas(palavra_secreta)
    print(letras_acertadas)
    
    enforcou = False
    acertou = False
    erros = 0
    
    
    while(not enforcou and not acertou):
        
        chute = input_chute()
        
        if(chute in palavra_secreta):
            coloca_acertos(palavra_secreta, chute, letras_acertadas)
 
        else:
            erros += 1
            print("Ops, você errou! Faltam {} tentativas.".format(6-erros))
            desenha_forca(erros)
        enforcou = erros == 7
        
        acertou = "_" not in letras_acertadas
        
        print(letras_acertadas)
        
    if(acertou):
        vitoria()
    else:
        derrota(palavra_secreta)
        

    
def mensagem_inicial():
    print("*********************")
    print("****Jogo da Forca****")
    print("*********************")

def geração_palavra():
    
    arquivo = open("palavras.txt", "r")
    palavras = []
    
    for linha in arquivo:
        linha = linha.strip()
        palavras.append(linha.upper())
    
    arquivo.close()

    palavra_secreta = palavras[random.randrange(0, len(palavras))]
    return palavra_secreta

def cria_incognitas(palavra):
    return ["_" for letra in palavra]
    
def input_chute():
    chute = input("qual letra? ")
    chute = chute.strip().upper()
    return chute

def coloca_acertos(palavra_secreta, chute, letras_acertadas):
    index = 0
    for letra in palavra_secreta:
        if(chute == letra):
            letras_acertadas[index] = letra
        index += 1
        
def vitoria():
    print("\nParabéns, você ganhou!")
    print("       ___________      ")
    print("      '._==_==_=_.'     ")
    print("      .-\\:      /-.    ")
    print("     | (|:.     |) |    ")
    print("      '-|:.     |-'     ")
    print("        \\::.    /      ")
    print("         '::. .'        ")
    print("           ) (          ")
    print("         _.' '._        ")
    print("        '-------'       ")
    
def derrota(palavra_secreta):
    print("\nVocê Perdeu :( ")
    print("A palavra era {}".format(palavra_secreta.lower().capitalize()))
    print("    _______________         ")
    print("   /               \       ")
    print("  /                 \      ")
    print("//                   \/\  ")
    print("\|   XXXX     XXXX   | /   ")
    print(" |   XXXX     XXXX   |/     ")
    print(" |   XXX       XXX   |      ")
    print(" |                   |      ")
    print(" \__      XXX      __/     ")
    print("   |\     XXX     /|       ")
    print("   | |           | |        ")
    print("   | I I I I I I I |        ")
    print("   |  I I I I I I  |        ")
    print("   \_             _/       ")
    print("     \_         _/         ")
    print("       \_______/           ")

def desenha_forca(erros):
    print("  _______     ")
    print(" |/      |    ")

    if(erros == 1):
        print(" |      (_)   ")
        print(" |            ")
        print(" |            ")
        print(" |            ")

    if(erros == 2):
        print(" |      (_)   ")
        print(" |      \     ")
        print(" |            ")
        print(" |            ")

    if(erros == 3):
        print(" |      (_)   ")
        print(" |      \|    ")
        print(" |            ")
        print(" |            ")

    if(erros == 4):
        print(" |      (_)   ")
        print(" |      \|/   ")
        print(" |            ")
        print(" |            ")

    if(erros == 5):
        print(" |      (_)   ")
        print(" |      \|/   ")
        print(" |       |    ")
        print(" |            ")

    if(erros == 6):
        print(" |      (_)   ")
        print(" |      \|/   ")
        print(" |       |    ")
        print(" |      /     ")

    if (erros == 7):
        print(" |      (_)   ")
        print(" |      \|/   ")
        print(" |       |    ")
        print(" |      / \   ")

    print(" |            ")
    print("_|___         ")
    print()



if(__name__ == "__main__"):
    jogar() 
    