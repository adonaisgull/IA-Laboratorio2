#
# graph.rb
# Class Graph
#

require "../lib/node.rb"
require "../lib/node_priority_queue.rb"

class Graph

	attr_reader :nodes_size

	@nodes 			# array con todos los nodos del grafo
	@nodes_size		# numero de nodos del grafo
	@heuristic 		# matriz con la evaluacion heuristica entre cada nodo
	@cost			# matriz con el costo entre nodos

	def initialize(adj_file="../data/adyacencia.txt", cost_file="../data/costos.txt", heur_file ="../data/heuristica.txt")

		@heuristic = []
		@cost = []	
		@nodes = []

		load_nodes(adj_file)
		load_cost(cost_file)
		load_heuristic(heur_file)
	end
	
	def load_nodes(file)

		adjacency = []

		f_in = File.open(file,"r")
		@nodes_size = f_in.gets.to_i	# leemos el numero de nodos y lo guardamos en nodes_size
		f_in.each do |line| 
			adjacency.push line.split
		end

		adjacency.each_index do |i|
			node_adjacency = []
			adjacency[i].each_index do |j|
				if adjacency[i][j] == "1"
					node_adjacency.push(j+1)
				end
			end
			@nodes.push(Node.new(i+1, node_adjacency))	# Creamos un nodo nuevo
		end

		f_in.close
	end

	def load_cost(file)

		f_in = File.open(file,"r")
		f_in.gets		# leemos el numero de nodos y lo descartamos
		f_in.each { |line| @cost.push line.split }		# leemos todas las lineas del fichero y metemos cada una de ellas en el array
		
		@cost.each_index do |i| 
			@cost[i].each_index do |j| 
				@cost[i][j] = @cost[i][j].to_i 
			end
		end		# Convertimos todo el array a enteros

		f_in.close
	end

	def load_heuristic(file)

		f_in = File.open(file,"r")
		
		f_in.gets		# leemos el numero de nodos y lo descartamos
		f_in.each do |line| @heuristic.push line.split end		# leemos todas las lineas del fichero y metemos cada una de ellas en el array
		@heuristic.each_index do |i| 
			@heuristic[i].each_index do |j| 
				@heuristic[i][j] = @heuristic[i][j].to_i
			end
		end		# Convertimos todo el array a enteros

		f_in.close
	end

	def h(from, to)
		return @heuristic[from-1][to-1]
	end

	def cost(from, to)
		return @cost[from-1][to-1]
	end

	def get_node_by_id(node_id)

		@nodes.each do |node|
			return node.clone if node.id == node_id
		end

		return nil
	end

	def deep_first_search(initial_node, final_node)

		generated = 0
		analized = 0
		to_be_analized = []
		results = nil

		if initial_node.id == final_node.id
			puts "El nodo inicial es el nodo final. No se genero un camino"
			return
		end

		to_be_analized.push(initial_node)
		generated+=1

		current_node = to_be_analized.pop

		while current_node != nil && current_node.id != final_node.id

			analized += 1

			current_node.children.reverse.each do |child_id|

				if !current_node.predecessors.include?(child_id)
					
					node = get_node_by_id(child_id)							# obtenemos una copia del nodo
					
					node.predecessors = current_node.predecessors.clone		 	# añadimos al nodo que va a ser generado la lista de predecesores actualizado
					node.predecessors.push(current_node.id)

					node.cumulative_cost = current_node.cumulative_cost + cost(current_node.id, node.id)	# le añadimos al cobjeto su costo acumulado

					to_be_analized.push(node)							 	# añade los hijos que no estan en el camino
					generated += 1
				end
			end
			current_node = to_be_analized.pop	# sacamos el siguiente nodo de la pila
		end

		if current_node != nil	# Falta mejorar la salida. En principio este metodo no mostraria los resultados. IDEA: Devolver un hash con los resultados
			analized += 1
			current_node.predecessors.push(current_node.id)
			
			results = {}
			results[:road] = current_node.predecessors
			results[:cost] = current_node.cumulative_cost
			results[:generated] = generated
			results[:analized] = analized
		end

		results
	end

	def breadth_first_search(initial_node, final_node)

		generated = 0
		analized = 0
		to_be_analized = []
		results = nil

		if initial_node.id == final_node.id
			puts "El nodo inicial es el nodo final. No se genero un camino"
			return
		end

		to_be_analized.push(initial_node)
		generated+=1

		current_node = to_be_analized.shift		# sacamos el nodo con menor f(n) = g(n) + h(n)

		while current_node != nil && current_node.id != final_node.id

			analized += 1

			current_node.children.each do |child_id|
				if !current_node.predecessors.include?(child_id)
					node = get_node_by_id(child_id)							# obtenemos una copia del nodo
					node.predecessors = current_node.predecessors.clone		 	# añadimos al nodo que va a ser generado la lista de predecesores actualizado
					node.predecessors.push(current_node.id)
					node.cumulative_cost = current_node.cumulative_cost + cost(current_node.id, node.id)	# le añadimos al cobjeto su costo acumulado
					to_be_analized.push(node)							 	# añade los hijos que no estan en el camino
					generated += 1
				end
			end
			current_node = to_be_analized.shift		# sacamos el siguiente nodo de la cola fifo
		end

		if current_node != nil	# Falta mejorar la salida. En principio este metodo no mostraria los resultados. IDEA: Devolver un hash con los resultados
			analized += 1
			current_node.predecessors.push(current_node.id)
			
			results = {}
			results[:road] = current_node.predecessors
			results[:cost] = current_node.cumulative_cost
			results[:generated] = generated
			results[:analized] = analized
		end

		results
	end

	def a_star(initial_node, final_node)

		generated = 0
		analized = 0
		to_be_analized = NodePriorityQueue.new
		results = nil

		if initial_node.id == final_node.id
			puts "El nodo inicial es el nodo final. No se genero un camino"
			return
		end

		initial_node.estimated_cost = h(initial_node.id, final_node.id)		# en el primer nodo g=0, no hace falta añadirlo
		to_be_analized.add(initial_node)
		generated+=1

		current_node = to_be_analized.shift

		while current_node != nil && current_node.id != final_node.id
			
			analized += 1
			
			current_node.children.each do |child_id|
				if !current_node.predecessors.include?(child_id)
					node = get_node_by_id(child_id)							# obtenemos una copia del nodo
					node.predecessors = current_node.predecessors.clone		 	# añadimos al nodo que va a ser generado la lista de predecesores actualizado
					node.predecessors.push(current_node.id)
					node.cumulative_cost = current_node.cumulative_cost + cost(current_node.id, node.id)	# le añadimos al cobjeto su costo acumulado
					node.estimated_cost = node.cumulative_cost + h(node.id, final_node.id)
					to_be_analized.add(node)							 	# añade los hijos que no estan en el camino
					generated += 1
				end
			end
			current_node = to_be_analized.shift		# sacamos el siguiente nodo de la cola fifo
		end

		if current_node != nil	# Falta mejorar la salida. En principio este metodo no mostraria los resultados. IDEA: Devolver un hash con los resultados
			analized += 1
			current_node.predecessors.push(current_node.id)
			
			results = {}
			results[:road] = current_node.predecessors
			results[:cost] = current_node.cumulative_cost
			results[:generated] = generated
			results[:analized] = analized
		end

		results
	end
end

if __FILE__ == $0
	grafo = Graph.new
	#controlar el numero de los nodos desde el main. O no...
	grafo.deep_first_search( grafo.get_node_by_id(1), grafo.get_node_by_id(14) )
	grafo.breadth_first_search( grafo.get_node_by_id(1), grafo.get_node_by_id(14) )
	grafo.a_star( grafo.get_node_by_id(1), grafo.get_node_by_id(14) )
end