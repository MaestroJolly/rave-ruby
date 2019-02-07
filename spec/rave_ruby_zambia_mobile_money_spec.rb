require 'spec_helper'
require "rave_ruby/rave_objects/zambia_mobile_money"

# test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
# test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

payload = {
  "amount" => "30",
  "phonenumber" => "054709929300",
  "firstname" => "John",
  "lastname" => "Doe",
  "network" => "MTN",
  "email" => "user@example.com",
  "IP" => '355426087298442',
  "redirect_url" => "https://webhook.site/6eb017d1-c605-4faa-b543-949712931895",
}

RSpec.describe ZambiaMobileMoney do

  rave = RaveRuby.new(test_public_key, test_secret_key)
  charge_zambia_mobile_money =  ZambiaMobileMoney.new(rave)

  context "when a merchant tries to charge customer with zambia mobile money" do
    it "should return a zambia mobile money object" do
      expect(charge_zambia_mobile_money.nil?).to eq(false)
    end
  
    it 'should check if zambia mobile money transaction is successful initiated and validation is required' do
      initiate_zambia_mobile_money_response = charge_zambia_mobile_money.initiate_charge(payload)
      expect(initiate_zambia_mobile_money_response["error"]).to eq(false)
      expect(initiate_zambia_mobile_money_response["validation_required"]).to eq(true)
    end

    it 'should return chargecode 00 after successfully verifying a zambia mobile money transaction with txRef' do
      initiate_zambia_mobile_money_response = charge_zambia_mobile_money.initiate_charge(payload)
      verify_zambia_mobile_money_response = charge_zambia_mobile_money.verify_charge(initiate_zambia_mobile_money_response["txRef"])
      expect(verify_zambia_mobile_money_response["data"]["chargecode"]).to eq("00")
    end

  end
  
end
