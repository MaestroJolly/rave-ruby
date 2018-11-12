require "digest"
require "openssl"
require "base64"
require 'json'

module Util
    def self.get_key(key_to_hash)
      hash = Digest::MD5.hexdigest(key_to_hash)
      last_twelve = hash[hash.length-12..hash.length-1]
      private_secret_key = key_to_hash
      private_secret_key['FLWSECK-'] = ''
      first_twelve = private_secret_key[0..11]
      return first_twelve + last_twelve
    end
  
    
    def self.encrypt(key, data)
      cipher = OpenSSL::Cipher.new("des-ede3")
      cipher.encrypt # Call this before setting key
      cipher.key = key
      data = data.to_json
      ciphertext = cipher.update(data)
      ciphertext << cipher.final
      return Base64.encode64(ciphertext)
    end

    def self.decrypt(key, ciphertext)

      cipher = OpenSSL::Cipher.new("des-ede3")
      cipher.encrypt # Call this before setting key or iv
      cipher.key = key
      cipher.decrypt
      plaintext = cipher.update(Base64.decode64(ciphertext))
      plaintext << cipher.final
      return plaintext
      
    end
  
    def checksum(payload)
      payload.sort_by { |k,v| k.to_s }
      hashed_payload = ''
      family.each { |k,v|
        hashed_payload << v
      }
      return Digest::SHA256.hexdigest(hashed_payload + self.secret_key)
    end
end