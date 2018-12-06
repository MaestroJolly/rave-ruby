require 'spec_helper'

test_public_key = "FLWPUBK-92e93a5c487ad64939327052e113c813-X"
test_secret_key = "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X"

payload = {
  "cardno" => "5438898014560229",
  "cvv" => "890",
  "expirymonth" => "09",
  "expiryyear" => "19",
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "10",
  "email" => "user@gmail.com",
  "phonenumber" => "0902620185",
  "firstname" => "temi",
  "lastname" => "desola",
  "IP" => "355426087298442",
  "meta" => [{"metaname": "flightID", "metavalue": "123949494DC"}],
  "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
  "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

RSpec.describe Card do

  rave = RaveRuby.new(test_public_key, test_secret_key)

  
  it "should return the valid rave object" do
		expect(rave.nil?).to eq(false)
  end

  it "should return a card object" do
    charge_card =  Card.new(rave)
		expect(charge_card.nil?).to eq(false)
  end

  it 'initiates a card charge' do
    charge_card = Card.new(rave)
    response = charge_card.initiate_charge(payload)
    expect(response["validation_required"]).to eq(true)
  end

  # it "should raise RaveBadKeyError" do
  #   rave = RaveRuby.new(test_public_key, test_secret_key)
  #   expect(rave.public_key[0..7]).to eq("FLWPUBK-")
  # end
  
end
