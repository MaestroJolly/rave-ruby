require 'spec_helper'
require "rave_ruby/rave_objects/mpesa"

test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

payload = {
  "amount" => "100",
  "phonenumber" => "0926420185",
  "email" => "user@exampe.com",
  "IP" => "40.14.290",
  "narration" => "funds payment",
}

RSpec.describe Mpesa do

  rave = RaveRuby.new(test_public_key, test_secret_key)
  charge_mpesa =  Mpesa.new(rave)

  context "when a merchant tries to charge customer with mpesa" do
    it "should return a mpesa object" do
      expect(charge_mpesa.nil?).to eq(false)
    end
  
    it 'should check if mpesa transaction is successful initiated and validation is required' do
      initiate_mpesa_response = charge_mpesa.initiate_charge(payload)
      expect(initiate_mpesa_response["error"]).to eq(false)
      expect(initiate_mpesa_response["validation_required"]).to eq(true)
    end

    it 'should return chargecode 00 after successfully verifying a mpesa transaction with txRef' do
      initiate_mpesa_response = charge_mpesa.initiate_charge(payload)
      verify_mpesa_response = charge_mpesa.verify_charge(initiate_mpesa_response["txRef"])
      expect(verify_mpesa_response["data"]["chargecode"]).to eq("00")
    end

  end

  # it "should raise RaveBadKeyError" do
  #   rave = RaveRuby.new(test_public_key, test_secret_key)
  #   expect(rave.public_key[0..7]).to eq("FLWPUBK-")
  # end
  
end
