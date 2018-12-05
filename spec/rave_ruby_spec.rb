require 'spec_helper'

test_public_key = "FLWPUBK-92e93a5c487ad64939327052e113c813-X"
test_secret_key = "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X"

RSpec.describe RaveRuby do

  it "has a version number" do
    expect(RaveRuby::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end

  it "it should return the valid object" do
    rave = RaveRuby.new(test_public_key, test_secret_key)
		expect(rave.nil?).to eq(false)
  end
end
