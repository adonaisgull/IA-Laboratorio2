#
# node.rb
# Class Noder
#

class Node 

	@id
	@label
	@children	# array de objetos de clase Node
	@father		# objeto de clase Node que representa al padre que lo generó

	def initialize(id, children, father=nil)
		@children = children
		@id = id
		@father = father
	end

	def show
		puts "ID: #{@id}"
		print "HIJOS: #{@children} \n"
		puts "FATHER ID: #{@father.id}"
	end

	def id
		return @id
	end

	def children
		return @children
	end

	def father
		return @father
	end

	def set_father(father)
		@father = father
	end

	def copy
		return Node.new(@id, @children, @father)
	end

	def self.is_in?(nodes_array, node_id)
		nodes_array.each do |node|
			return true if node.id == node_id
		end

		return false
	end
end

#unnodo = Node.new(1, [1, 2, 3])
#copia = unnodo.copy
#unnodo.set_father 0
#copia.set_father 3

#puts unnodo.father
#puts copia.father