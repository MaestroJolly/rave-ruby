require_relative './lib/rave_ruby'

# rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-92e93a5c487ad64939327052e113c813-X", "FLWSECK-61037cfe3cfc53b03e339ee201fa98f5-X")


# # This is used to initiate single transfer

payload = {
    "account_bank" => "044",
    "account_number" => "0690000044",
    "amount" => 500,
    "narration" => "New transfer",
    "currency" => "NGN",
}

transfer = Transfer.new(rave)

response = transfer.initiate_transfer(payload)

print response


# This is used to send bulk transfer

# payload = {
#     "title" => "test",
#     "bulk_data" => [
#         {
#             "account_bank" => "044",
#             "account_number" => "0690000044",
#             "amount" => 500,
#             "narration" => "Bulk Transfer 1",
#             "currency" => "NGN",
#             "reference" => "MC-bulk-reference-1"
#         },
#         {
#             "account_bank" => "044",
#             "account_number" => "0690000034",
#             "amount" => 500,
#             "narration" => "Bulk Transfer 2",
#             "currency" => "NGN",
#             "reference" => "MC-bulk-reference-1"
#         }
#     ]
# }


# transfer = Transfer.new(rave)

# response = transfer.bulk_transfer(payload)

# print response

# # This is used to get the transfer fee by taking in the currency
# response = transfer.get_fee("NGN")
# print response

# # This is used to get the balance by taking in the currency
# response = transfer.get_balance("NGN")
# print response

# # This is used to fetch a single transfer by passing in the transaction reference
# response = transfer.fetch("Bulk Transfer 2")
# print response

# # This is used to fetch all transfer
# response = transfer.fetch_all_transfers
# print response