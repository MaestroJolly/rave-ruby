require 'spec_helper'
require "rave_ruby/rave_objects/preauth"

test_public_key = "FLWPUBK-92e93a5c487ad64939327052e113c813-X"
test_secret_key = "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X"

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

RSpec.describe Preauth do

  rave = RaveRuby.new(test_public_key, test_secret_key)
  preauth =  Preauth.new(rave)

  context "when a merchant tries to charge customer with a tokenized card" do
    it "should return a valid preauth object" do
        expect(preauth.nil?).to eq(false)
    end
  
    it 'should return error equals to false pending capture' do
        response = preauth.initiate_charge(payload)
        expect(response["error"]).to eq(false)
    end

    it 'should return chargeResponseCode 00 after successfully capturing the charge' do
        response = preauth.initiate_charge(payload)
        response = preauth.capture(response["flwRef"], "30")
        expect(response["chargeResponseCode"]).to eq("00")
    end

    it 'should return error equals false if preauth transaction is successfully refunded' do
        response = preauth.initiate_charge(payload)
        response = preauth.capture(response["flwRef"], "30")
        response = preauth.refund(response["flwRef"])
        expect(response["error"]).to eq(false)
    end

    it 'should return error equals false if preauth is successfully void' do
        response = preauth.initiate_charge(payload)
        response = preauth.capture(response["flwRef"], "30")
        response = preauth.void(response["flwRef"])
        expect(response["error"]).to eq(false)
    end

    it 'should return charge code equals 00 if preauth successfully verified' do
        response = preauth.initiate_charge(payload)
        response = preauth.capture(response["flwRef"], "30")
        response = preauth.verify_preauth(response["txRef"])
        expect(response["data"]["chargecode"]).to eq("00")
    end

  end

  # it "should raise RaveBadKeyError" do
  #   rave = RaveRuby.new(test_public_key, test_secret_key)
  #   expect(rave.public_key[0..7]).to eq("FLWPUBK-")
  # end
  
end
