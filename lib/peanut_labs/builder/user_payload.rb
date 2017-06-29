require 'openssl'
require 'base64'

module PeanutLabs
  module Builder
    class UserPayload
      IV_SIZE = 16.freeze

      def self.call(payload={})
        iv = get_init_vector
        { iv: iv }
      end

      private

      def self.get_init_vector
        cipher    = OpenSSL::Cipher.new('AES-128-CBC')
        random_iv = cipher.random_iv
        CGI.escape(Base64.strict_encode64(random_iv))
      end
    end
  end
end
