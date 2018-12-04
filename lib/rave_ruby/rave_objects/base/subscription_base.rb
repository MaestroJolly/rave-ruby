require_relative "base.rb"

class SubscriptionBase < Base
    
     # method to handle list subscription

     def handle_list_all_subscription(response)

        list_all_subscription = response
        status = list_all_subscription["status"]
        message = list_all_subscription["message"]
       data = list_all_subscription["data"]
       plansubscriptions =list_all_subscription["data"]["plansubscriptions"]

        if status == "success"
            response = {"error": false, "status": status,"message": message, "data": data, "plansubscriptions": plansubscriptions}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": create_response["data"]}
            raise ListSubscriptionError, JSON.parse(response.to_json)
        end

     end

     #method to handle fetch subscription

     def handle_fetch_subscription_response(response)
        fetch_subscription_response = response
        status = fetch_subscription_response["status"]
        message = fetch_subscription_response["message"]
        data = fetch_subscription_response["data"]
    
        if status == "success"
            response = {"error": false, "status": status,"message": message, "data": data}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": create_response["data"]}
            raise FetchSubscriptionError, JSON.parse(response.to_json)
        end
    
    end

    #method to handle cancel subscription

    def handle_cancel_subscription_response(response)
        cancel_subscription_response = response
        status = cancel_subscription_response["status"]
        message = cancel_subscription_response["message"]
        data = cancel_subscription_response["data"]
    
        if status == "success"
            response = {"error": false, "status": status,"message": message, "data": data}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": create_response["data"]}
            raise CancelSubscriptionError, JSON.parse(response.to_json)
        end
    end

    #method to handle activate subscription

    def handle_activate_subscription_response(response)
        handle_activate_subscription_response = response
        status = handle_activate_subscription_response["status"]
        message = handle_activate_subscription_response["message"]
        data = handle_activate_subscription_response["data"]
    
        if status == "success"
            response = {"error": false, "status": status,"message": message, "data": data}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": create_response["data"]}
            raise ActivateSubscriptionError, JSON.parse(response.to_json)
        end
    end
    

end 