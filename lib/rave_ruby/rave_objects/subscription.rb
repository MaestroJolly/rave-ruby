require_relative "base/subscription_base.rb"
require 'json'

class Subscription < SubscriptionBase

    #method to list subscriptions

    def list_all_subscription
        base_url = rave_object.base_url
        response = get_request("#{base_url}#{BASE_ENDPOINTS::SUBSCRIPTIONS_ENDPOINT}/query",{"seckey" => rave_object.secret_key.dup})
        return handle_list_all_subscription(response)
    end 

    #method to fetch a subscription

    def fetch_subscription(id, email)
        base_url = rave_object.base_url
        secret_key = rave_object.secret_key.dup

        response = get_request("#{base_url}#{BASE_ENDPOINTS::SUBSCRIPTIONS_ENDPOINT}/query",{"seckey" => rave_object.secret_key.dup, "id" => id, "email": email})
        return handle_fetch_subscription_response(response)
    end 

    def cancel_subscription(id)
        base_url = rave_object.base_url
        secret_key = rave_object.secret_key.dup

        payload = {
            "seckey" => secret_key,
        }

        payload = payload.to_json
        response = post_request("#{base_url}#{BASE_ENDPOINTS::SUBSCRIPTIONS_ENDPOINT}/#{id}/cancel",payload)
        return handle_cancel_response(response)
    end

    def activate_subscription(id)

        base_url = rave_object.base_url
        secret_key = rave_object.secret_key.dup

        # data.merge!({"seckey" => secret_key.dup})

        payload = {
            "seckey" => secret_key,
        }
        payload = payload.to_json
        response = post_request("#{base_url}#{BASE_ENDPOINTS::SUBSCRIPTIONS_ENDPOINT}/#{id}/activate",payload)
        return handle_activate_subscription_response(response)
    end
end