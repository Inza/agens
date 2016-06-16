require 'celluloid/current'

class Agent
	include Celluloid
	include Celluloid::Internals::Logger
	
	class NotImplementedError < StandardError; end
	
	def initialize
		@sensor_classes = {}
		@actuator_classes = {}
		@sensors = {}
		@actuators = {}
		
		setup
		
		@sensor_classes.each do |name, sensor_clazz|
			sensor = sensor_clazz.new_link
			@sensors[name] = sensor
		end
		
		@actuator_classes.each do |name, actuator_clazz|
			actuator = actuator_clazz.new_link
			@actuators[name] = actuator
		end
		
		self.async.think_loop
	end

	def to_s
		s = "Agent #{self.class.name}:\n"
		s << "	Sensors:\n"
		@sensor_classes.each {|n, _| s << "		<- #{n}\n"}
		s << "	Actuators:\n"
		@actuator_classes.each {|n, _| s << "		-> #{n}\n"}
		
		s
	end
	
	private
		def think_loop
			while true
				perform_reasoning
				
				sleep(1)
			end
		end
		
		def idle
			info "[#{self.class.name}] Idling..."
		end
	
	protected
		def setup
			warn "[#{self.class.name}] I do not have any setup...(give me some sensors and actuators please)"
		end
		
		def perform_reasoning
			raise NotImplementedError, "[#{self.class.name}] My reasoning is not implemented yet..."
		end
		
		#region DSL
		def sensor(sensor_clazz, name = nil)
			name = sensor_clazz.name.to_sym if name == nil
			
			@sensor_classes[name] = sensor_clazz
		end
		
		def actuator(actuator_clazz, name = nil)
			name = actuator_clazz.name.to_sym if name == nil
			
			@actuator_classes[name] = actuator_clazz
		end
		#endregion DSL
end