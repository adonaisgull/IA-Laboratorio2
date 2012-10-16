#
# node.rb
# Class Noder
#

class Node

	attr_reader :id, :children
	attr_accessor :predecessors, :cumulative_cost

	@id
	@label
	@children			# array de ids de los hijos del nodo
	@predecessors		# lista de ids de los predecesores de cada nodo generado
	@cumulative_cost	# variable que almacena el costo acumulado cuando se genera el nodo


	def initialize(id, children, predecessors=Array.new)
		@id = id
		@children = children
		@predecessors = predecessors
		@cumulative_cost = 0
	end
end

#unnodo = Node.new(1, [1, 2, 3])
#copia = unnodo.copy
#unnodo.set_father 0
#copia.set_father 3

#puts unnodo.father
#puts copia.father