require_relative "base.rb"

class TransferBase < Base

    # method to handle single transfer response
    def handle_initiate_response(response)

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

    # method to handle bulk transfer response
    def handle_bulk_response(response)

        bulk_response = response
        status = bulk_response["status"]
        id = bulk_response["data"]["id"]

        if status == "success"
            response = {"error": false, "status": status, "message": bulk_response["message"], "id": id, "data": bulk_response["data"]}
            return JSON.parse(response.to_json)
        else
            response = {"error": true, "data": initiate_response["data"]}
            raise InitiateTransferError, JSON.parse(response.to_json)
        end
    end

    # method to handle get fee response
    def handle_transfer_status(response)
        
        transfer_status = response

        if transfer_status.code == 200
            response = {"error" => false, "data" => JSON.parse(transfer_status.body)}
            return response
        else
            response = {"error" => true, "data" => JSON.parse(transfer_status.body)}
            raise InitiateTransferError, response
        end
    end

    # method to handle get balance response
    def handle_balance_status(response)
        
        balance_status = response
        status = balance_status["status"]

        if status == "success"
            response = {"error" => false, "returned_data" => JSON.parse(balance_status.body)}
            return response
        else
            response = {"error" => true, "returned_data" => JSON.parse(balance_status.body)}
            raise InitiateTransferError, response
        end
    end

    # method to handle fetch account response
    def handle_fetch_status(response)

        fetch_status = response

        if fetch_status.code == 200
            response = {"error" => false, "returned_data" => JSON.parse(fetch_status.body)}
            return response
        else
            response = {"error" => true, "returned_data" => JSON.parse(fetch_status.body)}
            raise InitiateTransferError, response
        end
    end

end