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

class CreatePaymentPlanError < StandardError
end

class ListPaymentPlanError < StandardError
end

class FetchPaymentPlanError < StandardError
end

class CancelPaymentPlanError < StandardError
end

class EditPaymentPlanError < StandardError
end

class ListSubscriptionError < StandardError
end

class FetchSubscriptionError < StandardError
end

class CancelSubscriptionError < StandardError
end

class ActivateSubscriptionError < StandardError
end