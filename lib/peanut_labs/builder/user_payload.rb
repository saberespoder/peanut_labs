require_relative '../credentials'
require 'openssl'
require 'base64'
require 'cgi'
require 'json'

module PeanutLabs
  module Builder
    class UserPayload
      MANDATORY_ATTRS = %i(user_id cc dob sex).freeze
      ENCRYPTION      = 'AES-128-CBC'.freeze
      BLOCK_SIZE      = 16.freeze

#
#     This class is Ruby implementation of encoding algorithm
#     described in http://peanut-labs.github.io/publisher-doc/#iv-payload
#
#     It turns out that we don't have add AES padding inside `encrypt_json_payload`
#     because unlike PHP implementation OpenSSL applies them itself
#

      def self.call(payload = {}, init_vector = nil)
        raise PayloadMandatoryError if (MANDATORY_ATTRS - payload.keys.map(&:to_sym)).any?

        json_payload = payload.to_json
        init_vector  = get_init_vector unless init_vector

        return {
          iv:      init_vector,
          payload: encrypt_json_payload(json_payload,
            Credentials.key,
            init_vector
          )
        }
      end

      private

      def self.get_init_vector
        cipher = OpenSSL::Cipher.new(ENCRYPTION).encrypt
        CGI.escape(Base64.strict_encode64(cipher.random_iv))
      end

      def self.encrypt_json_payload(payload, application_key, iv)
        # Convert application key into binary format
        binary_key = [application_key].pack('H*')
        # Encrypt payload
        encrypted_payload = encryptor(payload, binary_key, iv)

        CGI.escape(Base64.strict_encode64(encrypted_payload))
      end

      def self.encryptor(payload, key, iv)
        cipher     = OpenSSL::Cipher.new(ENCRYPTION).encrypt
        cipher.iv  = Base64.strict_decode64(CGI.unescape(iv))
        cipher.key = key

        cipher.update(payload) + cipher.final
      end
    end
  end
end
