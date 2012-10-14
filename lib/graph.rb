#
# graph.rb
# Class Graph
#

require "./node.rb"

class Graph

	@nodes 			# array con todos los nodos del grafo
	@nodes_size		# numero de nodos del grafo
	@heuristic 		# matriz con la evaluacion heuristica entre cada nodo
	@cost			# matriz con el costo entre nodos

	def initialize()

		@heuristic = []
		@cost = []	
		@nodes = []

		load_nodes
		load_cost
		load_heuristic
	end
	
	def load_nodes

		adjacency = []

		f_in = File.open("../data/matriz_adyacencia.txt","r")
		@nodes_size = f_in.gets.to_i	# leemos el numero de nodos y lo guardamos en nodes_size
		f_in.each do |line| 
			adjacency.push line.split
		end

		adjacency.each_index do |i|
			node_adjacency = []
			adjacency[i].each_index do |j|
				if adjacency[i][j] == "1"
					node_adjacency.push(j)
				end
			end

			@nodes.push(Node.new(i, node_adjacency))	# Creamos un nodo nuevo
		end

		f_in.close
	end

	def load_cost

		f_in = File.open("../data/matriz_costos.txt","r")
		
		f_in.gets		# leemos el numero de nodos y lo descartamos
		f_in.each { |line| @cost.push line.split }		# leemos todas las lineas del fichero y metemos cada una de ellas en el array
		
		@cost.each_index do |i| 
			@cost[i].each_index do |j| 
				@cost[i][j] = @cost[i][j].to_i 
			end
		end		# Convertimos todo el array a enteros

		f_in.close

	end

	def load_heuristic

		f_in = File.open("../data/matriz_evaluacion_heuristica.txt","r")
		
		f_in.gets		# leemos el numero de nodos y lo descartamos
		f_in.each do |line| @heuristic.push line.split end		# leemos todas las lineas del fichero y metemos cada una de ellas en el array
		@heuristic.each_index do |i| 
			@heuristic[i].each_index do |j| 
				@heuristic[i][j] = @heuristic[i][j].to_i
			end
		end		# Convertimos todo el array a enteros

		f_in.close
	end

	def nodes
		@nodes.each do |node|
			node.mostrar
		end
	end

	def h(from, to)
		return @heuristic[from][to]
	end

	def cost(from, to)
		return @cost[from][to]
	end

	def get_node_by_id(node_id)

		@nodes.each do |node|
			return node.copy if node.id == node_id
		end

		return nil
	end

	def deep_first_search(initial_node, final_node)
		
		analized = []
		to_be_analized = []

		to_be_analized.push(initial_node)		# añadimos el primero nodo a analizar, que será el inicial u origen

		dfs(final_node,	analized, to_be_analized)		# llamamos al metodo recursivo que buscará el camino

	end

	def dfs(final_node,	analized, to_be_analized)

		current_node = to_be_analized.pop	# sacamos el nodo que toca analizar

		if current_node == nil
			puts "No se encontro el camino"
			return
		end

		analized.push(current_node)

		if current_node.id == final_node.id
			puts "Se encontro el camino"

			camino = []
			node = current_node
			coste = 0

			camino.push(node.id+1)

			while node.father != nil
				coste += cost(node.father.id, node.id)
				node = node.father
				camino.push(node.id+1)
			end

			puts camino.reverse
			puts "Coste: #{coste}"

			return 		# se encontró nodo final
		end

		current_node.children.reverse.each do |child_id|
			if !Node.is_in?(analized, child_id)
				node = get_node_by_id(child_id)		# obtenemos una copia del nodo
				node.set_father(current_node)
				to_be_analized.push(node)	# añade los hijos que no han sido analizados
			end
		end

		dfs(final_node, analized, to_be_analized)

	end

	def bfs
	end

	def a_star
	end

end


grafo = Graph.new

grafo.deep_first_search( grafo.get_node_by_id(0), grafo.get_node_by_id(13) )