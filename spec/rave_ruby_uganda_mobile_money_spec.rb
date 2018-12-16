require 'spec_helper'
require "rave_ruby/rave_objects/uganda_mobile_money"


# test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
# test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

payload = {
  "amount" => "30",
  "phonenumber" => "054709929300",
  "firstname" => "Edward",
  "lastname" => "Kisane",
  "network" => "UGX",
  "email" => "tester@flutter.co",
  "IP" => '103.238.105.185',
  "redirect_url" => "https://webhook.site/6eb017d1-c605-4faa-b543-949712931895",
}

RSpec.describe UgandaMobileMoney do

  rave = RaveRuby.new(test_public_key, test_secret_key)
  charge_uganda_mobile_money =  UgandaMobileMoney.new(rave)

  context "when a merchant tries to charge customer with uganda mobile money" do
    it "should return a uganda mobile money object" do
      expect(charge_uganda_mobile_money.nil?).to eq(false)
    end
  
    it 'should check if uganda mobile money transaction is successful initiated and validation is required' do
      initiate_uganda_mobile_money_response = charge_uganda_mobile_money.initiate_charge(payload)
      expect(initiate_uganda_mobile_money_response["error"]).to eq(false)
      expect(initiate_uganda_mobile_money_response["validation_required"]).to eq(true)
    end

    it 'should return chargecode 00 after successfully verifying a uganda mobile money transaction with txRef' do
      initiate_uganda_mobile_money_response = charge_uganda_mobile_money.initiate_charge(payload)
      verify_uganda_mobile_money_response = charge_uganda_mobile_money.verify_charge(initiate_uganda_mobile_money_response["txRef"])
      expect(verify_uganda_mobile_money_response["data"]["chargecode"]).to eq("00")
    end

  end
  
end
