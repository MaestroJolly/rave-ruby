require 'spec_helper'
require "rave_ruby/rave_objects/preauth"


test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

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
        preauth_initiate_response = preauth.initiate_charge(payload)
        expect(preauth_initiate_response["error"]).to eq(false)
    end

    it 'should return chargeResponseCode 00 after successfully capturing the charge' do
        preauth_initiate_response = preauth.initiate_charge(payload)
        preauth_capture_response = preauth.capture(preauth_initiate_response["flwRef"], "30")
        expect(preauth_capture_response["chargeResponseCode"]).to eq("00")
    end

    it 'should return error equals false if preauth transaction is successfully refunded' do
        preauth_initiate_response = preauth.initiate_charge(payload)
        preauth_capture_response = preauth.capture(preauth_initiate_response["flwRef"], "30")
        preauth_refund_response = preauth.refund(preauth_capture_response["flwRef"])
        expect(preauth_refund_response["error"]).to eq(false)
    end

    it 'should return error equals false if preauth is successfully void' do
        preauth_initiate_response = preauth.initiate_charge(payload)
        preauth_capture_response = preauth.capture(preauth_initiate_response["flwRef"], "30")
        preauth_void_response = preauth.void(preauth_capture_response["flwRef"])
        expect(preauth_void_response["error"]).to eq(false)
    end

    it 'should return charge code equals 00 if preauth successfully verified' do
        preauth_initiate_response = preauth.initiate_charge(payload)
        preauth_capture_response = preauth.capture(preauth_initiate_response["flwRef"], "30")
        preauth_verify_response = preauth.verify_preauth(preauth_capture_response["txRef"])
        expect(preauth_verify_response["data"]["chargecode"]).to eq("00")
    end

  end

  # it "should raise RaveBadKeyError" do
  #   rave = RaveRuby.new(test_public_key, test_secret_key)
  #   expect(rave.public_key[0..7]).to eq("FLWPUBK-")
  # end
  
end
