require_relative "base.rb"

class PreauthBase < Base

    # method to handle preauth charge response
    def handle_charge_response(response)
        charge_response = response
        flwRef = charge_response["data"]["flwRef"]
        txRef = charge_response["data"]["txRef"]
        status = charge_response["data"]["status"]
        amount = charge_response["data"]["amount"]
        charged_amount = charge_response["data"]["charged_amount"]
        currency = charge_response["data"]["currency"]
        payment_type = charge_response["data"]["paymentType"]
        charge_response_code = charge_response["data"]["chargeResponseCode"]
        charge_response_message = charge_response["data"]["chargeResponseMessage"]
        validation_instruction = charge_response["data"]["validateInstructions"]


        if charge_response_code == "02"
            res = {"error": false, "status": status, "validation_required": true, "txRef": txRef, "flwRef": flwRef, "validateInstruction": validation_instruction, "amount": amount, "currency": currency, "paymentType": payment_type}
            return JSON.parse(res.to_json)
        else
            res = {"error": false, "status": status, "validation_required": false, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "paymentType": payment_type}
            return JSON.parse(res.to_json)
        end
    end


    # method to handle capture response
    def handle_capture_response(response)
        capture_response = response
        flwRef = capture_response["data"]["flwRef"]
        txRef = capture_response["data"]["txRef"]
        status = capture_response["data"]["status"]
        message = capture_response["message"]
        payment_type = capture_response["data"]["paymentType"]
        amount = capture_response["data"]["amount"]
        charge_response_code = capture_response["data"]["chargeResponseCode"]
        charge_response_message = capture_response["data"]["chargeResponseMessage"]
        currency = capture_response["data"]["currency"]

        if charge_response_code == "02"
            res = {"error": false, "status": status, "validation_required": true, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "chargeResponseCode": charge_response_code, "chargeResponseMessage": charge_response_message, "paymentType": payment_type}
            return JSON.parse(res.to_json)
        else
            res = {"error": false, "status": status, "message": message, "validation_required": false, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "chargeResponseCode": charge_response_code, "chargeResponseMessage": charge_response_message, "paymentType": payment_type}
            return JSON.parse(res.to_json)
        end
    end


    # method to handle refund or void response
    def handle_refund_void_response(response)
        refund_void_response = response
        status = refund_void_response["data"]["status"]
        charge_response_code = refund_void_response["data"]["chargeResponseCode"]

        if charge_response_code == "02"
            res = {"error": false, "status": status, "data": refund_void_response["data"]}
            return JSON.parse(res.to_json)
        else
            res = {"error": false, "status": status, "data": refund_void_response["data"]}
            return JSON.parse(res.to_json)
        end
    end


    # method to handle verify preauth response
    def handle_verify_response(response)
        verify_response = response
        flwref = verify_response["data"]["flwref"]
        txref = verify_response["data"]["txref"]
        status = verify_response["data"]["status"]
        charged_amount = verify_response["data"]["chargedamount"]
        amount = verify_response["data"]["amount"]
        vbvmessage = verify_response["data"]["vbvmessage"]
        vbvcode = verify_response["data"]["vbvcode"]
        currency = verify_response["data"]["currency"]
        charge_code = verify_response["data"]["chargecode"]
        charge_message = verify_response["data"]["chargemessage"]

        if charge_code == "00" && status == "successful"
            res = {"error": false, "status": status, "transaction_complete": true, "txref": txref, "flwref": flwref, "amount": amount, "chargedamount": charged_amount, "vbvmessage": vbvmessage, "vbvcode": vbvcode, "currency": currency, "chargecode": charge_code, "chargemessage": charge_message}
            return JSON.parse(res.to_json)
        else
            res = {"error": false, "status": status, "transaction_complete": false, "txref": txref, "flwef": flwref, "amount": amount, "chargedamount": charged_amount, "vbvmessage": vbvmessage, "vbvcode": vbvcode, "currency": currency, "charge_code": charge_code, "chargemessage": charge_message}
            return JSON.parse(res.to_json)
        end
    end
end