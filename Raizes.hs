raizes :: Double -> Double -> Double -> [Double]
raizes a b c
    | delta > 0 = [(-b + sqrt delta) / 2 * a, (-b - sqrt delta) / 2 * a]
    | delta == 0 = [(-b + sqrt delta) / 2 * a]
    | otherwise = []
    where delta = (b ^ 2) - 4 * a * c

main :: IO()
main = do
    inputA <- getLine
    inputB <- getLine
    inputC <- getLine
    let a = (read inputA :: Double)
    let b = (read inputB :: Double)
    let c = (read inputC :: Double)
    let saida = raizes a b c
    print saida