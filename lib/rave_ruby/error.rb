class RaveServerError < StandardError
	attr_reader :response
	def initialize(response=nil)
		@response = response
	end
end

class RaveBadKeyError < StandardError
end

class IncompleteParameterError < StandardError
end

class SuggestedAuthError < StandardError
end

class RequiredAuthError < StandardError
end

class InitiateTransferError < StandardError
end