require 'spec_helper'


# test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
# test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

RSpec.describe RaveRuby do

  rave = RaveRuby.new(test_public_key, test_secret_key)

  # it "has a version number" do
  #   expect(RaveRuby::VERSION).not_to be nil
  # end

  # it "does something useful" do
  #   expect(false).to eq(true)
  # end

  it "should return the valid rave object" do
		expect(rave.nil?).to eq(false)
  end

  it "should return valid public key" do
    expect(rave.public_key[0..7]).to eq("FLWPUBK-")
  end

  it "should return valid private key" do
    expect(rave.secret_key[0..7]).to eq("FLWSECK-")
  end
  
end
