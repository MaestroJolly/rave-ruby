require 'spec_helper'
require "rave_ruby/rave_objects/ussd"

# test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
# test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

payload = {
  "accountbank" => "057",
  "accountnumber" => "0691008392",
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "10",
  "email" => "desola.ade1@gmail.com",
  "phonenumber" => "0902620185", 
  "IP" => "355426087298442",
}

incomplete_payload = {
  "accountnumber" => "0691008392",
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "10",
  "email" => "desola.ade1@gmail.com",
  "phonenumber" => "0902620185", 
  "IP" => "355426087298442",
}

RSpec.describe Ussd do

  rave = RaveRuby.new(test_public_key, test_secret_key)
  charge_ussd =  Ussd.new(rave)

  context "when a merchant tries to charge customer with ussd" do
    it "should return a ussd object" do
      expect(charge_ussd.nil?).to eq(false)
    end

    it 'should raise Error if ussd payload is incomplete' do
      begin
        incomplete_payload_response = charge_ussd.initiate_charge(incomplete_payload)
      rescue  => e
        expect(e.instance_of? IncompleteParameterError).to eq true
      end
  end
  
    it 'should check if ussd transaction is successful initiated and validation is required' do
      initiate_ussd_response = charge_ussd.initiate_charge(payload)
      expect(initiate_ussd_response["error"]).to eq(false)
      expect(initiate_ussd_response["validation_required"]).to eq(true)
    end

    it 'should return chargecode 00 after successfully verifying a ussd transaction with txRef' do
      initiate_ussd_response = charge_ussd.initiate_charge(payload)
      verify_ussd_response = charge_ussd.verify_charge(initiate_mobile_money_response["txRef"])
      expect(verify_ussd_response["data"]["chargecode"]).to eq("00")
    end

  end
  
end
