require_relative "base.rb"

class ChargeBase < Base

    # method to the passed suggested auth to the corresponding value in the available hash
  def get_auth_type(suggested_auth)
    auth_map = {"PIN" => :pin, "AVS_VBVSECURECODE" => :address, "NOAUTH_INTERNATIONAL" => :address, "AVS_NOAUTH" => :address}

    # Raise Error if the right authorization type is not passed
    unless !auth_map.has_key? auth_map[suggested_auth]
      raise RequiredAuthError, "Required suggested authorization type not available."
    end
    return auth_map[suggested_auth]
  end


  # method to update payload
  def update_payload(suggested_auth, payload, **keyword_args)
    auth_type = get_auth_type(suggested_auth)
    
    # Error is raised if the expected suggested auth is not found in the keyword arguments
    if !keyword_args.key?(auth_type)
      raise SuggestedAuthError, "Please pass the suggested auth."
    end

    # if the authorization type is equal to address symbol, update with the required parameters
    if auth_type == :address
      required_parameters = ["billingzip", "billingcity", "billingaddress", "billingstate", "billingcountry"]
      check_passed_parameters(required_parameters, keyword_args[auth_type])
      payload.merge!({"suggested_auth" => suggested_auth})
      return payload.merge!(keyword_args[auth_type])
    end

    # return this updated payload if the passed authorization type isn't address symbol
    return payload.merge!({"suggested_auth" => suggested_auth, auth_type.to_s => keyword_args[auth_type]})

  end

  # method to charge response
  def handle_charge_response (response)

    charge_response = response
    flwRef = charge_response["data"]["flwRef"]
    txRef = charge_response["data"]["txRef"]
    status = charge_response["data"]["status"]
    amount = charge_response["data"]["amount"]
    currency = charge_response["data"]["currency"]
    auth_model_used = charge_response["data"]["authModelUsed"]
    payment_type = charge_response["data"]["paymentType"]
    charge_response_code = charge_response["data"]["chargeResponseCode"]
    charge_response_message = charge_response["data"]["chargeResponseMessage"]


    if charge_response["data"]["authurl"] == "N/A"
      authurl = "N/A"
    else
      authurl = charge_response["data"]["authurl"]
    end

    if charge_response_code == "00"
      res = {"error": false, "status": status, "validation_required": false, "txRef": txRef, "flwRef": flwRef, "chargeResponseCode": charge_response_code, "suggested_auth": suggested_auth, "chargeResponseMessage": charge_response_message, "amount": amount, "currency": currency, "paymentType": payment_type, "authModelUsed": auth_model_used, "authurl": authurl}
      return JSON.parse(res.to_json)
    elsif charge_response_code == "02"
      suggested_auth = charge_response["data"]["suggested_auth"]
      res = {"error": false, "status": status, "validation_required": true, "txRef": txRef, "flwRef": flwRef, "chargeResponseCode": charge_response_code, "chargeResponseMessage": charge_response_message, "amount": amount, "currency": currency, "suggested_auth": nil, "paymentType": payment_type, "authModelUsed": auth_model_used, "authurl": authurl}
      return JSON.parse(res.to_json)
    else
      return charge_response
    end
  end


  # method to handle validate card response
  def handle_validate_response(response)

    validate_response = response
    flwRef = validate_response["data"]["tx"]["flwRef"]
    txRef = validate_response["data"]["tx"]["txRef"]
    status = validate_response["status"]
    message = validate_response["message"]
    amount = validate_response["data"]["tx"]["amount"]
    currency = validate_response["data"]["tx"]["currency"]
    charge_response_code = validate_response["data"]["tx"]["chargeResponseCode"]
    charge_response_message = validate_response["data"]["tx"]["chargeResponseMessage"]

    if charge_response_code == "00"
      res = {"error": false, "status": status, "message": message, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "chargeResponseCode": charge_response_code, "chargeResponseMessage": charge_response_message}
      return JSON.parse(res.to_json)
    else
      res = {"error": true, "status": status, "message": message, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "chargeResponseCode": charge_response_code, "chargeResponseMessage": charge_response_message}
      return JSON.parse(res.to_json)
    end
  end


   # method to handle validate account response
   def handle_validate_account_response(response)

    validate_response = response
    flwRef = validate_response["data"]["flwRef"]
    txRef = validate_response["data"]["txRef"]
    status = validate_response["status"]
    message = validate_response["message"]
    amount = validate_response["data"]["amount"]
    currency = validate_response["data"]["currency"]
    charge_response_code = validate_response["data"]["chargeResponseCode"]
    charge_response_message = validate_response["data"]["chargeResponseMessage"]

    if charge_response_code == "00"
      res = {"error": false, "status": status, "message": message, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "chargeResponseCode": charge_response_code, "chargeResponseMessage": charge_response_message}
      return JSON.parse(res.to_json)
    else
      res = {"error": true, "status": status, "message": message, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "chargeResponseCode": charge_response_code, "chargeResponseMessage": charge_response_message}
      return JSON.parse(res.to_json)
    end
  end

  # method to handle card verify response
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
    card_token = verify_response["data"]["card"]["card_tokens"][0]["embedtoken"]

    if charge_code == "00" && status == "successful"
      res = {"error": false, "status": status, "transaction_complete": true, "txRef": txref, "flwRef": flwref, "amount": amount, "chargedamount": charged_amount, "cardToken": card_token, "vbvmessage": vbvmessage, "currency": currency, "chargecode": charge_code, "chargemessage": charge_message}
      return JSON.parse(res.to_json)
    else
      res = {"error": true, "status": status, "transaction_complete": false, "txRef": txref, "flwRef": flwref, "amount": amount, "chargedamount": charged_amount, "cardToken": card_token, "vbvmessage": vbvmessage, "currency": currency, "charge_code": charge_code, "chargemessage": charge_message}
      return JSON.parse(res.to_json)
    end
  end

  # method to handle account verify response
  def handle_verify_account_response(response)
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
    account_message = verify_response["data"]["acctmessage"]
    account_token = verify_response["data"]["account"]["account_token"]["token"]

    if charge_code == "00" && status == "successful"
      res = {"error": false, "status": status, "transaction_complete": true, "txRef": txref, "flwRef": flwref, "amount": amount, "chargedamount": charged_amount, "acctmessage": account_message, "accountToken": account_token, "vbvmessage": vbvmessage, "currency": currency, "chargecode": charge_code, "chargemessage": charge_message}
      return JSON.parse(res.to_json)
    else
      res = {"error": true, "status": status, "transaction_complete": false, "txRef": txref, "flwRef": flwref, "amount": amount, "chargedamount": charged_amount, "acctmessage": account_message, "accountToken": account_token, "vbvmessage": vbvmessage, "currency": currency, "charge_code": charge_code, "chargemessage": charge_message}
      return JSON.parse(res.to_json)
    end
  end
end 