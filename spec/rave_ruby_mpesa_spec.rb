require 'spec_helper'
require "rave_ruby/rave_objects/mpesa"

test_public_key = "FLWPUBK-92e93a5c487ad64939327052e113c813-X"
test_secret_key = "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X"

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
      response = charge_mpesa.initiate_charge(payload)
      expect(response["error"]).to eq(false)
      expect(response["validation_required"]).to eq(true)
    end

    it 'should return chargecode 00 after successfully verifying a mpesa transaction with txRef' do
      response = charge_mpesa.initiate_charge(payload)
      response = charge_mpesa.verify_charge(response["txRef"])
      print response["transaction_complete"]
      expect(response["data"]["chargecode"]).to eq("00")
    end

  end

  # it "should raise RaveBadKeyError" do
  #   rave = RaveRuby.new(test_public_key, test_secret_key)
  #   expect(rave.public_key[0..7]).to eq("FLWPUBK-")
  # end
  
end
