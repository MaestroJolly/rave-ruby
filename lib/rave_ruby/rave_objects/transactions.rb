require './rave_ruby/objects/base'

  class RaveTransactions < RaveBaseObject

      #encrpt the data

      def encrypt(key, data)
        key = key
        data = data
        client_data = encrypt(key, data)
      end

    #Card payment
    def chargeCards(client_data )
          payload = {
            "PBFPubKey" => self.PBFPubKey,
            "client" => client_data,
            "alg" => "3DES-24"
          }
          perform_post("#{BASE::CHARGE_ENDPOINT}/charge", payload)
    end


  end
