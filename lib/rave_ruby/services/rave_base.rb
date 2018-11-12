require 'digest'
require_relative "../modules/base"

class RaveBase
    attr_reader :payload, :secretKey, :publicKey
    include Base

    def initialize(paymentObject, secretKey, publicKey)
        @payload = paymentObject
        @secretKey = secretKey
        @publicKey = publicKey
    end

    def get_request(paymentobject, url)
    
    end

    def get_key()
        seckey = "FLWSECK-6b32914d4d60c10d0ef72bdad734134a-X"
        hashedseckey = Digest::MD5.hexdigest seckey
        puts hashedseckey
    end
    
    ravebase = RaveBase.new(1, 2, 3)
    print ravebase.get_key
    # print get_key

end