import System.Random

desgraca :: Integer -> IO Integer
desgraca n = randomRIO (0, n) 

main = do
	l <- getLine
	let li = (read l:: Integer)
	k <- desgraca li
	print k