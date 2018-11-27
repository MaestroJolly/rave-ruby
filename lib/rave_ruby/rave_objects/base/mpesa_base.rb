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
        flwref = verify_response["data"]["flwref"]
        txref = verify_response["data"]["txref"]
        status = verify_response["data"]["status"]
        charged_amount = verify_response["data"]["chargedamount"]
        amount = verify_response["data"]["amount"]
        vbvmessage = verify_response["data"]["vbvmessage"]
        currency = verify_response["data"]["currency"]
        charge_code = verify_response["data"]["chargecode"]
        charge_message = verify_response["data"]["chargemessage"]

        if charge_code == "00" && status == "successful"
            res = {"error": false, "status": status, "transaction_complete": true, "txRef": txref, "flwRef": flwref, "amount": amount, "chargedamount": charged_amount, "vbvmessage": vbvmessage, "currency": currency, "chargecode": charge_code, "chargemessage": charge_message}
            return JSON.parse(res.to_json)
        else
            res = {"error": true, "status": status, "transaction_complete": false, "txRef": txref, "flwRef": flwref, "amount": amount, "chargedamount": charged_amount, "vbvmessage": vbvmessage, "currency": currency, "charge_code": charge_code, "chargemessage": charge_message}
            return JSON.parse(res.to_json)
        end
    end
end