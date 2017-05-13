require_relative 'errors'

module PeanutLabs
  class Credentials
    DEFAULT_PARAMS = { app_id: nil, app_key: nil }.freeze

    # accepts params for app credentials or tries to retrieve them from ENV variables
    #
    # params[:app_id] = application id provided by peanut labs
    # params[:app_key] = application key provided by peanut labs
    #
    # or provide via ENV variable
    #
    # ENV['PEANUTLABS_ID']
    # ENV['PEANUTLABS_KEY']

    attr_accessor :id, :key

    def initialize(params=nil)
      params ||= DEFAULT_PARAMS

      @id = params[:app_id] || ENV['PEANUTLABS_ID']
      @key = params[:app_key] || ENV['PEANUTLABS_KEY']

      if id.nil? || key.nil? || id.empty? || key.empty?
        raise PeanutLabs::CredentialsMissingError
      end

    end
  end
end
