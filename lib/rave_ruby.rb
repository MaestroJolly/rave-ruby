require_relative "./rave_ruby/rave_modules/base_endpoints"
require_relative "rave_ruby/rave_objects/base/base"
require_relative "./rave_ruby/rave_modules/util"
require_relative "rave_ruby/rave_objects/list_banks"
require_relative "rave_ruby/rave_objects/card"
require_relative "rave_ruby/rave_objects/account"
require_relative "rave_ruby/rave_objects/transfer"
require_relative "rave_ruby/rave_objects/mpesa"
require_relative "rave_ruby/rave_objects/payment_plan"
require_relative 'rave_ruby/error'


  class RaveRuby
      # include Util
      
      attr_reader :public_key, :secret_key, :production,  :env, :url

      def initialize(public_key=nil, secret_key=nil, production = false, env=false)

        @public_key = public_key
        @secret_key = secret_key
        @production = production
        @env = env
        rave_sandbox_url = BASE_ENDPOINTS::RAVE_SANDBOX_URL
        rave_live_url = BASE_ENDPOINTS::RAVE_LIVE_URL

        if production == false
            @url =  rave_sandbox_url
        else
            @url = rave_live_url
        end

        if env == true
          @public_key = ENV['RAVE_PUBLIC_KEY']
          @secret_key = ENV['RAVE_SECRET_KEY']
        else
          @public_key = public_key
          @secret_key = secret_key
          warn "Warning: To ensure your rave account api keys are safe, It is best to always set your keys in the environment variable"
        end

        unless !@public_key.nil?
          raise RaveBadKeyError, "No public key supplied and couldn't find any in environment variables. Make sure to set public key as an environment variable RAVE_PUBLIC_KEY"
        end
        unless @public_key[0..7] == 'FLWPUBK-'
          raise RaveBadKeyError, "Invalid public key #{@public_key}"
        end
        
        unless !@secret_key.nil?
          raise RaveBadKeyError, "No secret key supplied and couldn't find any in environment variables. Make sure to set secret key as an environment variable RAVE_SECRET_KEY"
        end
        unless @secret_key[0..7] == 'FLWSECK-'
          raise RaveBadKeyError, "Invalid secret key #{@secret_key}"
        end
  end
  def base_url
    return url
  end
end
