require_relative './lib/rave_ruby'

# rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-92e93a5c487ad64939327052e113c813-X", "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X")


# This is used to perform card charge

payload = {
    "cardno" => "5438898014560229",
    "cvv" => "890",
    "expirymonth" => "09",
    "expiryyear" => "19",
    "currency" => "NGN",
    "country" => "NG",
    "amount" => "10",
    "email" => "user@gmail.com",
    "phonenumber" => "0902620185",
    "firstname" => "temi",
    "lastname" => "desola",
    "IP" => "355426087298442",
    "meta" => [{"metaname": "flightID", "metavalue": "123949494DC"}],
    "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
    "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

charge_card = Card.new(rave)

# print charge_card.initiate_charge(payload)

response = charge_card.initiate_charge(payload)

print response

# update payload with suggested auth
if response["message"] == "AUTH_SUGGESTION"
    suggested_auth = response["data"]["suggested_auth"]
    auth_arg = charge_card.get_auth_type(suggested_auth)
    if auth_arg == :pin
        updated_payload = charge_card.update_payload(suggested_auth, payload, pin: "3310")
    elsif auth_arg == :address
        updated_payload = charge_card.update_payload(suggested_auth, payload, address:{"billingzip"=> "07205", "billingcity"=> "Hillside", "billingaddress"=> "470 Mundet PI", "billingstate"=> "NJ", "billingcountry"=> "US"})
    end
end

#  perform the second charge after payload is updated with suggested auth
response = charge_card.initiate_charge(updated_payload)
print response

# perform validation if it is required

if response["validation_required"]
    response = charge_card.validate_charge(response["flwRef"], "12345")
    print response
end

# verify charge
response = charge_card.verify_charge(response["txRef"])

print response


# print updated_payload

# print res["data"]["suggested_auth"]
