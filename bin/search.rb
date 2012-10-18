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

	
puts ""
puts "-------------------------------------------------"
puts "Busqueda primero en profundidad"
puts "-------------------------------------------------"

resultado = grafo.deep_first_search(origen, destino)

if resultado
	puts "Existe camino entre el nodo #{origen} y #{destino}."
	puts ""
	puts "Camino:           #{resultado[:road].join('->')}"
	puts "Costo:            #{resultado[:cost]}"
	puts "Nodos generados:  #{resultado[:generated]}"
	puts "Nodos analizados: #{resultado[:analized]}"
else
	puts "No existe camino entre el nodo #{origen} y #{destino}. Compruebe los IDs introducidos. Deben estar en el rango 1..#{grafo.nodes_size}"
end
	
puts ""
puts "-------------------------------------------------"
puts "Busqueda primero en amplitud"
puts "-------------------------------------------------"

resultado = grafo.breadth_first_search(origen, destino)

if resultado
	puts "Existe camino entre el nodo #{origen} y #{destino}."
	puts ""
	puts "Camino:           #{resultado[:road].join('->')}"
	puts "Costo:            #{resultado[:cost]}"
	puts "Nodos generados:  #{resultado[:generated]}"
	puts "Nodos analizados: #{resultado[:analized]}"
else
	puts "No existe camino entre el nodo #{origen} y #{destino}. Compruebe los IDs introducidos. Deben estar en el rango 1..#{grafo.nodes_size}"
end
	
puts ""
puts "-------------------------------------------------"
puts "Busqueda A*"
puts "-------------------------------------------------"
	
resultado = grafo.a_star(origen, destino)

if resultado
	puts "Existe camino entre el nodo #{origen} y #{destino}."
	puts ""
	puts "Camino:           #{resultado[:road].join('->')}"
	puts "Costo:            #{resultado[:cost]}"
	puts "Nodos generados:  #{resultado[:generated]}"
	puts "Nodos analizados: #{resultado[:analized]}"
else
	puts "No existe camino entre el nodo #{origen} y #{destino}. Compruebe los IDs introducidos. Deben estar en el rango 1..#{grafo.nodes_size}"
end

puts ""
