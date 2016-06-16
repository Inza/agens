require 'celluloid/current'

class World
	include Enumerable
	
	def initialize(names)
		@names = names
	end
	
	def [](agent)
		Celluloid::Actor[agent]
	end
	
	def each
		@names.each do |agent|
			yield self[agent]
		end
	end
	
	def dump
		puts 'World contains:'
		
		self.each do |agent|
			puts agent.to_s
		end
	end
end