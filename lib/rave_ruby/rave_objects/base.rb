require 'httparty'
require_relative "../rave_modules/base_endpoints"
require "json"
require_relative "../exceptions"

class Base

  attr_reader :rave_object

  def initialize(rave_object)
    unless !rave_object.nil?
      raise ArgumentError, "Rave Object is required!!!"
    end
    self.rave_object = rave_object
  end

  def get_request(endpoint, data={})
    http_params = {}
    unless data.empty?
      http_params[:query] = data
    end

    begin
      response = HTTParty.get(endpoint, http_params)
      unless (response.code == 200 || response.code == 201)
        raise RaveServerError.new(response), "HTTP Code #{response.code}: #{response.body}"
      end

      response_body = response.body

      return response_body

      unless(response.code != 0 )
        raise RaveServerError.new(response), "Server Message: #{response.message}"
      end

      rescue JSON::ParserError => jsonerr
        raise RaveServerError.new(response) , "Invalid result data. Could not parse JSON response body \n #{jsonerr.message}"

      # rescue RaveServerError => e
      #   Util.serverErrorHandler(e)
      # end	

        return response_body
      end
  end


  def post_request(endpoint, data)
    response = HTTParty.post(endpoint, {
      body: data,
      headers: {
        'Content-Type' => 'application/json'
      }
    })

    # if response.success?
    #     raise RaveServerError.new(response), "#{response["data"]["suggested_auth"]} is required."
    #     return response
    # end
  end

  def update_payload(suggested_auth, payload, pin=nil, address=nil)
    if suggested_auth == "PIN"
      return payload.merge!({"pin" => pin, "suggested_auth" => suggested_auth})
    elsif suggested_auth == "AVS_VBVSECURECODE"
      return payload.merge!({"pin" => pin, "suggested_auth" => address})
    end
  end

#   payload = {
#     "cardno" => "5438898014560229",
#     "cvv" => "890",
#     "expirymonth" => "09",
#     "expiryyear" => "19",
#     "currency" => "NGN",
#     "country" => "NG",
#     "amount" => "10",
#     "email" => "user@gmail.com",
#     "phonenumber" => "0902620185",
#     "firstname" => "temi",
#     "lastname" => "desola",
#     "IP" => "355426087298442",
#     "txRef" => "MC-", # your unique merchant reference
#     "meta" => "123949494DC",
#     "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
#     "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
# }
# suggested_auth = "PIN"

# print update_payload(suggested_auth, payload, pin="3310")
end
