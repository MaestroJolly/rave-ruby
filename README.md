# RaveRuby

This is a ruby gem for easy integration of Rave API for various applications written in ruby language from [Rave](https://rave.flutterwave.com) by [Flutterwave.](https://developer.flutterwave.com/reference)

## Documentation

See [Here](https://developer.flutterwave.com/reference) for Rave API Docs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rave_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rave_ruby

## Usage

### Initialization

#### Instantiate rave object in sandbox with environment variable:

To use [Rave](https://ravesandbox.flutterwave.com), you need to instantiate the RaveRuby class with your [API](https://ravesandbox.flutterwave.com/dashboard/settings/apis) keys which are your public and secret keys. We recommend that you store your API keys in your environment variable named `RAVE_PUBLIC_KEY` and `RAVE_SECRET_KEY`. Instantiating your rave object after adding your API keys in your environment is as illustrated below:

```ruby
rave = RaveRuby.new
```
This throws a `RaveBadKeyError` if no key is found in the environment variable or invalid public or secret key is found.

#### Instantiate rave object in sandbox without environment variable:

You can instantiate your rave object by setting your public and secret keys by passing them as an argument of the `RaveRuby` class just as displayed below: 

```ruby
rave = RaveRuby.new("YOUR_RAVE_SANDBOX_PUBLIC_KEY", "YOUR_RAVE_SANDBOX_SECRET_KEY")
```

#### `NOTE:` It is best practice to always set your API keys to your environment variable for security purpose. Please be warned not use this package without setting your API keys in your environment variables in production.

#### To instantiate rave object in production with environment variable:

Simply use it as displayed below:

```ruby
rave = RaveRuby.new("YOUR_RAVE_LIVE_PUBLIC_KEY", "YOUR_RAVE_LIVE_SECRET_KEY", true)
```

## Rave Objects

- [Account.new(rave)](#accountnewrave)
- [Card.new(rave)](#cardnewrave)
- [Preauth.new(rave)](#preauthnewrave)
- [MobileMoney.new(rave)](#mobilemoneynewrave)
- [Mpesa.new(rave)](#mpesanewrave)
- [SubAccount.new(rave)](#subaccountnewrave)
- [PaymentPlan.new(rave)](#paymentplannewrave)
- [Subscription.new(rave)](#subscriptionnewrave)
- [Transfer.new(rave)](#transfernewrave)
- [UgandaMobileMoney.new(rave)](#ugandamobilemoneynewrave)
- [Ussd.new(rave)](#ussdnewrave)
- [ListBanks.new(rave)](#listbanksnewrave)

## `Account.new(rave)`

To perform account transactions, instantiate the account object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.validate_charge`
- `.verify_charge`

### `.initiate_charge(payload)`

This function is called to initiate account transaction. The payload should be a ruby hash with account details. Its parameters should include the following:

- `accountbank`,

- `accountnumber`,

- `amount`,

- `email`,

- `phonenumber`,

- `IP`

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample account charge call:

```ruby
response = charge_account.initiate_charge(payload)
```
#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "validation_required"=>true, "message"=>"V-COMP", "suggested_auth"=>nil, "txRef"=>"MC-2232eed54ca72f8ae2125f49020fb592", "flwRef"=>"ACHG-1544908923260", "chargeResponseCode"=>"02", "chargeResponseMessage"=>"Pending OTP validation", "amount"=>100, "currency"=>"NGN", "validateInstruction"=>"Please dial *901*4*1# to get your OTP. Enter the OTP gotten in the field below", "paymentType"=>"account", "authModelUsed"=>"AUTH", "authurl"=>"NO-URL"
}

```
A `RaveServerError` is raised if there's an error with the charge.

#### Sample error response if an exception is raised:

```ruby
{
    "status":"error","message":"Sorry that account number is invalid. Please check and try again","data":{"code":"FLW_ERR","message":"Sorry that account number is invalid. Please check and try again","err_tx":{"id":360210,"flwRef":"ACHG-1544910130710","chargeResponseCode":"RR","chargeResponseMessage":"Sorry that account number is invalid. Please check and try again","status":"failed","merchantbearsfee":1,"appfee":"1.4","merchantfee":"0","charged_amount":"100.00"
}}}

```

### `.validate_charge(flwRef, "OTP")`

After a successful charge, most times you will be asked to verify with OTP. To check if this is required, check the validation_required key in the response of the charge call i.e `response["validation_required"]` is equal to `true`.

In the case that an `authUrl` is returned from your charge call, you may skip the validation step and simply pass your authurl to the end-user as displayed below:

```ruby
authurl = response['authurl']
```

If validation is required by OTP, you need to pass the `flwRef` from the response of the charge call as well as the OTP.

#### Sample validate_charge call is:

```ruby
response = charge_account.validate_charge(response["flwRef"], "12345")
```

#### which returns:

It returns this response in ruby hash with the `txRef` and `flwRef` amongst its successful response:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-c0c707a798de82f34b937e6126844d6c", "flwRef"=>"ACHG-1544963949493", "amount"=>100, "currency"=>"NGN", "chargeResponseCode"=>"00", "chargeResponseMessage"=>"Pending OTP validation"
}
```

If an error occurs during OTP validation, you will receive a response similiar to this:

```ruby
{
    "error"=>true, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-4cd9b2e4a9a104f92273ce194993ab50", "flwRef"=>"ACHG-1544969082006", "amount"=>100, "currency"=>"NGN", "chargeResponseCode"=>"02", "chargeResponseMessage"=>"Pending OTP validation"
}
```
With `chargeResponseCode` still equals to `02` which means it didn't validate successfully and is till pending validation.

Otherwise if validation is successful using OTP, you will receive a response similar to this:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-c0c707a798de82f34b937e6126844d6c", "flwRef"=>"ACHG-1544963949493", "amount"=>100, "currency"=>"NGN", "chargeResponseCode"=>"00", "chargeResponseMessage"=>"Pending OTP validation"
}
```

With `chargeResponseCode` equals to `00` which means it validated successfully.

### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` or `validate_charge` call.

#### Sample verify_charge call:

```ruby
response = charge_account.verify_charge(response["txRef"])
```

#### which returns:

It returns this response in ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby
{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>360744, "txref"=>"MC-c0c707a798de82f34b937e6126844d6c", "flwref"=>"ACHG-1544963949493", "devicefingerprint"=>"69e6b7f0b72037aa8428b70fbe03986c", "cycle"=>"one-time", "amount"=>100, "currency"=>"NGN", "chargedamount"=>100, "appfee"=>1.4, "merchantfee"=>0, "merchantbearsfee"=>1, "chargecode"=>"00", "chargemessage"=>"Pending OTP validation", "authmodel"=>"AUTH", "ip"=>"::ffff:10.11.193.41", "narration"=>"Simply Recharge", "status"=>"successful",
    "vbvcode"=>"N/A", "vbvmessage"=>"N/A", "authurl"=>"NO-URL", "acctcode"=>"00", "acctmessage"=>"Approved Or Completed Successfully", "paymenttype"=>"account", "paymentid"=>"90", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>0, "createddayname"=>"SUNDAY", "createdweek"=>50, "createdmonth"=>11, "createdmonthname"=>"DECEMBER", "createdquarter"=>4, "createdyear"=>2018, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>12, "createdminute"=>39, "createdpmam"=>"pm", "created"=>"2018-12-16T12:39:08.000Z", "customerid"=>64794, "custphone"=>"08134836828", "custnetworkprovider"=>"MTN", "custname"=>"ifunanya Ikemma", "custemail"=>"mijux@xcodes.net", "custemailprovider"=>"COMPANY EMAIL", "custcreated"=>"2018-11-26T11:35:24.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"URF_1544963948269_113435", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>"RV31544963947776E1DB61E313", "amountsettledforthistransaction"=>98.6, "account"=>{"id"=>90, "account_number"=>"0690000033", "account_bank"=>"044", "first_name"=>"NO-NAME", "last_name"=>"NO-LNAME", "account_is_blacklisted"=>0, "createdAt"=>"2017-04-26T12:54:22.000Z", "updatedAt"=>"2018-12-16T12:39:23.000Z", "deletedAt"=>nil, "account_token"=>{"token"=>"flw-t03a483b4eecf61cda-k3n-mock"}}, "meta"=>[]}
}

```

If a transaction couldn't be verified successfully, `error` and `transaction_complete` would both come as `false`.

#### Full Account Transaction Flow:

```ruby
require_relative './lib/rave_ruby'

# This is a rave object which is expecting public and secret keys

rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")


# This is used to perform card charge

payload = {
    "accountbank" => "044",
    "accountnumber" => "0690000033",
    "currency" => "NGN",
    "payment_type" =>  "account",
    "country" => "NG",
    "amount" => "100", 
    "email" => "mijux@xcodes.net",
    "phonenumber" => "08134836828",
    "firstname" => "Maestro",
    "lastname" => "Jolly",
    "IP" => "355426087298442",
    "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
    "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

charge_account = Account.new(rave)

response = charge_account.initiate_charge(payload)
print response

# perform validation if it is required

if response["validation_required"]
    response = charge_account.validate_charge(response["flwRef"], "12345")
    print response
end

# verify charge

response = charge_account.verify_charge(response["txRef"])
print response
```

## `Card.new(rave)`

To perform card transactions, instantiate the card object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.get_auth_type`
- `.update_payload`
- `.validate_charge`
- `.verify_charge`

### `.initiate_charge(payload)`

This function is called to initiate card transaction. The payload should be a ruby hash with card details. Its parameters should include the following:

- `cardno`,

- `cvv`,

- `expirymonth`,

- `expiryyear`,

- `amount`,

- `email`,

- `phonenumber`,

- `firstname`,

- `lastname`,

- `IP`

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample card charge call:

```ruby
response = charge_card.initiate_charge(payload)
```
You need to make this initial charge call to get the suggested_auth for the transaction.

#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "validation_required"=>true, "message"=>"AUTH_SUGGESTION", "suggested_auth"=>"PIN", "txRef"=>nil, "flwRef"=>nil, "chargeResponseCode"=>nil, "chargeResponseMessage"=>nil, "amount"=>nil, "currency"=>nil, "validateInstruction"=>nil, "paymentType"=>nil, "authModelUsed"=>nil, "authurl"=>nil
}

```

A `RaveServerError` is raised if there's an error with the card charge.

#### Sample error response if an exception is raised:

```ruby
{
    "status":"error","message":"Card number is invalid","data":{"code":"ERR","message":"Card number is invalid"
    }
}

```

### `.update_payload(suggested_auth, payload, pin or address)`

You need to update the payload with `pin` or `address` parameters depending on the `suggested_auth` returned from the initial charge call i.e `suggested_auth = response["suggested_auth"]` and passing it as a parameter of the `.get_auth_type(suggested_auth)` method.

If the `suggested_auth` returned is `pin`, update the payload with this method `charge_card.update_payload(suggested_auth, payload, pin: "CUSTOMER CARD PIN")`. 

If the `suggested_auth` returned is `address`, update the payload with this method `charge_card.update_payload(suggested_auth, payload, address:{"A RUBY HASH OF CUSTOMER'S BILLING ADDRESS"})`. 

This is what the ruby hash billing address consists:

- `billingzip`,

- `billingcity`,

- `billingaddress`,

- `billingstate`,

- `billingcountry`

After updating the payload, you will need to make the `.initiate_charge` call again with the updated payload, as displayed below:

```ruby
response = charge_card.initiate_charge(updated_payload)

```

This is a sample response returned after updating payload with suggested_auth `pin`:

```ruby
{
    "error"=>false, "status"=>"success", "validation_required"=>true, "message"=>"V-COMP", "suggested_auth"=>nil, "txRef"=>"MC-d8c02b9bdf21d02aa7ab276cda3177ae", "flwRef"=>"FLW-MOCK-68d8095eab1abdb69805be0a55d84630", "chargeResponseCode"=>"02", "chargeResponseMessage"=>"Please enter the OTP sent to your mobile number 080****** and email te**@rave**.com", "amount"=>10, "currency"=>"NGN", "validateInstruction"=>nil, "paymentType"=>"card", "authModelUsed"=>"PIN", "authurl"=>"N/A"
}
```

### `.validate_charge(flwRef, "OTP")`

After a successful charge, most times you will be asked to verify with OTP. To check if this is required, check the validation_required key in the response of the charge call i.e `response["validation_required"]` is equal to `true`.

In the case that an `authUrl` is returned from your charge call, you may skip the validation step and simply pass your authurl to the end-user as displayed below:

```ruby
authurl = response['authurl']
```

If validation is required by OTP, you need to pass the `flwRef` from the response of the charge call as well as the OTP.

A sample validate_charge call is:

```ruby
response = charge_card.validate_charge(response["flwRef"], "12345")
```

#### which returns:

It returns this response in ruby hash with the `txRef` and `flwRef` amongst its successful response:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-d8c02b9bdf21d02aa7ab276cda3177ae", "flwRef"=>"FLW-MOCK-68d8095eab1abdb69805be0a55d84630", "amount"=>10, "currency"=>"NGN", "chargeResponseCode"=>"00", "chargeResponseMessage"=>"Please enter the OTP sent to your mobile number 080****** and email te**@rave**.com"
}
```

If an error occurs during OTP validation, you will receive a response similiar to this:

```ruby
{
    "error"=>true, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-155418209b1cf2812da3ceb57e541ef0", "flwRef"=>"FLW-MOCK-35167122c73ccdd8ee796b71042af101", "amount"=>100, "currency"=>"NGN", "chargeResponseCode"=>"02", "chargeResponseMessage"=>"Pending OTP validation"
}
```
With `chargeResponseCode` still equals to `02` which means it didn't validate successfully and is till pending validation.

Otherwise if validation is successful using OTP, you will receive a response similar to this:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-eac8888322fa44343d1a3ed7c8025fde", "flwRef"=>"FLW-MOCK-01cb1be7b183cfdec0d5225316647378", "amount"=>10, "currency"=>"NGN", "chargeResponseCode"=>"00", "chargeResponseMessage"=>"Please enter the OTP sent to your mobile number 080****** and email te**@rave**.com"
}
```
With `chargeResponseCode` equals to `00` which means it validated successfully.

### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` or `validate_charge` call.

#### Sample verify_charge call:

```ruby
response = charge_card.verify_charge(response["txRef"])
```

#### which returns:

It returns this response in ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby
{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>362093, "txref"=>"MC-eac8888322fa44343d1a3ed7c8025fde", "flwref"=>"FLW-MOCK-01cb1be7b183cfdec0d5225316647378", "devicefingerprint"=>"69e6b7f0b72037aa8428b70fbe03986c", "cycle"=>"one-time", "amount"=>10, "currency"=>"NGN", "chargedamount"=>10, "appfee"=>0.14, "merchantfee"=>0, "merchantbearsfee"=>1, "chargecode"=>"00", "chargemessage"=>"Please enter the OTP sent to your mobile number 080****** and email te**@rave**.com", "authmodel"=>"PIN", "ip"=>"::ffff:10.69.80.227", "narration"=>"CARD Transaction ", "status"=>"successful", "vbvcode"=>"00", "vbvmessage"=>"successful", "authurl"=>"N/A", "acctcode"=>nil, "acctmessage"=>nil, "paymenttype"=>"card", "paymentid"=>"861", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>1, "createddayname"=>"MONDAY", "createdweek"=>51, "createdmonth"=>11, "createdmonthname"=>"DECEMBER", "createdquarter"=>4, "createdyear"=>2018, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>17, "createdminute"=>4, "createdpmam"=>"pm", "created"=>"2018-12-17T17:04:45.000Z", "customerid"=>51655, "custphone"=>"0902620185", "custnetworkprovider"=>"AIRTEL", "custname"=>"temi desola", "custemail"=>"user@gmail.com", "custemailprovider"=>"GMAIL", "custcreated"=>"2018-09-24T07:59:14.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"URF_1545066285779_8747935", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>"RV3154506628468675C4CD519A", "amountsettledforthistransaction"=>9.86, "card"=>{"expirymonth"=>"09", "expiryyear"=>"19", "cardBIN"=>"543889", "last4digits"=>"0229", "brand"=>"MASHREQ BANK CREDITSTANDARD", "card_tokens"=>[{"embedtoken"=>"flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k", "shortcode"=>"671c0", "expiry"=>"9999999999999"}], "type"=>"MASTERCARD", "life_time_token"=>"flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k"}, "meta"=>[{"id"=>1257583, "metaname"=>"flightID", "metavalue"=>"123949494DC", "createdAt"=>"2018-12-17T17:04:46.000Z", "updatedAt"=>"2018-12-17T17:04:46.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>362093}]}
}
```

If a transaction couldn't be verified successfully, `error` and `transaction_complete` would both come as `false`.

#### Full Card Transaction Flow:

```ruby

require_relative './lib/rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

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

response = charge_card.initiate_charge(payload)

print response

# update payload with suggested auth
if response["suggested_auth"]
    suggested_auth = response["suggested_auth"]
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

```

`NOTE:` You can tokenize a card after charging the card for the first time for subsequent transactions done with the card without having to send the card details everytime a transaction is done. The card token can be gotten from the `.verify_charge` response, here's how to get the card token from our sample verify response:

`response['card']['card_tokens']['embed_tokens']` which is similar to this: `flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k`

## `Preauth.new(rave)`

This is used to process a preauthorized card transaction.

Its functions includes:

- `.initiate_charge`
- `.capture`
- `.refund`
- `.void`
- `.verify_preauth`

The payload should be a ruby hash containing card information. It should have the following parameters:

- `token`,

- `country`,

- `amount`,

- `email`,

- `firstname`,

- `lastname`,

- `IP`,

- `txRef`,

- `currency`

`NOTE:` You need to use the same email used when charging the card for the first time to successfully charge the card.

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample preauth charge call:

```ruby
response = preauth.initiate_charge(payload)
```
#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"pending-capture", "message"=>"Charge success", "validation_required"=>false, "txRef"=>"MC-0df3e7e6cd58b226d4ba2a3d03dd200b", "flwRef"=>"FLW-PREAUTH-M03K-abdc01e69aa424b9e1ac44987ec21ec3", "amount"=>1000, "currency"=>"NGN", "paymentType"=>"card"
}

```

### `.capture(flwRef)`

The capture method is called after the preauth card has been charged. It takes in the `flwRef` from the charge response and call optionally take in amount less than the original amount authorised on the card as displayed below.

#### Sample capture call:

```ruby
response = preauth.capture(response["flwRef"], "30")
```

#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"successful", "message"=>"Capture complete", "validation_required"=>false, "txRef"=>"MC-0df3e7e6cd58b226d4ba2a3d03dd200b", "flwRef"=>"FLW-PREAUTH-M03K-abdc01e69aa424b9e1ac44987ec21ec3", "amount"=>30, "currency"=>"NGN", "chargeResponseCode"=>"00", "chargeResponseMessage"=>"Approved", "paymentType"=>"card"
}

```

### `.refund(flwRef)`

This is called to perform a `refund` of a preauth transaction.

#### Sample refund call:

```ruby
response = preauth.refund(response["flwRef"])

```

### `.void(flwRef)`

This is called to `void` a preauth transaction.

#### Sample void call:

```ruby
response = preauth.void(response["flwRef"])

```

### `.verify_preauth(txRef)`

The verify_preauth method can be called after capture is successfully completed by passing the `txRef` from the `charge` or `capture` response as its argument as shown below.

#### Sample verify_preauth call:

```ruby
response = preauth.verify_preauth(response["txRef"])

```

#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>370365, "txref"=>"MC-0df3e7e6cd58b226d4ba2a3d03dd200b", "flwref"=>"FLW-PREAUTH-M03K-abdc01e69aa424b9e1ac44987ec21ec3", "devicefingerprint"=>"N/A", "cycle"=>"one-time", "amount"=>30, "currency"=>"NGN", "chargedamount"=>30.42, "appfee"=>0.42, "merchantfee"=>0, "merchantbearsfee"=>0, "chargecode"=>"00", "chargemessage"=>"Approved", "authmodel"=>"noauth", "ip"=>"190.233.222.1", "narration"=>"TOKEN CHARGE", "status"=>"successful", "vbvcode"=>"00", "vbvmessage"=>"Approved", "authurl"=>"N/A", "acctcode"=>"FLWPREAUTH-M03K-CP-1545740097601", "acctmessage"=>"CAPTURE
REFERENCE", "paymenttype"=>"card", "paymentid"=>"861", "fraudstatus"=>"ok", "chargetype"=>"preauth", "createdday"=>2, "createddayname"=>"TUESDAY", "createdweek"=>52, "createdmonth"=>11, "createdmonthname"=>"DECEMBER", "createdquarter"=>4, "createdyear"=>2018, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>12, "createdminute"=>14, "createdpmam"=>"pm", "created"=>"2018-12-25T12:14:54.000Z", "customerid"=>51655, "custphone"=>"0902620185", "custnetworkprovider"=>"AIRTEL", "custname"=>"temi desola", "custemail"=>"user@gmail.com", "custemailprovider"=>"GMAIL", "custcreated"=>"2018-09-24T07:59:14.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>nil, "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>nil, "amountsettledforthistransaction"=>30, "card"=>{"expirymonth"=>"09", "expiryyear"=>"19", "cardBIN"=>"543889", "last4digits"=>"0229", "brand"=>"MASHREQ BANK CREDITSTANDARD", "card_tokens"=>[{"embedtoken"=>"flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k", "shortcode"=>"671c0", "expiry"=>"9999999999999"}], "type"=>"MASTERCARD", "life_time_token"=>"flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k"}, "meta"=>[{"id"=>1259456, "metaname"=>"trxauthorizeid", "metavalue"=>"M03K-i0-8673be673b828e4b2863ef6d39d56cce", "createdAt"=>"2018-12-25T12:14:54.000Z", "updatedAt"=>"2018-12-25T12:14:54.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}, {"id"=>1259457, "metaname"=>"trxreference", "metavalue"=>"FLW-PREAUTH-M03K-abdc01e69aa424b9e1ac44987ec21ec3", "createdAt"=>"2018-12-25T12:14:54.000Z", "updatedAt"=>"2018-12-25T12:14:54.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}, {"id"=>1259458, "metaname"=>"old_amount", "metavalue"=>"1000", "createdAt"=>"2018-12-25T12:14:57.000Z", "updatedAt"=>"2018-12-25T12:14:57.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}, {"id"=>1259459, "metaname"=>"old_charged_amount", "metavalue"=>"1000", "createdAt"=>"2018-12-25T12:14:57.000Z", "updatedAt"=>"2018-12-25T12:14:57.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}, {"id"=>1259460, "metaname"=>"old_fee", "metavalue"=>"", "createdAt"=>"2018-12-25T12:14:57.000Z", "updatedAt"=>"2018-12-25T12:14:57.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}, {"id"=>1259461, "metaname"=>"old_merchant_fee",
"metavalue"=>"0", "createdAt"=>"2018-12-25T12:14:57.000Z", "updatedAt"=>"2018-12-25T12:14:57.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}]}
}

```

#### Full Preauth Transaction Flow:

```ruby
require_relative './lib/rave_ruby'


# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")


# This is the payload for preauth charge

payload = {
    "token" => "flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k",
    "country" => "NG",
    "amount" => "1000",
    "email" => "user@gmail.com",
    "firstname" => "temi",
    "lastname" => "Oyekole",
    "IP" => "190.233.222.1",
    "currency" => "NGN",
}


# Instantiate the preauth object
preauth = Preauth.new(rave)

# Perform a charge with the card token from the saved from the card charge
response = preauth.initiate_charge(payload)
print response

# Perform capture 
response = preauth.capture(response["flwRef"], "30")
print response

# Perform a refund
# response = preauth.refund(response["flwRef"])
# print response

# Void transaction
# response = preauth.void(response["flwRef"])
# print response

# Verify transaction
response = preauth.verify_preauth(response["txRef"])
print response


```


## `MobileMoney.new(rave)`

To perform ghana mobile money transactions, instantiate the mobile money object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.verify_charge`

### `.initiate_charge(payload)`

This function is called to initiate mobile money transaction. The payload should be a ruby hash with mobile money details. Its parameters should include the following:

- `amount`,

- `email`,

- `phonenumber`,

- `network`,

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample mobile money charge call:

```ruby
response = charge_mobile_money.initiate_charge(payload)
```
#### which returns:

It returns this response in ruby hash. A sample response:

```ruby

{
    "error"=>false, "status"=>"success-pending-validation", "validation_required"=>true, "txRef"=>"MC-83d9405416ff2a7312d8e3d5fceb3d52", "flwRef"=>"flwm3s4m0c1545818908919", "amount"=>50, "currency"=>"GHS", "validateInstruction"=>nil, "authModelUsed"=>"MOBILEMONEY", "paymentType"=>"mobilemoneygh"
}

```

### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` call.

#### Sample verify_charge call:

```ruby
response = charge_mobile_money.verify_charge(response["txRef"])
```

#### which returns:

It returns this response in ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby

{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>371101, "txref"=>"MC-1c2a66b7bb6e55c254cad2a61b0ea47b", "flwref"=>"flwm3s4m0c1545824547181", "devicefingerprint"=>"N/A", "cycle"=>"one-time", "amount"=>50, "currency"=>"GHS", "chargedamount"=>50, "appfee"=>0.7, "merchantfee"=>0, "merchantbearsfee"=>1, "chargecode"=>"00", "chargemessage"=>"Pending Payment Validation", "authmodel"=>"MOBILEMONEY",
"ip"=>"::ffff:10.37.131.195", "narration"=>"Simply Recharge", "status"=>"successful", "vbvcode"=>"N/A", "vbvmessage"=>"N/A", "authurl"=>"NO-URL", "acctcode"=>"00", "acctmessage"=>"Approved", "paymenttype"=>"mobilemoneygh", "paymentid"=>"N/A", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>3, "createddayname"=>"WEDNESDAY", "createdweek"=>52, "createdmonth"=>11, "createdmonthname"=>"DECEMBER", "createdquarter"=>4, "createdyear"=>2018, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>11, "createdminute"=>42, "createdpmam"=>"am", "created"=>"2018-12-26T11:42:26.000Z", "customerid"=>59839, "custphone"=>"08082000503", "custnetworkprovider"=>"AIRTEL", "custname"=>"Anonymous Customer", "custemail"=>"cezojejaze@nyrmusic.com", "custemailprovider"=>"COMPANY EMAIL", "custcreated"=>"2018-11-01T17:26:40.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"URF_MMGH_1545824546523_5297935", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>nil, "amountsettledforthistransaction"=>49.3, "meta"=>[]}

}
```

If a transaction couldn't be verified successfully, `error` and `transaction_complete` would both come as `false`.

#### Full Mobile Money Transaction Flow:

```ruby

require_relative './lib/rave_ruby'


# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")


# This is used to perform mobile money charge

payload = {
    "amount" => "50",
    "email" => "cezojejaze@nyrmusic.com",
    "phonenumber" => "08082000503",
    "network" => "MTN",
    "redirect_url" => "https://webhook.site/6eb017d1-c605-4faa-b543-949712931895",
    "IP" => ""
}

# To initiate mobile money transaction
charge_mobile_money = MobileMoney.new(rave)

response = charge_mobile_money.initiate_charge(payload)

print response

# To verify the mobile money transaction
response = charge_mobile_money.verify_charge(response["txRef"])

print response

```

## `Mpesa.new(rave)`

To perform mpesa transactions, instantiate the mpesa object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.verify_charge`

### `.initiate_charge(payload)`

This function is called to initiate mpesa transaction. The payload should be a ruby hash with mpesa details. Its parameters should include the following:

- `amount`,

- `email`,

- `phonenumber`,


You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample mpesa charge call:

```ruby
response = charge_mpesa.initiate_charge(payload)
```
#### which returns:

It returns this response in ruby hash. A sample response:

```ruby

{
    "error"=>false, "status"=>"pending", "validation_required"=>true, "txRef"=>"MC-0ad3251bcdde39b16c225e9fc46e992c", "flwRef"=>"8833703548", "amount"=>"100", "currency"=>"KES", "paymentType"=>"mpesa"
}

```

### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` call.

#### Sample verify_charge call:

```ruby
response = charge_mpesa.verify_charge(response["txRef"])
```

#### which returns:

It returns this response in ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby

{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>372498, "txref"=>"MC-0ad3251bcdde39b16c225e9fc46e992c", "flwref"=>"8833703548", "devicefingerprint"=>"N/A", "cycle"=>"one-time", "amount"=>100, "currency"=>"KES", "chargedamount"=>100, "appfee"=>1.4, "merchantfee"=>0, "merchantbearsfee"=>0, "chargecode"=>"00", "chargemessage"=>nil, "authmodel"=>"VBVSECURECODE", "ip"=>"::ffff:10.43.205.176", "narration"=>"funds payment", "status"=>"successful", "vbvcode"=>"N/A", "vbvmessage"=>"N/A", "authurl"=>"N/A", "acctcode"=>"00", "acctmessage"=>"MPESA COMPLETED", "paymenttype"=>"mpesa", "paymentid"=>"N/A", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>4, "createddayname"=>"THURSDAY", "createdweek"=>52, "createdmonth"=>11, "createdmonthname"=>"DECEMBER", "createdquarter"=>4, "createdyear"=>2018, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>18, "createdminute"=>50, "createdpmam"=>"pm", "created"=>"2018-12-27T18:50:51.000Z", "customerid"=>65231, "custphone"=>"0926420185", "custnetworkprovider"=>"UNKNOWN PROVIDER", "custname"=>"Anonymous customer", "custemail"=>"user@exampe.com", "custemailprovider"=>"COMPANY EMAIL", "custcreated"=>"2018-11-27T15:23:38.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1,
"acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"8833703548", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>nil, "amountsettledforthistransaction"=>98.6, "meta"=>[{"id"=>1259900, "metaname"=>"MPESARESPONSE", "metavalue"=>"{\"billrefnumber\":\"8833703548\",\"transactionamount\":\"100.00\",\"transactionid\":372498,\"type\":\"mpesa\"}", "createdAt"=>"2018-12-27T18:50:56.000Z", "updatedAt"=>"2018-12-27T18:50:56.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>372498}]}
}
```

If a transaction couldn't be verified successfully, `error` and `transaction_complete` would both come as `false`.

#### Full Mpesa Transaction Flow:

```ruby

require_relative './lib/rave_ruby'


# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")


# This is used to perform mpesa charge

payload = {
    "amount" => "100",
    "phonenumber" => "0926420185",
    "email" => "user@exampe.com",
    "IP" => "40.14.290",
    "narration" => "funds payment",
}

# To initiate mpesa transaction
charge_mpesa = Mpesa.new(rave)

response = charge_mpesa.initiate_charge(payload)

print response

# To verify the mpesa transaction
response = charge_mpesa.verify_charge(response["txRef"])

print response

```

## `SubAccount.new(rave)`

This is used to process and manage subaccount flow. Instantiate the subaccount object and pass rave object as its argument.

Its functions includes:

- `.create_subaccount`
- `.list_subaccounts`
- `.fetch_subaccount`
- `.delete_subaccount`

### `.create_subaccount(payload)`

This function is called to initiate subaccount transaction. The payload should be a ruby hash with the subaccount details. Its parameters should include the following:

- `account_bank`,

- `account_number`,

- `business_name`,

- `business_email`,

- `business_contact`,

- `business_contact_mobile`,

- `business_mobile`,

- `split_type`,

- `split_value`,

#### `NOTE:` 

- split_type can be set as percentage or flat when set as percentage it means you want to take a percentage fee on all transactions, and vice versa for flat this means you want to take a flat fee on every transaction.

- split_value can be a percentage value or flat value depending on what was set on split_type.

#### Sample create_subaccount call:

```ruby
response = subaccount.create_subaccount(payload)
```

#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "id"=>350, "data"=>{"id"=>350, "account_number"=>"0690000033", "account_bank"=>"044", "business_name"=>"Test Stores", "fullname"=>"Bale Gary", "date_created"=>"2018-12-28T16:20:40.000Z", "meta"=>[{"metaname"=>"MarketplaceID", "metavalue"=>"ggs-920900"}], "account_id"=>14101, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>3000, "subaccount_id"=>"RS_CC09B109AA8F0CA5D9CE067492C548DA", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}
}

```

### `.list_subaccounts`

This function is called to list all subaccounts under an account. The function can be initiated by calling it on a subaccount object.

#### Sample list_subaccount call:

```ruby
response = subaccount.list_subaccounts
```

#### which returns:

It returns this response in ruby hash. A sample response:

```ruby

{
    "error"=>false, "data"=>{"status"=>"success", "message"=>"SUBACCOUNTS", "data"=>{"page_info"=>{"total"=>6, "current_page"=>1, "total_pages"=>1}, "subaccounts"=>[{"id"=>350, "account_number"=>"0690000033", "account_bank"=>"044", "business_name"=>"Test Stores", "fullname"=>"Bale Gary", "date_created"=>"2018-12-28T16:20:40.000Z", "meta"=>[{"metaname"=>"MarketplaceID", "metavalue"=>"ggs-920900"}], "account_id"=>14101, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>3000, "subaccount_id"=>"RS_CC09B109AA8F0CA5D9CE067492C548DA", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}, {"id"=>344, "account_number"=>"0690000041", "account_bank"=>"044", "business_name"=>"Sub 2", "fullname"=>"Alexis Rogers", "date_created"=>"2018-12-21T11:39:09.000Z", "meta"=>nil, "account_id"=>13633, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>100, "subaccount_id"=>"RS_A75DB3502DDE69D07834A770888C26EE", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}, {"id"=>343, "account_number"=>"0690000031", "account_bank"=>"044", "business_name"=>"Sub 1", "fullname"=>"Forrest Green", "date_created"=>"2018-12-21T11:37:00.000Z", "meta"=>nil, "account_id"=>13632, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>40, "subaccount_id"=>"RS_D073562598485BCEEB0A5287F99623FC", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}, {"id"=>325, "account_number"=>"0690000032", "account_bank"=>"044", "business_name"=>"Jake Stores", "fullname"=>"Pastor Bright", "date_created"=>"2018-12-13T20:34:51.000Z", "meta"=>[{"metaname"=>"MarketplaceID", "metavalue"=>"ggs-920900"}], "account_id"=>13212, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>3000, "subaccount_id"=>"RS_4091F27A32D176070DA3CAF018E3450E", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}, {"id"=>126, "account_number"=>"0690000037", "account_bank"=>"044", "business_name"=>"Sub Account 2", "fullname"=>"Ibra Mili", "date_created"=>"2018-10-12T15:08:48.000Z", "meta"=>nil, "account_id"=>9522, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>500, "subaccount_id"=>"RS_AE7B0858E69C6BFEB5C143CAA0A13FC3", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}, {"id"=>125, "account_number"=>"0690000035", "account_bank"=>"044", "business_name"=>"sub account 1", "fullname"=>"Peter Crouch", "date_created"=>"2018-10-12T14:39:41.000Z", "meta"=>nil, "account_id"=>9520, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>100, "subaccount_id"=>"RS_2B1B3B6985172B9046A58DCA9E9026E0", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}]}}
}

```

### `.fetch_subaccount(subaccount_id)`

This function is used to fetch a subaccount details by taking in the subaccount id as its argument.

#### Sample fetch_subaccount call:

```ruby
response = subaccount.fetch_subaccount("RS_CC09B109AA8F0CA5D9CE067492C548DA")
```

#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"status"=>"success", "message"=>"SUBACCOUNT", "data"=>{"id"=>350, "account_number"=>"0690000033", "account_bank"=>"044", "business_name"=>"Test Stores", "fullname"=>"Bale Gary", "date_created"=>"2018-12-28T16:20:40.000Z", "meta"=>[{"metaname"=>"MarketplaceID", "metavalue"=>"ggs-920900"}], "account_id"=>14101, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>3000, "subaccount_id"=>"RS_CC09B109AA8F0CA5D9CE067492C548DA", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}}
}
```

### `.delete_subaccount(subaccount_id)`

This function is used to delete a subaccount by taking in the subaccount id as its argument.

#### Sample delete_subaccount call:

```ruby
response = subaccount.delete_subaccount("RS_CC09B109AA8F0CA5D9CE067492C548DA")
```

#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"status"=>"success", "message"=>"SUBACCOUNT-DELETED", "data"=>"Deleted"}
}
```

#### Full SubAccount Flow:

```ruby

require_relative './lib/rave_ruby'


# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")


# This is the payload for sub account creation

payload = {
	"account_bank" => "044",
	"account_number" => "0690000033",
	"business_name" => "Test Stores",
	"business_email" => "test@test.com",
	"business_contact" => "john doe",
	"business_contact_mobile" => "09083772",
	"business_mobile" => "0188883882",
    "split_type" => "flat",
    "split_value" => 3000,
	"meta" => [{"metaname": "MarketplaceID", "metavalue": "ggs-920900"}]
}

# Instantiate the subaccount object
subaccount = SubAccount.new(rave)

# This is used to create a subaccount
response = subaccount.create_subaccount(payload)
print response

# This is used to list all subaccounts
response = subaccount.list_subaccounts
print response

# This is used to fetch a subaccount by taking in the subaccount id
response = subaccount.fetch_subaccount("RS_A59429B9C94C5A862F731711290B9ADD")
print response

# This is used to delete a subaccount by taking in the subaccount id
response = subaccount.delete_subaccount("RS_A59429B9C94C5A862F731711290B9ADD")
print response

```

## `PaymentPlan.new(rave)`

This is used to process and manage payment plan flow. Instantiate the paymentplan object and pass rave object as its argument.

Its functions includes:

- `.create_payment_plan`
- `.list_payment_plans`
- `.fetch_payment_plan`
- `.edit_payment_plan`
- `.cancel_payment_plan`

### `.create_payment_plan(payload)`

This function is called to initiate payment plan transaction. The payload should be a ruby hash with the payment plan details. Its parameters should include the following:

- `amount`,

- `name`,

- `interval`,

- `duration`,

#### `NOTE:` 

- amount: this is the amount for the plan

- name: This is what would appear on the subscription reminder email

- interval: This are the charge intervals possible values are:

```
daily;
weekly;
monthly;
yearly;
quarterly;
bi-anually;
every 2 days;
every 90 days;
every 5 weeks;
every 12 months;
every 6 years;
every x y (where x is a number and y is the period e.g. every 5 months)

```
- duration: This is the frequency, it is numeric, e.g. if set to 5 and intervals is set to monthly you would be charged 5 months, and then the subscription stops.

`If duration is not passed, any subscribed customer will be charged indefinitely.`

#### Sample create_payment_plan call:

```ruby
response = payment_plan.create_payment_plan(payload)
```

#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"id"=>1298, "name"=>"New Test Plan", "amount"=>1000, "interval"=>"monthly", "duration"=>5, "status"=>"active",
"currency"=>"NGN", "plan_token"=>"rpp_9002500b0440b470f02c", "date_created"=>"2018-12-30T10:54:06.000Z"}
}

```

### `.list_payment_plans`

This function is called to list all payment plans under an account. The function can be initiated by calling it on a paymentplan object.

#### Sample list_payment_plans call:

```ruby
response = payment_plan.list_payment_plans
```

#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"QUERIED-PAYMENTPLANS", "data"=>{"page_info"=>{"total"=>21, "current_page"=>1, "total_pages"=>3}, "paymentplans"=>[{"id"=>1298, "name"=>"New Test Plan", "amount"=>1000, "interval"=>"monthly", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_9002500b0440b470f02c", "date_created"=>"2018-12-30T10:54:06.000Z"}, {"id"=>1225, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_6da8f78957b92b3e9128", "date_created"=>"2018-12-12T20:22:43.000Z"}, {"id"=>1196, "name"=>"Jack's Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_49ae581c01d998841116", "date_created"=>"2018-12-04T16:42:58.000Z"}, {"id"=>1195, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_7156462224bc29c5e429", "date_created"=>"2018-12-04T16:39:41.000Z"}, {"id"=>1194, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_a361053c176ae01ae6ea", "date_created"=>"2018-12-04T16:39:14.000Z"}, {"id"=>1193, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_4a6ca4bedef850362dbd", "date_created"=>"2018-12-04T16:34:10.000Z"}, {"id"=>1192, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_7185c10c96eae1b62c92", "date_created"=>"2018-12-04T16:33:22.000Z"}, {"id"=>1191, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_c0bcf71beb2d048d0883", "date_created"=>"2018-12-04T16:32:00.000Z"}, {"id"=>1190, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_607c22f130a5a90e51af", "date_created"=>"2018-12-04T16:27:27.000Z"}, {"id"=>1154, "name"=>"N/A", "amount"=>0, "interval"=>"daily", "duration"=>0, "status"=>"cancelled", "currency"=>"NGN", "plan_token"=>"rpp_cb2ec11390fd718b6eb0", "date_created"=>"2018-11-27T11:31:21.000Z"}]}
}
```

### `.fetch_payment_plan(payment_plan_id, payment_plan_name)`

This function is used to fetch a payment plan details by taking in the payment plan id and payment plan name as its argument.

#### Sample fetch_payment_plan call:

```ruby
response = payment_plan.fetch_payment_plan("1298", "New Test Plan")
```

#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"page_info"=>{"total"=>1, "current_page"=>1, "total_pages"=>1}, "paymentplans"=>[{"id"=>1298, "name"=>"New Test Plan", "amount"=>1000, "interval"=>"monthly", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_9002500b0440b470f02c", "date_created"=>"2018-12-30T10:54:06.000Z"}]}
}
```

### `.edit_payment_plan(payment_plan_id, payment_plan_name)`

This function is used to edit a payment plan by taking in the the payment plan id and payment plan name as its argument.

#### Sample edit_payment_plan call:

```ruby

response = payment_plan.edit_payment_plan("1298", {"name" => "Updated Test Plan", "status" => "active"})
```

#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"id"=>1298, "name"=>"Updated Test Plan", "uuid"=>"rpp_9002500b0440b470f02c", "status"=>"active", "start"=>nil,
"stop"=>nil, "initial_charge_amount"=>nil, "currency"=>"NGN", "amount"=>1000, "duration"=>5, "interval"=>"monthly", "createdAt"=>"2018-12-30T10:54:06.000Z", "updatedAt"=>"2018-12-30T11:26:17.000Z", "deletedAt"=>nil, "AccountId"=>3328, "paymentpageId"=>nil}
}
```

### `.cancel_payment_plan("payment_plan_id")`

This function is used to cancel a payment plan by taking in the payment plan id as its argument.

#### Sample cancel_payment_plan call:

```ruby
response = payment_plan.cancel_payment_plan("1298")
```
#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"id"=>1298, "name"=>"Updated Test Plan", "uuid"=>"rpp_9002500b0440b470f02c", "status"=>"cancelled", "start"=>nil, "stop"=>nil, "initial_charge_amount"=>nil, "currency"=>"NGN", "amount"=>1000, "duration"=>5, "interval"=>"monthly", "createdAt"=>"2018-12-30T10:54:06.000Z", "updatedAt"=>"2018-12-30T11:44:55.000Z", "deletedAt"=>nil, "AccountId"=>3328, "paymentpageId"=>nil}
}
```

#### Full PaymentPlan Flow:

```ruby

require_relative './lib/rave_ruby'


# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# payment plan payload
payload = {
    "amount" => 1000,
    "name" => "New Test Plan",
    "interval" => "monthly",
    "duration" => 5
}


# create an instance of the payment plan object
payment_plan = PaymentPlan.new(rave)

# method to create payment plan
# response = payment_plan.create_payment_plan(payload)
# print response

# # method to list all payment plan
# response = payment_plan.list_payment_plans
# print response

# method to fetch payment plan
response = payment_plan.fetch_payment_plan("1298", "New Test Plan")
print response


# method to edit payment plan
response = payment_plan.edit_payment_plan("1298", {"name" => "Updated Test Plan", "status" => "active"})
print response

# method to cancel payment plan
response = payment_plan.cancel_payment_plan("1298")
print response

```
## `Subscription.new(rave)`

This is used to process and manage subscription flow. Instantiate the subscription object and pass rave object as its argument.

Its functions includes:

- `.list_all_subscription`
- `.fetch_subscription`
- `.activate_subscription`
- `.cancel_subscription`

### `.list_all_subscription`

This function is called to fetch and list all subscription.

#### Sample list_all_subscription call:

```ruby
response = subscription.list_all_subscription
```
#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"SUBSCRIPTIONS-FETCHED", "data"=>{"page_info"=>{"total"=>0, "current_page"=>0, "total_pages"=>0}, "plansubscriptions"=>[]}, "plansubscriptions"=>[]
}
```

### `.fetch_subscription("subscription_id", "subscription_email")`

This function is called to fetch a single subscription taking the subscription id and subscription email as its arguments.

#### Sample fetch_subscription call:

```ruby
response = subscription.fetch_subscription("1", "test@test.com")
```
#### which returns:

It returns this response in ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"SUBSCRIPTIONS-FETCHED", "data"=>{"page_info"=>{"total"=>0, "current_page"=>0, "total_pages"=>0}, "plansubscriptions"=>[]}
}
```

### `.activate_subscription("subscription_id")`

This function is called to activate a subscription taking the subscription id as its argument.

#### Sample activate_subscription call:

```ruby
response = subscription.activate_subscription(1533)
```
#### which returns:

It returns this response in ruby hash. A sample response:

```ruby

```

### `.cancel_subscription("subscription_id")`

This function is called to cancel a subscription taking the subscription id as its argument.

#### Sample cancel_subscription call:

```ruby
response = subscription.cancel_subscription(1533)
```
#### which returns:

It returns this response in ruby hash. A sample response:

```ruby

```

### Full Subscription Flow

```ruby
require_relative './lib/rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

subscription = Subscription.new(rave)
response = subscription.list_all_subscription
print response
response = subscription.fetch_subscription("1", "test@test.com")
print response
response = subscription.activate_subscription(1533)
print response
response = subscription.cancel_subscription(1533)
print response
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rave_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RaveRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rave_ruby/blob/master/CODE_OF_CONDUCT.md).
