require_relative '../credentials'
require 'digest'

module PeanutLabs
  module Builder
    class UserId
      # Documentation is here: http://peanut-labs.github.io/publisher-doc/index.html#iframe-getuserid

      def initialize(params = nil)
        @credentials = params[:credentials] || PeanutLabs::Credentials.new(params)
      end

      def call(public_user_id)
        "#{public_user_id}-#{credentials.id}-#{user_go(public_user_id)}"
      end

      private

      attr_accessor :credentials

      def user_go(public_user_id)
        Digest::MD5.hexdigest("#{public_user_id}#{credentials.id}#{credentials.key}")[0..9]
      end
    end
  end
end
