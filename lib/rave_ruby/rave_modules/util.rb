require "digest"
require "openssl"
require "base64"
require 'json'
require 'securerandom'

module Util

    # method to generate merchants transaction reference
    def self.transaction_reference_generator
      transaction_ref = "MC-" + SecureRandom.hex
      return transaction_ref
    end

    # method for encryption algorithm
    def self.encrypt(key, data)
      cipher = OpenSSL::Cipher.new("des-ede3")
      cipher.encrypt # Call this before setting key
      cipher.key = key
      data = data.to_json
      ciphertext = cipher.update(data)
      ciphertext << cipher.final
      return Base64.encode64(ciphertext)
    end

    # def self.decrypt(key, ciphertext)

    #   cipher = OpenSSL::Cipher.new("des-ede3")
    #   cipher.encrypt # Call this before setting key or iv
    #   cipher.key = key
    #   cipher.decrypt
    #   plaintext = cipher.update(Base64.decode64(ciphertext))
    #   plaintext << cipher.final
    #   return plaintext
      
    # end
  
    # def checksum(payload)
    #   payload.sort_by { |k,v| k.to_s }
    #   hashed_payload = ''
    #   family.each { |k,v|
    #     hashed_payload << v
    #   }
    #   return Digest::SHA256.hexdigest(hashed_payload + self.secret_key)
    # end
end