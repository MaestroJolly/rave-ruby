require 'spec_helper'
require "rave_ruby/rave_objects/list_banks"


test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

RSpec.describe ListBanks do

  rave = RaveRuby.new(test_public_key, test_secret_key)

  context "when the list bank endpoint is called" do

    it "should return a valid list banks object" do
      list_banks =  ListBanks.new(rave)
      expect(list_banks.nil?).to eq(false)
    end

    it "should return error equals false if banks successfully fetched" do
      list_banks =  ListBanks.new(rave)
      list_bank_response = list_banks.fetch_banks
      expect(list_bank_response["error"]).to eq(false)
    end
  end
end
