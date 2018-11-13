require_relative "base.rb"
require 'json'

class Card < Base

    attr_reader :rave_object

    def initialize(rave_object)
        @rave_object = rave_object
    end

    def initiate_charge(data)
        base_url = rave_object.base_url
        secret_key = rave_object.secret_key
        public_key = rave_object.public_key
        hash_secret_key = Util.get_key(secret_key)
        data.merge!({"PBFPubKey" => public_key})
        encrypt_data = Util.encrypt(hash_secret_key, data)
        # print decrypt_data = Util.decrypt(hash_secret_key, encrypt_data)

        payload = {
            "PBFPubKey": public_key,
            "client": encrypt_data,
            "alg": "3DES-24"
        }

        payload = payload.to_json
        # print payload

        return post_request("#{base_url}#{BASE_ENDPOINTS::CHARGE_ENDPOINT}", payload) 
    end

    # def update_payload(suggested_auth, payload, pin=nil, address=nil)
    #     if suggested_auth == "PIN"
    #       return payload.merge!({"suggested_auth" => pin})
    #     elsif suggested_auth == "AVS_VBVSECURECODE"
    #       return payload.merge!({"suggested_auth" => address})
    #     end
    # end
end
