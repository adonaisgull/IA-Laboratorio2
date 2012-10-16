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
					node_adjacency.push(j+1)
				end
			end

			@nodes.push(Node.new(i+1, node_adjacency))	# Creamos un nodo nuevo
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

		if initial_node.id == final_node.id
			puts "El nodo inicial es el nodo final. No se genero un camino"
			return
		end

		#initial_node.predecessors.push(initial_node.id) 	# añadimos el id de su padre a la lista, que en este caso será el mismo nodo
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

			current_node.predecessors.push(current_node.id)
			puts "Se encontro el camino entre #{initial_node.id} y #{final_node.id}"
			puts current_node.predecessors.join("->")
			puts "Nodos analizados: #{analized}"
			puts "Nodos generados:  #{generated}"
			puts "Costo acumulado:  #{current_node.cumulative_cost}"
		else
			puts "No se encontro camino desde #{initial_node.id} a #{final_node.id}."
		end
	end

	def breadth_first_search(initial_node, final_node)

		generated = 0
		analized = 0
		to_be_analized = []

		if initial_node.id == final_node.id
			puts "El nodo inicial es el nodo final. No se genero un camino"
			return
		end

		to_be_analized.push(initial_node)
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

					to_be_analized.push(node)							 	# añade los hijos que no estan en el camino
					generated += 1
				end
			end
			current_node = to_be_analized.shift		# sacamos el siguiente nodo de la cola fifo
		end

		if current_node != nil	# Falta mejorar la salida. En principio este metodo no mostraria los resultados. IDEA: Devolver un hash con los resultados

			current_node.predecessors.push(current_node.id)
			puts "Se encontro el camino entre #{initial_node.id} y #{final_node.id}"
			puts current_node.predecessors.join("->")
			puts "Nodos analizados: #{analized}"
			puts "Nodos generados:  #{generated}"
			puts "Costo acumulado:  #{current_node.cumulative_cost}"
		else
			puts "No se encontro camino desde #{initial_node.id} a #{final_node.id}."
		end
	end

	def a_star
	end
end

grafo = Graph.new

#controlar el numero de los nodos desde el main. O no...
grafo.deep_first_search( grafo.get_node_by_id(1), grafo.get_node_by_id(14) )
grafo.breadth_first_search( grafo.get_node_by_id(1), grafo.get_node_by_id(14) )