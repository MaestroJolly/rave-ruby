require_relative './lib/rave_ruby'


rave = RaveRuby.new("FLWPUBK-92e93a5c487ad64939327052e113c813-X", "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X")

# This is used to list banks

list_banks = ListBanks.new(rave)

print list_banks.fetch_banks