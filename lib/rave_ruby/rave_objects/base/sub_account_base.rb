require_relative "base.rb"

class SubAccountBase < Base

    # method to handle subaccount creation response
    def handle_create_response(response)

        initiate_response = response
        status = initiate_response["status"]
        id = initiate_response["data"]["id"]

        if status == "success"
            response = {"error": false, "id": id, "data": initiate_response["data"]}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": initiate_response["data"]}
            raise InitiateTransferError, JSON.parse(response.to_json)
        end
    end

    # method to list subaccounts response
    def handle_subaccount_response(response)
        
        subaccount_response = response

        if subaccount_response.code == 200
            response = {"error" => false, "data" => JSON.parse(subaccount_response.body)}
            return response
        else
            response = {"error" => true, "data" => JSON.parse(subaccount_response.body)}
            raise InitiateTransferError, response
        end
    end
end