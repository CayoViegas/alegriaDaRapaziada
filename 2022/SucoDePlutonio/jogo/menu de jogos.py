# -*- coding: utf-8 -*-
"""
Created on Thu Dec 16 21:34:59 2021

@author: Rodrigo
"""

import forca
import random_number


def mensagem_ini():
    
    print("********************************")
    print("*****Selecione o seu Jogo: *****")
    print("********************************")
    print(" ")
    print("(1) Número Aleatório")
    print(" ")
    print("(2) Forca")
    print(" ")

encerrar = False
while(encerrar == False):
    
    mensagem_ini()    

    jogo = int(input("Escolha 1 ou 2: "))

    if(jogo == 1):
        random_number.jogar()

    elif(jogo == 2):
        forca.jogar()
    
    encerrar_pergunta = input("Encerrar? (S) (N):")
    if(encerrar_pergunta == "N"):
            encerrar = False
            
            
            