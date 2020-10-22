dobro :: Int -> Int
dobro x = 2 * x

main :: IO()
main = do
    inputA <- getLine
    let a = (read inputA :: Int)
    let saida = dobro a
    print saida