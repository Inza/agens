require 'celluloid/current'
require 'celluloid/supervision'

class AgentConfigRecipe
	attr_reader :type, :name, :args
	
	def initialize(type, name, args = [])
		@type = type
		@name = name
		@args = args
	end
end

class MAS
	@@counters = {}
	@@recipes = []
	
	def initialize
		@config = Celluloid::Supervision::Configuration.new
		@names = []
		
		@@recipes.each do |agent_recipe|
			if !agent_recipe.args.nil? && agent_recipe.args.any?
				@config.define(type: agent_recipe.type, as: agent_recipe.name, args: agent_recipe.args)
			else
				@config.define(type: agent_recipe.type, as: agent_recipe.name)
			end
			
			@names << agent_recipe.name
		end
	end
	
	def run
		puts "Running MAS #{self.class.name}..."
		@config.deploy
	end
	
	def shutdown
		puts "Stoping MAS #{self.class.name}..."
		@config.shutdown
	end
	
	def world
		World.new(@names)
	end
	
	def add_agent(agent, options = {})
		recipe << self.generate_recipe(agent, options)
		
		if !recipe.args.nil? && recipe.args.any?
			@config.add(type: recipe.type, as: recipe.name, args: recipe.args)
		else
			@config.add(type: recipe.type, as: recipe.name)
		end
		
		self
	end
	
	#region DSL
	# agent MyAgent
	# agent MyAgent, as: :james_bond
	# agent MyAgent, as: :james_bond, args: [1, 2]
	def self.agent(agent, options = {})
		@@recipes << self.generate_recipe(agent, options)
	end
	
	# agents MyAgent
	# agents MyAgent, as: :james_bonds
	# agents MyAgent, count: 10
	# agents MyAgent, as: :james_bonds, count: 10
	# agents MyAgent, as: :james_bonds, count: 10, args: [1, 2]
	def self.agents(agent, options = {})
		mas_name = self.name.to_sym
		pool_name = "#{agent.class.name.to_sym}_pool"
		@@counters[pool_name] ||= 0
		@@counters[pool_name] += 1
		
		name = options.key?(:as) ? options[:as] : "#{mas_name}_#{pool_name}_#{@@counters[pool_name]}"
		count = options.key?(:count) ? options[:count] : nil
		
		count = 2 if count == nil
		
		count.times do
			self.agent(agent, args: options[:args])
		end
		
		# TODO add support for new celluloid supervision pools (when they will be documented, see https://github.com/celluloid/celluloid-supervision)
		# if count == nil
		# 	pool agent, as: name
		# else
		# 	pool agent, as: name, size: count
		# end
	end
	#endregion DSL
	
	def self.generate_recipe(agent, options = {})
		name = nil
		if options.key?(:as)
			name = options[:as]
		else
			mas_name = self.name.to_sym
			agent_name = agent.name.to_sym
			@@counters[agent_name] ||= 0
			@@counters[agent_name] += 1
			
			name = "#{mas_name}_#{agent_name}_#{@@counters[agent_name]}"
		end
		
		AgentConfigRecipe.new(agent, name, options[:args])
	end
end