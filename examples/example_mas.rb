require 'agens'

# Definition
class UltrasonicSensor < Sensor
end

class Motor < Actuator
end

class ExampleAgent < Agent
	def setup
		sensor UltrasonicSensor
		actuator Motor
	end
	
	def perform_reasoning
		idle
	end
end

class Jessie < ExampleAgent
	
end

class James < ExampleAgent
	
end

class ExampleMAS < MAS
	agent Jessie
	agent James
end

# Program
mas = ExampleMAS.new
mas.run

mas.world.dump

sleep(2)

mas.shutdown