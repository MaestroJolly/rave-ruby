require_relative "base.rb"

class MpesaBase < Base

    # method to handle mpesa charge response
    def handle_charge_response(response)

        charge_response = response
        flwRef = charge_response["data"]["flwRef"]
        txRef = charge_response["data"]["txRef"]
        status = charge_response["data"]["status"]
        amount = charge_response["data"]["amount"]
        currency = charge_response["data"]["currency"]
        payment_type = charge_response["data"]["paymentType"]


        if status == "pending"
            res = {"error": false, "status": status, "validation_required": true, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "paymentType": payment_type}
            return JSON.parse(res.to_json)
        else
            res = {"error": false, "status": status, "validation_required": false, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "paymentType": payment_type}
            return JSON.parse(res.to_json)
        end
    end


    # method to handle mpesa verify response
    def handle_verify_response(response)
        verify_response = response
        status = verify_response["data"]["status"]
        charge_code = verify_response["data"]["chargecode"]

        if charge_code == "00" && status == "successful"
            res = {"error": false, "transaction_complete": true, "data": verify_response["data"]}
            return JSON.parse(res.to_json)
        else
            res = {"error": false, "transaction_complete": false, "data": verify_response["data"]}
            return JSON.parse(res.to_json)
        end
    end
end