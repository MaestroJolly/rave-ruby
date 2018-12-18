require 'spec_helper'
require "rave_ruby/rave_objects/sub_account"

# test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
# test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

payload = {
	"account_bank" => "044",
	"account_number" => "0690000032",
	"business_name" => "Jake Stores",
	"business_email" => "jdhhd@services.com",
	"business_contact" => "Amy Parkers",
	"business_contact_mobile" => "09083772",
	"business_mobile" => "0188883882",
    "split_type" => "flat",
    "split_value" => 3000,
	"meta" => [{"metaname": "MarketplaceID", "metavalue": "ggs-920900"}]
}

incomplete_payload = {
	"account_number" => "0690000032",
	"business_name" => "Jake Stores",
	"business_email" => "jdhhd@services.com",
	"business_contact" => "Amy Parkers",
	"business_contact_mobile" => "09083772",
	"business_mobile" => "0188883882",
    "split_type" => "flat",
    "split_value" => 3000,
	"meta" => [{"metaname": "MarketplaceID", "metavalue": "ggs-920900"}]
}

RSpec.describe SubAccount do

  rave = RaveRuby.new(test_public_key, test_secret_key)
  subaccount =  SubAccount.new(rave)

  context "when a merchant tries to set up a sub account" do
    it "should return a valid sub account object" do
      expect(subaccount.nil?).to eq(false)
    end

    it 'should raise Error if sub account payload is incomplete' do
        begin
          incomplete_payload_response = subaccount.create_subaccount(incomplete_payload)
        rescue  => e
          expect(e.instance_of? IncompleteParameterError).to eq true
        end
    end
  
    it 'should check if sub account is successfully created' do
        create_subaccount_response = subaccount.create_subaccount(payload)
      expect(create_subaccount_response["error"]).to eq(false)
    end

    it 'should check if all sub accounts list is successfully returned' do
        list_subaccount_response = subaccount.list_subaccounts
      expect(list_subaccount_response["error"]).to eq(false)
    end

    it 'should check if a single sub account is successfully returned with sub account id' do
        fetch_subaccount_response = subaccount.fetch_subaccount("RS_A59429B9C94C5A862F731711290B9ADD")
      expect(fetch_subaccount_response["error"]).to eq(false)
    end

    it 'should check if a single sub account is successfully deleted with sub account id' do
      delete_subaccount_response = delete.delete_subaccount("RS_A59429B9C94C5A862F731711290B9ADD")
      expect(delete_subaccount_response["error"]).to eq(false)
    end
  end
  
end
