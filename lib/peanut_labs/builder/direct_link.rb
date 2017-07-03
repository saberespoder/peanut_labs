require_relative '../credentials'
require_relative '../errors'
require_relative 'user_id'
require 'uri'

module PeanutLabs
  module Builder
    class DirectLink
      ENDPOINT = "https://dlink.peanutlabs.com/direct_link".freeze

      # Parameters:
      # user_id - the user’s id within system
      # sub_id  - A secure session id. Will be returned during postback notification.

      def self.call(user_id, sub_id = nil)
        raise UserIdMissingError if user_id.nil? || user_id.empty?

        attributes = {
          pub_id:  Credentials.id,
          user_id: Builder::UserId.new(user_id).call
        }

        attributes[:sub_id] = sub_id if sub_id

        "#{ENDPOINT}/?#{URI.encode_www_form(attributes)}"
      end
    end
  end
end
