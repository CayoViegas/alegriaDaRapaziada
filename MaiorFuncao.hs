f :: Double -> Double -> Double
f x y = ((3 * x) ** 2) + y ** 2

g :: Double -> Double -> Double
g x y = 2 * (x ** 2) + ((5 * y) ** 2)

h :: Double -> Double -> Double
h x y = -100 * x + (y ** 3)

maiorResultado :: Double -> Double -> String
maiorResultado x y
    | (f x y > g x y) && (f x y > h x y) = "Joana ganhou!"
    | g x y > h x y = "Jose ganhou!"
    | otherwise = "Joaquina ganhou!"
    

main :: IO()
main = do
    inputX <- getLine
    inputY <- getLine
    let x = (read inputX :: Double)
    let y = (read inputY :: Double)
    putStr(maiorResultado x y)
