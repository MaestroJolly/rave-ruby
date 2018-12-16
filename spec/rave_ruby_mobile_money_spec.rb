require 'spec_helper'
require "rave_ruby/rave_objects/mobile_money"


# test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
# test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

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
      initiate_mobile_money_response = charge_mobile_money.initiate_charge(payload)
      expect(initiate_mobile_money_response["error"]).to eq(false)
      expect(initiate_mobile_money_response["validation_required"]).to eq(true)
    end

    it 'should return chargecode 00 after successfully verifying a mobile money transaction with txRef' do
      initiate_mobile_money_response = charge_mobile_money.initiate_charge(payload)
      verify_mobile_money_response = charge_mobile_money.verify_charge(initiate_mobile_money_response["txRef"])
      expect(verify_mobile_money_response["data"]["chargecode"]).to eq("00")
    end

  end
  
end
