require 'spec_helper'
require "rave_ruby/rave_objects/transfer"

test_public_key = "FLWPUBK-92e93a5c487ad64939327052e113c813-X"
test_secret_key = "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X"

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
      response = transfer.initiate_transfer(payload)
      expect(response["error"]).to eq(false)
    end

    it 'should check if bulk transfer is successful' do
        response = transfer.bulk_transfer(bulk_payload)
        expect(response["error"]).to eq(false)
    end

    it 'should return error equal false if single fee is successfully fetched' do
      response = transfer.get_fee("NGN")
      expect(response["error"]).to eq(false)
    end

    it 'should return error equal false if balance of an account is successfully fetched' do
        response = transfer.get_balance("NGN")
        expect(response["error"]).to eq(false)
    end

    it 'should return error equal false if balance of an account is successfully fetched' do
        response = transfer.fetch("Bulk transfer 2")
        expect(response["error"]).to eq(false)
    end

    it 'should return error equal false if all transfers are successfully fetched' do
        response = transfer.fetch_all_transfers
        expect(response["error"]).to eq(false)
    end

  end

  # it "should raise RaveBadKeyError" do
  #   rave = RaveRuby.new(test_public_key, test_secret_key)
  #   expect(rave.public_key[0..7]).to eq("FLWPUBK-")
  # end
  
end
