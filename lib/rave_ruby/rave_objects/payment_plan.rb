require_relative "base/payment_plan_base.rb"
require 'json'

class PaymentPlan < PaymentPlanBase

    # method to create a payment plan

    def create_payment_plan(data)
        base_url = rave_object.base_url
        secret_key = rave_object.secret_key.dup

        data.merge!({"seckey" => secret_key.dup})

        required_parameters = ["amount", "name", "interval"]
        check_passed_parameters(required_parameters, data)

        payload = data.to_json
        response = post_request("#{base_url}#{BASE_ENDPOINTS::PAYMENT_PLANS_ENDPOINT}/create", payload) 

        return handle_create_response(response)
    end 

    def list_payment_plans
        base_url = rave_object.base_url
        response = get_request("#{base_url}#{BASE_ENDPOINTS::PAYMENT_PLANS_ENDPOINT}/query",{"seckey" => rave_object.secret_key.dup})
        return handle_list_response(response)
    end 

    def fetch_payment_plan(id,q=nil )
        base_url = rave_object.base_url
        secret_key = rave_object.secret_key.dup

        response = get_request("#{base_url}#{BASE_ENDPOINTS::PAYMENT_PLANS_ENDPOINT}/query",{"seckey" => rave_object.secret_key.dup, "id" => id, "q": q})
        return handle_fetch_response(response)
    end 

    def cancel_payment_plan(id)
        base_url = rave_object.base_url
        secret_key = rave_object.secret_key.dup

        payload = {
            "seckey" => secret_key,
        }

        payload = payload.to_json
        response = post_request("#{base_url}#{BASE_ENDPOINTS::PAYMENT_PLANS_ENDPOINT}/#{id}/cancel",payload)
        return handle_cancel_response(response)
    end

    def edit_payment_plan(id, data)

        base_url = rave_object.base_url
        secret_key = rave_object.secret_key.dup

        data.merge!({"seckey" => secret_key.dup})

        payload = data.to_json
        response = post_request("#{base_url}#{BASE_ENDPOINTS::PAYMENT_PLANS_ENDPOINT}/#{id}/edit",payload)
        return handle_edit_response(response)
    end
end