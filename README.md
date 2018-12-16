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
- [Card.new(rave)](#card.new())
- [MobileMoney.new(rave)](#mobilemoney.new(rave))
- [Mpesa.new(rave)](mpesa.new(rave))
- [Preauth.new(rave)](#preauth.new(rave))
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

- `initiate_charge`
- `validate_charge`
- `verify_charge`

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
#### returns:

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

#### `.validate_charge(response['flwRef'], "OTP")`

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

#### returns:

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

#### `.verify_charge(response["txRef"])`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` or `validate_charge` call.

A sample verify_charge call:

```ruby
response = charge_account.verify_charge(response["txRef"])
```

#### returns:

It returns this response in ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby
{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>360744, "txref"=>"MC-c0c707a798de82f34b937e6126844d6c", "flwref"=>"ACHG-1544963949493", "devicefingerprint"=>"69e6b7f0b72037aa8428b70fbe03986c", "cycle"=>"one-time", "amount"=>100, "currency"=>"NGN", "chargedamount"=>100, "appfee"=>1.4, "merchantfee"=>0, "merchantbearsfee"=>1, "chargecode"=>"00", "chargemessage"=>"Pending OTP validation", "authmodel"=>"AUTH", "ip"=>"::ffff:10.11.193.41", "narration"=>"Simply Recharge", "status"=>"successful",
    "vbvcode"=>"N/A", "vbvmessage"=>"N/A", "authurl"=>"NO-URL", "acctcode"=>"00", "acctmessage"=>"Approved Or Completed Successfully", "paymenttype"=>"account", "paymentid"=>"90", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>0, "createddayname"=>"SUNDAY", "createdweek"=>50, "createdmonth"=>11, "createdmonthname"=>"DECEMBER", "createdquarter"=>4, "createdyear"=>2018, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>12, "createdminute"=>39, "createdpmam"=>"pm", "created"=>"2018-12-16T12:39:08.000Z", "customerid"=>64794, "custphone"=>"08134836828", "custnetworkprovider"=>"MTN", "custname"=>"ifunanya Ikemma", "custemail"=>"mijux@xcodes.net", "custemailprovider"=>"COMPANY EMAIL", "custcreated"=>"2018-11-26T11:35:24.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"URF_1544963948269_113435", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>"RV31544963947776E1DB61E313", "amountsettledforthistransaction"=>98.6, "account"=>{"id"=>90, "account_number"=>"0690000033", "account_bank"=>"044", "first_name"=>"NO-NAME", "last_name"=>"NO-LNAME", "account_is_blacklisted"=>0, "createdAt"=>"2017-04-26T12:54:22.000Z", "updatedAt"=>"2018-12-16T12:39:23.000Z", "deletedAt"=>nil, "account_token"=>{"token"=>"flw-t03a483b4eecf61cda-k3n-mock"}}, "meta"=>[]}
}

```

If a transaction couldn't be verified successfully, `error` and `transaction_complete` would come as `false` and `true` respectively.

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




## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rave_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RaveRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rave_ruby/blob/master/CODE_OF_CONDUCT.md).
