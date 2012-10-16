#
# node.rb
# Class Noder
#

class Node

	attr_reader :id, :children
	attr_accessor :predecessors, :cumulative_cost, :estimated_cost

	@id
	@label
	@children			# array de ids de los hijos del nodo
	@predecessors		# lista de ids de los predecesores de cada nodo generado
	@cumulative_cost	# variable que almacena el costo acumulado cuando se genera el nodo
	@estimated_cost		# costo estimado que resulta de la suma del costo acumulado + el costo estimado de h()


	def initialize(id, children, predecessors=Array.new)
		@id = id
		@children = children
		@predecessors = predecessors
		@cumulative_cost = 0
		@estimated_cost = 0
	end
end

#unnodo = Node.new(1, [1, 2, 3])
#copia = unnodo.copy
#unnodo.set_father 0
#copia.set_father 3

#puts unnodo.father
#puts copia.father