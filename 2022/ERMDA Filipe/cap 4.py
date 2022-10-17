from turtle import *
import random

def square(tentativas, movimento, direçao):
    bob = Turtle()
    for i in range(tentativas):
        print(bob)
        bob.fd(movimento)
        bob.lt(direçao)

def triangle():
    bob = Turtle()
    bob.speed(2)
    for i in range(100):
        for i in range(3):
            #bob.fd(80)
            bob.fd(180)
            bob.lt(120)
            #bob.lt(120)
        bob.lt(72)
    

def flower():
    bob = Turtle()
    bob.speed(100)
    for i in range(20):
        
        for i in range(10):
            bob.fd(30)
            bob.lt(5)
        bob.lt(130)
        for i in range(10):
            bob.fd(30)
            bob.lt(5)
        bob.lt(100)


def circle(tentativas, raio):
    circunference = 2 * 3.14 * raio
    bob = Turtle()
    for i in range(tentativas):
        print(bob)
        bob.fd(30)
        bob.lt(raio)

def polygon(t, n, length):
    bob = Turtle()
    angle = 360 / n
    for i in range(n):
        t.fd(length)
        t.lt(angle)

triangle()