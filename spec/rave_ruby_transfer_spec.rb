require 'spec_helper'
require "rave_ruby/rave_objects/transfer"


# test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
# test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

payload = {
    "account_bank" => "044",
    "account_number" => "0690000044",
    "amount" => 500,
    "narration" => "New transfer",
    "currency" => "NGN",
}

bulk_payload = {
    "title" => "test",
    "bulk_data" => [
        {
            "account_bank" => "044",
            "account_number" => "0690000044",
            "amount" => 500,
            "narration" => "Bulk Transfer 1",
            "currency" => "NGN",
            "reference" => "MC-bulk-reference-1"
        },
        {
            "account_bank" => "044",
            "account_number" => "0690000034",
            "amount" => 500,
            "narration" => "Bulk Transfer 2",
            "currency" => "NGN",
            "reference" => "MC-bulk-reference-1"
        }
    ]
}

RSpec.describe Transfer do

  rave = RaveRuby.new(test_public_key, test_secret_key)
  transfer =  Transfer.new(rave)

  context "when a customer tries to perform transfer" do
    it "should return a transfer object" do
      expect(transfer.nil?).to eq(false)
    end
  
    it 'should check if single transfer is successful' do
      initiate_single_transfer_response = transfer.initiate_transfer(payload)
      expect(initiate_single_transfer_response["error"]).to eq(false)
    end

    it 'should check if bulk transfer is successful' do
        initiate_bulk_transfer_response = transfer.bulk_transfer(bulk_payload)
        expect(initiate_bulk_transfer_response["error"]).to eq(false)
    end

    it 'should return error equal false if single fee is successfully fetched' do
      get_fee_response = transfer.get_fee("NGN")
      expect(get_fee_response["error"]).to eq(false)
    end

    it 'should return error equal false if balance of an account is successfully fetched' do
        get_balance_response = transfer.get_balance("NGN")
        expect(get_balance_response["error"]).to eq(false)
    end

    it 'should return error equal false if balance of an account is successfully fetched' do
        fetch_single_transfer_response = transfer.fetch("Bulk transfer 2")
        expect(fetch_single_transfer_response["error"]).to eq(false)
    end

    it 'should return error equal false if all transfers are successfully fetched' do
        fetch_all_transfer_response = transfer.fetch_all_transfers
        expect(fetch_all_transfer_response["error"]).to eq(false)
    end

  end
  
end
