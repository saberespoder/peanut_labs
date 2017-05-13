require_relative 'builder/user_id'

module PeanutLabs
  class DirectLink
    ENDPOINT = "https://dlink.peanutlabs.com/direct_link".freeze

    def initialize(params={})
      @credentials = params[:credentials] || Credentials.new(params)
    end

    def call(user_id, sub_id=nil)
      raise UserIdMissingError if user_id.nil? || user_id.empty?

      result = "#{ENDPOINT}/?pub_id=#{credentials.id}&user_id=#{Builder::UserId.new(credentials: credentials).call(user_id)}"

      if sub_id
        result << "&sub_id=#{sub_id}"
      end

      result
    end

    private

    attr_accessor :credentials
  end
end
