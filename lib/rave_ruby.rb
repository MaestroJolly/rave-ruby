require_relative "./rave_ruby/rave_modules/base_endpoints"
require_relative "./rave_ruby/rave_modules/util"
require_relative "rave_ruby/rave_objects/list_banks"
require_relative "rave_ruby/rave_objects/card"
require_relative 'rave_ruby/error'


  class RaveRuby
      # include Util
      
      attr_accessor :public_key, :secret_key, :production,  :env, :url
      # data = {
      #   "test" => "just test",
      #   "one" => 1,
      #   "bool" => true
      # }
      # encrypt = Util.encrypt(sec_key, data)
      # print(encrypt)

      # print ListBanks.list_banks("#{BASE_ENDPOINTS::RAVE_SANDBOX_URL}#{BASE_ENDPOINTS::BANKS_ENDPOINT}", {:json => 1})

      def initialize(public_key=nil, secret_key=nil, production = false, env=false)

        self.public_key = public_key
        self.secret_key = secret_key
        self.production = production
        self.env = env
        rave_sandbox_url = BASE_ENDPOINTS::RAVE_SANDBOX_URL
        rave_live_url = BASE_ENDPOINTS::RAVE_LIVE_URL

        if production == false
            self.url =  rave_sandbox_url
        else
            self.url = rave_live_url
        end

        if env == true
          @public_key = ENV['RAVE_PUBLIC_KEY']
          @secret_key = ENV['RAVE_SECRET_KEY']
        else
          @public_key = public_key
          @secret_key = secret_key
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
