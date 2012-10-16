#
# search.rb
#

require "../lib/graph.rb"
require "../lib/node.rb"
require "../lib/node_priority_queue.rb"

if ARGV.size == 3
	grafo = Graph.new(ARGV.shift, ARGV.shift, ARGV.shift)
else
	grafo = Graph.new()
end

puts "-------------------------------------------------"
puts "Practica 2 - Busquedas informadas y no informadas"
puts "-------------------------------------------------"
puts ""
puts "Se han cargado #{grafo.nodes_size} nodos"
puts ""
print "Introduzca el ID del nodo de origen:  "
origen = gets.to_i
print "Introduzca el ID del nodo de destino: "
destino = gets.to_i

if origen >= 1 && origen <= grafo.nodes_size && destino >= 1 && destino <= grafo.nodes_size
	
	puts ""
	puts "-------------------------------------------------"
	puts "Busqueda primero en profundidad"
	puts "-------------------------------------------------"
	
	resultado = grafo.deep_first_search(grafo.get_node_by_id(origen), grafo.get_node_by_id(destino))

	if resultado
		puts "Existe camino entre el nodo #{origen} y #{destino}."
		puts ""
		puts "Camino:           #{resultado[:road].join('->')}"
		puts "Costo:            #{resultado[:cost]}"
		puts "Nodos generados:  #{resultado[:generated]}"
		puts "Nodos analizados: #{resultado[:analized]}"
	else
		puts "No existe camino entre el nodo #{origen} y #{destino}."

	end
	
	puts ""
	puts "-------------------------------------------------"
	puts "Busqueda primero en amplitud"
	puts "-------------------------------------------------"
	
	resultado = grafo.breadth_first_search(grafo.get_node_by_id(origen), grafo.get_node_by_id(destino))

	if resultado
		puts "Existe camino entre el nodo #{origen} y #{destino}."
		puts ""
		puts "Camino:           #{resultado[:road].join('->')}"
		puts "Costo:            #{resultado[:cost]}"
		puts "Nodos generados:  #{resultado[:generated]}"
		puts "Nodos analizados: #{resultado[:analized]}"
	else
		puts "No existe camino entre el nodo #{origen} y #{destino}."

	end
	
	puts ""
	puts "-------------------------------------------------"
	puts "Busqueda A*"
	puts "-------------------------------------------------"
	
	resultado = grafo.a_star(grafo.get_node_by_id(origen), grafo.get_node_by_id(destino))

	if resultado
		puts "Existe camino entre el nodo #{origen} y #{destino}."
		puts ""
		puts "Camino:           #{resultado[:road].join('->')}"
		puts "Costo:            #{resultado[:cost]}"
		puts "Nodos generados:  #{resultado[:generated]}"
		puts "Nodos analizados: #{resultado[:analized]}"
	else
		puts "No existe camino entre el nodo #{origen} y #{destino}."

	end
	puts ""



else
	puts "ERROR: Los IDs introducidos estan fuera del rango 1..#{grafo.nodes_size}"
end