require_relative './lib/rave_ruby'

# rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-92e93a5c487ad64939327052e113c813-X", "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X")


# This is used to perform card charge

payload = {
    "accountbank" => "044",
    "accountnumber" => "0690000031",
    "currency" => "NGN",
    "payment_type" =>  "account",
    "country" => "NG",
    "amount" => "100", 
    "email" => "mijux@xcodes.net",
    "phonenumber" => "08134836828",
    "firstname" => "ifunanya",
    "lastname" => "Ikemma",
    "IP" => "355426087298442",
    "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
    "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

charge_account = Account.new(rave)

# print charge_account.initiate_charge(payload)

response = charge_account.initiate_charge(payload)

# # print response


# # #  perform the second charge after payload is updated with suggested auth
# # response = charge_card.initiate_charge(updated_payload)
# print response

# # perform validation if it is required

if response["validation_required"]
    response = charge_account.validate_charge(response["flwRef"], "12345")
    # print response
end

# # # verify charge
response = charge_account.verify_charge(response["txRef"])

print response