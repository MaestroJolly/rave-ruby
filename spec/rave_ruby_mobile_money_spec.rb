require 'spec_helper'
require "rave_ruby/rave_objects/mobile_money"

test_public_key = "FLWPUBK-92e93a5c487ad64939327052e113c813-X"
test_secret_key = "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X"

payload = {
  "amount" => "50",
  "email" => "cezojejaze@nyrmusic.com",
  "phonenumber" => "08082000503",
  "network" => "MTN",
  "redirect_url" => "https://webhook.site/6eb017d1-c605-4faa-b543-949712931895",
  "IP" => ""
}

RSpec.describe MobileMoney do

  rave = RaveRuby.new(test_public_key, test_secret_key)
  charge_mobile_money =  MobileMoney.new(rave)

  context "when a merchant tries to charge customer with mobile money" do
    it "should return a mobile money object" do
      expect(charge_mobile_money.nil?).to eq(false)
    end
  
    it 'should check if mobile money transaction is successful initiated and validation is required' do
      response = charge_mobile_money.initiate_charge(payload)
      expect(response["error"]).to eq(false)
      expect(response["validation_required"]).to eq(true)
    end

    it 'should return chargecode 00 after successfully verifying a mobile money transaction with txRef' do
      response = charge_mobile_money.initiate_charge(payload)
      response = charge_mobile_money.verify_charge(response["txRef"])
      expect(response["data"]["chargecode"]).to eq("00")
    end

  end

  # it "should raise RaveBadKeyError" do
  #   rave = RaveRuby.new(test_public_key, test_secret_key)
  #   expect(rave.public_key[0..7]).to eq("FLWPUBK-")
  # end
  
end
