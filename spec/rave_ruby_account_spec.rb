require 'spec_helper'
require "rave_ruby/rave_objects/account"

test_public_key = "FLWPUBK-92e93a5c487ad64939327052e113c813-X"
test_secret_key = "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X"

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

RSpec.describe Account do

  rave = RaveRuby.new(test_public_key, test_secret_key)
  charge_account =  Account.new(rave)

  context "when a merchant tries to charge a customers account" do

    it "should return account object" do
      expect(charge_account.nil?).to eq(false)
    end

    it 'should successfully charge an account and return true for validation required' do
      response = charge_account.initiate_charge(payload)
      expect(response["validation_required"]).to eq(true)
    end

    it 'should return chargeResponseCode 00 after successfully validating with flwRef and OTP' do
      response = charge_account.initiate_charge(payload)
      response = charge_account.validate_charge(response["flwRef"], "12345")
      expect(response["chargeResponseCode"]).to eq("00")
    end

    it 'should return chargecode 00 after successfully verifying a account transaction with txRef' do
      response = charge_account.initiate_charge(payload)
      response = charge_account.validate_charge(response["flwRef"], "12345")
      response = charge_account.verify_charge(response["txRef"])
      expect(response["data"]["chargecode"]).to eq("00")
    end

  end

  # it "should raise RaveBadKeyError" do
  #   rave = RaveRuby.new(test_public_key, test_secret_key)
  #   expect(rave.public_key[0..7]).to eq("FLWPUBK-")
  # end
  
end
