{-# LANGUAGE FlexibleContexts #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use newtype instead of data" #-}

import Control.Arrow (ArrowChoice (right))
import Data.Binary.Get (isEmpty)
import Distribution.Simple.Utils (xargs)
import GHC.Exts.Heap (GenClosure (key))

xor True False = True
xor False True = True
xor _ _ = False

impl a b = not (a || b)

equiv a b = impl a b && impl b a

square x = x * x

pow x 0 = 1
pow x y
  | y < 0 = x * pow x (y -1)
  | otherwise = 1 / pow x (- y)

fatorial 0 = 1
fatorial x = x * fatorial (x -1)

removeNonUpper st = [c | c <- st, c `elem` ['A' .. 'Z']]

triangles = [(a, b, c) | a <- [1 .. 10], b <- [1 .. 10], c <- [1 .. 10], square a + square b == square c]

myLength xs = sum [1 | x <- xs]

elemen _ [] = False
elemen k (x : xs)
  | k == x = True
  | otherwise = elemen k xs

myNub [] = []
myNub [a] = [a]
myNub (x : xs)
  | elemen x xs = myNub xs
  | otherwise = x : myNub xs

penultimo xs = last (init xs)

elementAt _ [] = error "Elemento não encontrado"
elementAt 0 xs = head xs
elementAt i (x : xs) = elementAt (i -1) xs

isPalindrome [] = True
isPalindrome [a] = True
isPalindrome (x : xs)
  | x == last xs = isPalindrome (init xs)
  | otherwise = False

compress [] = []
compress [a] = [a]
compress (x : xs)
  | x `elemen` xs = compress xs
  | otherwise = x : compress xs

fib 1 = [1]
fib 2 = [1, 1]
fib n = previous ++ [last (init previous) + last previous]
  where
    previous = fib (n -1)

repeatK _ [] = []
repeatK 1 xs = xs
repeatK k (x : xs)
  | length (filter (== x) xs) >= k -1 = x : repeatK k (filter (/= x) xs)
  | otherwise = repeatK k xs

repl _ 0 = []
repl n 1 = [n]
repl n x = n : repl n (x -1)

data BST a = NIL | Node a (BST a) (BST a) deriving (Eq, Show, Ord)

nodesAtLevel _ NIL = []
nodesAtLevel 0 (Node a left right) = [a]
nodesAtLevel level (Node a left right) = nodesAtLevel (level - 1) left ++ nodesAtLevel (level - 1) right

deep _ NIL = -1
deep ele (Node a left right)
  | ele == a = 0
  | ele > a && deep ele right /= -1 = 1 + deep ele right
  | ele < a && deep ele left /= -1 = 1 + deep ele left
  | otherwise = -1

leaves NIL = []
leaves (Node a NIL NIL) = [a]
leaves (Node a left right) = leaves left ++ leaves right

mirror NIL = NIL
mirror (Node a NIL right) = Node a right NIL
mirror (Node a left NIL) = Node a NIL left
mirror (Node a left right) = Node a right left

mapTree _ NIL = NIL
mapTree f (Node a left right) = f a (mapTree f left) (mapTree f right)

sizeBST NIL = 0
sizeBST (Node a left right) = 1 + sizeBST left + sizeBST right

myInsert x NIL = Node x NIL NIL
myInsert x (Node a left right)
  | x == a = Node x left right
  | x > a = Node a left (myInsert x right)
  | x < a = Node a (myInsert x left) right

mySearch x NIL = Node x NIL NIL
mySearch x (Node a left right)
  | x > a = mySearch x right
  | x < a = mySearch x left
  | otherwise = Node x left right

myMax NIL = error "BST vazia"
myMax (Node a _ NIL) = a
myMax (Node a left right) = myMax right

myMin NIL = error "BST vazia"
myMin (Node a NIL _) = a
myMin (Node a left right) = myMin left

inOrder NIL = []
inOrder (Node a left right) = inOrder left ++ [a] ++ inOrder right

preOrder NIL = []
preOrder (Node a left right) = [a] ++ preOrder left ++ preOrder right

postOrder NIL = []
postOrder (Node a left right) = postOrder left ++ postOrder right ++ [a]

-- FUNÇOES DE TESTE DE ARVORES: --
singleton :: a -> BST a
singleton x = Node x NIL NIL

treeInsert x NIL = singleton x
treeInsert x (Node a left right)
  | x == a = Node x left right
  | x < a = Node a (treeInsert x left) right
  | x > a = Node a left (treeInsert x right)

treeElem :: (Ord a) => a -> BST a -> Bool
treeElem x NIL = False
treeElem x (Node a left right)
  | x == a = True
  | x < a = treeElem x left
  | x > a = treeElem x right

nums = [8, 6, 4, 1, 7, 3, 5]

numsTree = foldr treeInsert NIL nums

-- FIM DAS FUNÇÕES DE TESTE DE BSTS

data Quadruple a b = QVazio | Quadruple a a b b deriving (Eq, Show)

firstTwo QVazio = error "Erro"
firstTwo (Quadruple a1 a2 _ _) = (a1, a2)

secondTwo QVazio = error "Erro"
secondTwo (Quadruple _ _ b1 b2) = (b1, b2)

data Tuple a b c d = TVazio | Tuple1 a | Tuple2 a b | Tuple3 a b c | Tuple4 a b c d deriving (Eq, Show)

tuple1 TVazio = Nothing
tuple1 (Tuple1 a) = Just a
tuple1 (Tuple2 a _) = Just a
tuple1 (Tuple3 a _ _) = Just a
tuple1 (Tuple4 a _ _ _) = Just a

data List a = Nil | Cons a (List a) deriving (Eq, Show)

myList = Cons 1 (Cons 2 Nil)

listLength Nil = 0
listLength (Cons x xs) = 1 + listLength xs

listHead Nil = error "Lista Vazia"
listHead (Cons x xs) = x

listTail Nil = error "Lista Vazia"
listTail (Cons x xs) = xs

listFoldr f v Nil = v
listFoldr f v (Cons x xs) = f x (listFoldr f v xs)

-- Lista-funcoes
palim [] = True
palim [x] = True
palim (x : xs)
  | x == last xs = palim (init xs)
  | otherwise = False

compr [] = []
compr (x : xs)
  | x `elem` xs = compr xs
  | otherwise = x : compr xs

elementAtt _ [] = error "Lista vazia"
elementAtt 0 xs = head xs
elementAtt i (x : xs) = elementAtt (i -1) xs

compact [] = []
compact (x : xs) = filter (== x) (x : xs) ++ compact (filter (/= x) xs)

encode [] = []
encode (x : xs) = (x, length (filter (== x) (x : xs))) : encode (filter (/= x) xs)

split [] _ = []
split xs i = take i xs : [drop i xs]

insertAt _ _ [] = error "A lista não cabe"
insertAt el 1 xs = el : xs
insertAt el pos (x : xs) = x : insertAt el (pos - 1) xs

myAppend xs ys = foldr (:) ys xs

unique [] = []
unique (x : xs) = x : unique (filter (/= x) xs)

quickSort [] = []
quickSort (x : xs) = quickSort smallerNumbers ++ [x] ++ quickSort biggerNumbers
  where
    smallerNumbers = filter (<= x) xs
    biggerNumbers = filter (> x) xs

quickSorte [] = []
quickSorte (x : xs) = (quickSorte [y | y <- xs, y <= x]) ++ [x] ++ quickSorte [z | z <- xs, z > x]

divisors x = [y | y <- [1 .. x], y `mod` x == 0]

primes x = [y | length (divisors x) == 1, y <- [2 .. x]]

-- gd :: Integer -> [Integer]
-- gd n = [y | y <- filter (\x -> n - x) (primes n), y `elem` (primes n)]

top [x] = x
top (x : xs) = top xs

pop [] = error "Empty Pile"
pop (x : xs)
  | isThisEmpty (x : xs) = error "EmptyFile"
  | x == top (x : xs) = xs
  | otherwise = x : pop xs

isThisEmpty [] = True
isThisEmpty _ = False