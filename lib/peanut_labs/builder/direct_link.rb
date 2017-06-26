require_relative 'user_id'

module PeanutLabs
  module Builder
    class DirectLink
      ENDPOINT = "https://dlink.peanutlabs.com/direct_link".freeze

      # Parameters:
      # user_id - the user’s id within system
      # sub_id - A secure session id. Will be returned during postback notification.

      def self.call(user_id, sub_id=nil)
        raise UserIdMissingError if user_id.nil? || user_id.empty?

        result = "#{ENDPOINT}/?pub_id=#{Credentials.id}&user_id=#{Builder::UserId.new(user_id).call}"

        if sub_id
          result << "&sub_id=#{sub_id}"
        end

        result
      end
    end
  end
end
