parent = [0] * 200000
size = [0] * 200000
# Inicializa m vertices como sendo a raiz deles mesmos
def init(m):
	for i in range(m):
		parent[i] = i
		size[i] = 1

# Procura quem eh a raiz do componente
def find(v):
	if parent[v] == v:
		return v
	
	parent[v] = find(parent[v])
	return parent[v]

# Junta dois vertices de componentes diferentes em um componente so
def union(u, v):
	a, b = find(u), find(v)
	
	if a != b:
		# Size é usado apenas para otimizacao do algoritmo
		if size[a] < size[b]: 
			a, b = b, a
		
		parent[b] = a
		size[a] += size[b]
