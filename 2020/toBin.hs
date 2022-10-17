toBin :: Int -> String
toBin 0 = ""
toBin x
    | mod x 2 == 1 = toBin (div x 2) ++ "1"
    | otherwise = toBin (div x 2) ++ "0"

main :: IO()
main = do
    inputA <- getLine
    let a = (read inputA :: Int)
    let saida = toBin a
    print saida