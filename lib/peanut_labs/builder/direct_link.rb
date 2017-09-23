require_relative '../credentials'
require_relative '../errors'
require_relative 'user_id'
require_relative 'user_payload'
require 'uri'

module PeanutLabs
  module Builder
    class DirectLink
      ENDPOINT            = 'https://dlink.peanutlabs.com/direct_link'.freeze
      EXPECTED_ATTRIBUTES = %i(sub_id touchcode zl).freeze

      # Parameters:
      # user_pid  – the user’s id within system
      # payload   – a hash with user data attributes for encryption
      # sub_id    – a secure session id. Will be returned during postback notification
      # touchcode – survey identifier
      # zl        – survey language (for some reason, PN translates only interface but not questions)

      def self.call(user_pid, attrs = {})
        raise UserIdMissingError if user_pid.nil? || user_pid.empty?
        raise PayloadObjectError if attrs[:payload] && attrs[:payload].class != Hash

        user_id = Builder::UserId.new(user_pid).call
        params  = { pub_id: Credentials.id, user_id: user_id }
        payload = attrs[:payload]

        if payload && payload.any?
          encryped = Builder::UserPayload.call(payload.merge(user_id: user_id))
          params[:payload], params[:iv] = encryped[:payload], encryped[:iv]
        end

        EXPECTED_ATTRIBUTES.each { |name| params[name] = attrs[name] if attrs[name] }

        "#{ENDPOINT}/?#{URI.encode_www_form(params)}"
      end
    end
  end
end
