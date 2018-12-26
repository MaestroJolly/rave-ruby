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

- [Account.new(rave)](#account.new(rave))
- [Card.new(rave)](#cardnewrave)
- [Preauth.new(rave)](#preauth.new(rave))
- [MobileMoney.new(rave)](#mobilemoney.new(rave))
- [Mpesa.new(rave)](#mpesa.new(rave))
- [SubAccount.new(rave)](#subaccount.(rave))
- [PaymentPlan.new(rave)](#paymentplan.new(rave))
- [Subscription.new(rave)](#subscription.new(rave))
- [Transfer.new(rave)](#transfer.new(rave))
- [UgandaMobileMoney.new(rave)](#ugandamobilemoney.new(rave))
- [Ussd.new(rave)](#ussd.new(rave))
- [ListBanks.new(rave)](#listbanks.new(rave))

### `Account.new(rave)`

To perform account transactions, instantiate the account object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.validate_charge`
- `.verify_charge`

#### `.initiate_charge(payload)`

This function is called to initiate account transaction. The payload should be a ruby hash with account details. Its parameters should include the following:

- `accountbank`,

- `accountnumber`,

- `amount`,

- `email`,

- `phonenumber`,

- `IP`

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Here's a sample account charge call:

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

#### Here's a sample error response if an exception is raised:

```ruby
{
    "status":"error","message":"Sorry that account number is invalid. Please check and try again","data":{"code":"FLW_ERR","message":"Sorry that account number is invalid. Please check and try again","err_tx":{"id":360210,"flwRef":"ACHG-1544910130710","chargeResponseCode":"RR","chargeResponseMessage":"Sorry that account number is invalid. Please check and try again","status":"failed","merchantbearsfee":1,"appfee":"1.4","merchantfee":"0","charged_amount":"100.00"
}}}

```

#### `.validate_charge(flwRef, "OTP")`

After a successful charge, most times you will be asked to verify with OTP. To check if this is required, check the validation_required key in the response of the charge call i.e `response["validation_required"]` is equal to `true`.

In the case that an `authUrl` is returned from your charge call, you may skip the validation step and simply pass your authurl to the end-user as displayed below:

```ruby
authurl = response['authurl']
```

If validation is required by OTP, you need to pass the `flwRef` from the response of the charge call as well as the OTP.

A sample validate_charge call is:

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

#### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` or `validate_charge` call.

A sample verify_charge call:

```ruby
response = charge_account.verify_charge(response["txRef"])
```

### which returns:

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

### `Card.new(rave)`

To perform card transactions, instantiate the card object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.get_auth_type`
- `.update_payload`
- `.validate_charge`
- `.verify_charge`

#### `.initiate_charge(payload)`

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

#### Here's a sample card charge call:

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

#### Here's a sample error response if an exception is raised:

```ruby
{
    "status":"error","message":"Card number is invalid","data":{"code":"ERR","message":"Card number is invalid"
    }
}

```

#### `.update_payload(suggested_auth, payload, pin or address)`

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

#### `.validate_charge(flwRef, "OTP")`

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

#### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` or `validate_charge` call.

A sample verify_charge call:

```ruby
response = charge_card.verify_charge(response["txRef"])
```

### which returns:

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

### `Preauth.new(rave)`

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

#### Here's a sample preauth charge call:

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

#### `.capture(flwRef)`

The capture method is called after the preauth card has been charged. It takes in the `flwRef` from the charge response and call optionally take in amount less than the original amount authorised on the card as displayed below.

#### Here's a sample capture call:

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

#### `.refund(flwRef)`

This is called to perform a `refund` of a preauth transaction.

#### Here's a sample refund call:

```ruby
response = preauth.refund(response["flwRef"])

```

#### `.void(flwRef)`

This is called to `void` a preauth transaction.

#### Here's a sample void call:

```ruby
response = preauth.void(response["flwRef"])

```

#### `.verify_preauth(txRef)`

The verify_preauth method can be called after capture is successfully completed by passing the `txRef` from the `charge` or `capture` response as its argument as shown below.

#### A sample verify_preauth call:

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


### `MobileMoney.new(rave)`

To perform ghana mobile money transactions, instantiate the mobile money object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.verify_charge`

#### `.initiate_charge(payload)`

This function is called to initiate mobile money transaction. The payload should be a ruby hash with mobile money details. Its parameters should include the following:

- `amount`,

- `email`,

- `phonenumber`,

- `network`,

- `IP`,

- `redirect_url`

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Here's a sample mobile money charge call:

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

#### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` call.

A sample verify_charge call:

```ruby
response = charge_mobile_money.verify_charge(response["txRef"])
```

### which returns:

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

### `Mpesa.new(rave)`


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rave_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RaveRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rave_ruby/blob/master/CODE_OF_CONDUCT.md).
