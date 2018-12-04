require_relative "base.rb"

class PaymentPlanBase < Base

    # method to handle payment plan response 

    def handle_create_response(response)

        create_response = response
        statusMessage = create_response["status"]

        if statusMessage == "success"
            response = {"error": false, "data": create_response["data"]}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": create_response["data"]}
            raise CreatePaymentPlanError, JSON.parse(response.to_json)
        end
    end

    # method to list payment plan

    def handle_list_response(response)
        list_response = response

        status = list_response["status"]
        message = list_response["message"]
       data = list_response["data"]
       paymentplans = list_response["data"]["paymentplans"]

        if status == "success"
            response = {"error": false, "status": status,"message": message, "data": data}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": list_response["data"]}
            raise ListPaymentPlanError, JSON.parse(response.to_json)
        end
    end

    # method to handle fetch payment plan response
    def handle_fetch_response(response)
        fetch_response = response
        status = fetch_response["status"]
        data = fetch_response["data"]

        if status == "success"
            response = {"error": false, "data": data}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": data}
            raise FetchPaymentPlanError, JSON.parse(response.to_json)
        end

    end

    # method to handle cancel payment response
    def handle_cancel_response(response)
        cancel_response = response
        status = cancel_response["status"]
        data = cancel_response["data"]

        if status == "success"
            response = {"error": false, "data": data}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": data}
            raise CancelPaymentPlanError, JSON.parse(response.to_json)
        end
    end

    # method to handle edit payment plan response 
    def handle_edit_response(response)
        edit_response = response
        status = edit_response["status"]
        data = edit_response["data"]

        if status == "success"
            response = {"error": false, "data": data}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": data}
            raise EditPaymentPlanError, JSON.parse(response.to_json)
        end
    end

end