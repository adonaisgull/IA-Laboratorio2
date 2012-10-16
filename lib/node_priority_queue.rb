#
# node_priority_queue.rb
# Class NodePriorityQueue

require ("../lib/node.rb")

class NodePriorityQueue

	attr_accessor :queue

	@queue

	def initialize()
		@queue = []
	end

	def add(node)

		target_position = nil

		if @queue.size == 0
		 	@queue.push(node)
		else
			@queue.each_index do |i|
				if node.estimated_cost <= @queue[i].estimated_cost		# Quiza añadir que se ordene por ID despues de por costo acumulado
					target_position = i
					break
				end
			end

			if target_position
				@queue.insert(target_position, node)
			else
				@queue.push(node) # Añadimos el nodo por el final si no se añadio en el bucle anterior
			end
		end
	end

	def shift
		@queue.shift
	end
end

if __FILE__ == $0

	nodo1 = Node.new(1, [])
	nodo1.estimated_cost = 100

	nodo2 = Node.new(2, [])
	nodo2.estimated_cost = 200
	
	nodo3 = Node.new(3, [])
	nodo3.estimated_cost = 300

	queue = NodePriorityQueue.new

	puts "Insertando"
	queue.add(nodo2)
	queue.add(nodo3)
	queue.add(nodo1)

	queue.queue.each do |node|
		puts "ID: #{node.id}"
	end

	puts "Sacando"
	queue.shift

	queue.queue.each do |node|
		puts "ID: #{node.id}"
	end
end