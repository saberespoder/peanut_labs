require_relative '../credentials'
require 'digest'

module PeanutLabs
  module Builder
    class UserId
      # public_user_id = the user’s id within system
      # highly recommended not to expose descending id's in here

      def initialize(public_used_id)
        # TODO: check that public_user_id is alphanumeric or throw error
        @public_user_id = public_used_id
      end

      # Documentation is here: http://peanut-labs.github.io/publisher-doc/index.html#iframe-getuserid

      # Returning value consists of:
      # - endUserId (ex. 11701396) the user’s id within your system (alphanumeric)
      # - Peanut Labs ApplicationId (ex. 600) generated when you add an application to your account. Listed as ID in Manage Apps
      # - userGo (ex. cbc2104c7a) this is a generated hash

      def call
        "#{public_user_id}-#{Credentials.id}-#{user_go}"
      end

      private

      attr_accessor :public_user_id

      def user_go
        Digest::MD5.hexdigest("#{public_user_id}#{Credentials.id}#{Credentials.key}")[0..9]
      end
    end
  end
end
