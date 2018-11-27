require_relative "base.rb"

class PaymentPlanBase < Base

    # method to handle create response 

    def handle_create_response(response)

        create_response = response
        # print create_response
        statusMessage = create_response["status"]
        message = create_response["message"]
        id = create_response["data"]["id"]
        name = create_response["data"]["name"]
        amount =  create_response["data"]["amount"]
        interval = create_response["data"]["interval"]
        duration = create_response["data"]["duration"]
        status = create_response["data"]["status"]
        plan_token = create_response["data"]["plan_token"]
        date_created = create_response["data"]["date_created"]

        if statusMessage == "success"
            response = {"error": false, "id": id, "message": message, "name": name, "amount": amount, "interval": interval, "duration": duration,  "status": status,"plan_token": plan_token, "date_created": date_created}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": create_response["data"]}
            raise CreatePaymentPlanError, JSON.parse(response.to_json)
        end
    end

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
            response = {"error": true, "data": create_response["data"]}
            raise ListPaymentPlanError, JSON.parse(response.to_json)
        end
end

def handle_fetch_response(response)
    fetch_response = response
    status = fetch_response["status"]
    message = fetch_response["message"]
    data = fetch_response["data"]

    if status == "success"
        response = {"error": false, "status": status,"message": message, "data": data}
        return JSON.parse(response.to_json)
    else
        response = {"error": true, "data": create_response["data"]}
        raise FetchPaymentPlanError, JSON.parse(response.to_json)
    end

end

def handle_cancel_response(response)
    cancel_response = response
    status = cancel_response["status"]
    message = cancel_response["message"]
    data = cancel_response["data"]

    if status == "success"
        response = {"error": false, "status": status,"message": message, "data": data}
        return JSON.parse(response.to_json)
    else
        response = {"error": true, "data": create_response["data"]}
        raise CancelPaymentPlanError, JSON.parse(response.to_json)
    end
end

def handle_edit_response(response)
    edit_response = response
    status = edit_response["status"]
    message = edit_response["message"]
    data = edit_response["data"]

    if status == "success"
        response = {"error": false, "status": status,"message": message, "data": data}
        return JSON.parse(response.to_json)
    else
        response = {"error": true, "data": create_response["data"]}
        raise EditPaymentPlanError, JSON.parse(response.to_json)
    end
end

end