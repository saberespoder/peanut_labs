require_relative '../credentials'
require_relative '../errors'
require_relative 'user_id'
require_relative 'user_payload'
require 'uri'

module PeanutLabs
  module Builder
    class DirectLink
      ENDPOINT = "https://dlink.peanutlabs.com/direct_link".freeze

      # Parameters:
      # user_pid – the user’s id within system
      # payload  – a hash with user data attributes for encryption
      # sub_id   – a secure session id. Will be returned during postback notification

      def self.call(user_pid, attrs = {})
        # @TODO: Be able to pass user language as attribute
        raise UserIdMissingError if user_pid.nil? || user_pid.empty?

        user_id          = Builder::UserId.new(user_pid).call
        params           = { pub_id: Credentials.id, user_id: user_id }
        payload, sub_id  = attrs[:payload], attrs[:sub_id]

        if payload && payload.any?
          encryped = Builder::UserPayload.call(payload.merge(user_id: user_id))
          params[:payload], params[:iv] = encryped[:payload], encryped[:iv]
        end

        params[:sub_id] = sub_id if sub_id

        "#{ENDPOINT}/?#{URI.encode_www_form(params)}"
      end
    end
  end
end
