require 'spec_helper'
require "rave_ruby/rave_objects/list_banks"

test_public_key = "FLWPUBK-92e93a5c487ad64939327052e113c813-X"
test_secret_key = "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X"

RSpec.describe ListBanks do

  rave = RaveRuby.new(test_public_key, test_secret_key)

  context "when the list bank endpoint is called" do

    it "should return a valid list banks object" do
      list_banks =  ListBanks.new(rave)
      expect(list_banks.nil?).to eq(false)
    end

    it "should return error equals false if banks successfully fetched" do
      list_banks =  ListBanks.new(rave)
      response = list_banks.fetch_banks
      expect(response["error"]).to eq(false)
    end
  end
end
