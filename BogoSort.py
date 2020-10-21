from random import shuffle

def bogosort(seq):
	while not all(x <= y for x, y in zip(seq, seq[1:])):
		shuffle(seq)

	return seq
    