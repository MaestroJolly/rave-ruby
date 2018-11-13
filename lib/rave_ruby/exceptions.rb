class RaveServerError < StandardError
	attr_reader :response
	def initialize(response=nil)
		@response = response
	end
end

class RaveBadKeyError < StandardError
end