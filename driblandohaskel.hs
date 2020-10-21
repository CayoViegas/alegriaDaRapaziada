main = do

    opt <- getLine

    if(opt == "1")
        then (
            do
            cor<- getLine

            if (cor == "vermelho")
                then( print "vermelho + vermelho" )
            else if (cor == "amarelo")
                then ( print "amarelo + amarelo" )
            else if (cor == "azul")
                then ( print "azul + azul" )
            else if (cor == "laranja")
                then ( print "amarelo + vermelho" )
            else if (cor == "roxo")
                then ( print "vermelho + azul" )
            else if (cor == "verde")
                then ( print "azul + amarelo")
            else print "Entrada inválida!"
            )

    else if(opt == "2") 
        then (
            do
            cor1 <- getLine
            cor2 <- getLine

            if ( cor1 == "vermelho" && cor2 == "vermelho")
                then( print "vermelho" )

            else if (cor1 == "amarelo" && cor2 == "vermelho"  cor1 == "vermelho" && cor2 == "amarelo")
                then ( print "laranja" )

            else if (cor1 == "azul" && cor2 == "vermelho"  cor1 == "vermelho" && cor2 == "azul")
                then (print "roxo")

            else if (cor1 == "azul" && cor2 == "amarelo" || cor1 == "amarelo" && cor2 == "azul")
                then (print "verde")

            else if (cor1 == "amarelo" && cor2 == "amarelo")
                then (print "amarelo")

            else if (cor1 == "azul" && cor2 == "azul")
                then (print "azul")

            else print "Entrada inválida!" 
            )

    else print "Entrada inválida!"
