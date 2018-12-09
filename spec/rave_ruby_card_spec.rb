require 'spec_helper'
require "rave_ruby/rave_objects/card"

test_public_key = "FLWPUBK-92e93a5c487ad64939327052e113c813-X"
test_secret_key = "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X"

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

pin_payload = {
  "cardno" => "5438898014560229",
  "cvv" => "890",
  "expirymonth" => "09",
  "expiryyear" => "19",
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "10",
  "email" => "user@gmail.com",
  "phonenumber" => "0902620185",
  "suggested_auth" => "PIN",
  "pin" => "3310",
  "firstname" => "temi",
  "lastname" => "desola",
  "IP" => "355426087298442",
  "meta" => [{"metaname": "flightID", "metavalue": "123949494DC"}],
  "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
  "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

avs_payload = {
  "cardno" => "4556052704172643",
  "cvv" => "828",
  "expirymonth" => "09",
  "expiryyear" => "19",
  "currency" => "USD",
  "country" => "NG",
  "amount" => "10",
  "email" => "user@gmail.com",
  "phonenumber" => "0902620185",
  "firstname" => "temi",
  "lastname" => "desola",
  "IP" => "355426087298442",
  "meta" => [{"metaname": "flightID", "metavalue": "123949494DC"}],
  "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
  "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c",
  "billingzip"=> "07205", 
  "billingcity"=> "Hillside", 
  "billingaddress"=> "470 Mundet PI", 
  "billingstate"=> "NJ", 
  "billingcountry"=> "US"
}

RSpec.describe Card do

  rave = RaveRuby.new(test_public_key, test_secret_key)
  charge_card =  Card.new(rave)

  context "when a merchant tries to charge a customers card" do
    it "should return a card object" do
      expect(charge_card.nil?).to eq(false)
    end
  
    it 'should check if authentication is required after charging a card' do
      response = charge_card.initiate_charge(payload)
      expect(response["suggested_auth"].nil?).to eq(false)
    end

    it 'should successfully charge card with suggested auth PIN' do
      response = charge_card.initiate_charge(pin_payload)
      expect(response["validation_required"]).to eq(true)
    end

    it 'should successfully charge card with suggested auth AVS' do
      response = charge_card.initiate_charge(avs_payload)
      expect(response["authurl"].nil?).to eq(false)
    end

    it 'should return chargeResponseCode 00 after successfully validating with flwRef and OTP' do
      response = charge_card.initiate_charge(pin_payload)
      response = charge_card.validate_charge(response["flwRef"], "12345")
      expect(response["chargeResponseCode"]).to eq("00")
    end

    it 'should return chargecode 00 after successfully verifying a card transaction with txRef' do
      response = charge_card.initiate_charge(pin_payload)
      response = charge_card.validate_charge(response["flwRef"], "12345")
      response = charge_card.verify_charge(response["txRef"])
      expect(response["data"]["chargecode"]).to eq("00")
    end

  end

  # it "should raise RaveBadKeyError" do
  #   rave = RaveRuby.new(test_public_key, test_secret_key)
  #   expect(rave.public_key[0..7]).to eq("FLWPUBK-")
  # end
  
end
