coresUmaEntrada :: String -> String
coresUmaEntrada x
    | x == "vermelho" = "vermelho"
    | x == "amarelo" = "amarelo"
    | x == "azul" = "azul"
    | x == "laranja" = "amarelo + vermelho"
    | x == "roxo" = "vermelho + azul"
    | x == "verde" = "azul + amarelo"
    | otherwise = "Entrada inválida!"
    
coresDuasEntradas :: String -> String -> String
coresDuasEntradas x y
    | (x == "amarelo" && y == "amarelo") = "amarelo"
    | (x == "azul" && y == "azul") = "azul"
    | (x == "vermelho" && y == "vermelho") = "vermelho"
    | (x == "amarelo" && y == "vermelho") || (x == "vermelho" && y == "amarelo") = "laranja"
    | (x == "vermelho" && y == "azul") || (x == "azul" && y == "vermelho") = "roxo"
    | (x == "azul" && y == "amarelo") || (x == "amarelo" && y == "azul") = "verde"
    | otherwise = "Entrada inválida!"
    
main :: IO()
main = do
    qtdEntradas <- getLine
    if (read qtdEntradas) == 1
        then do x <- getLine
                let saida = coresUmaEntrada x
                putStr saida
    else if (read qtdEntradas) == 2
        then do x <- getLine
                y <- getLine
                let saida = coresDuasEntradas x y
                putStr saida
    else
        putStr "Entrada inválida!"