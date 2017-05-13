require_relative '../credentials'
require_relative '../parser/sex'
require_relative '../parser/date_of_birth'
require_relative '../errors'

module PeanutLabs
  module Builder
    class IframeUrl
      ENDPOINT = 'https://www.peanutlabs.com/userGreeting.php'.freeze

      def initialize(params=nil)
        @credentials = Credentials.new(params)
      end

#
#     Documentation here: http://peanut-labs.github.io/publisher-doc/index.html#iframe-optionalpara
#
#     Accepts these parameters
#     params[:id] -> required, specially encoded from peanut labs user_id
#     params[:dob] -> not required, classes accepted - Date, DateTime, Time or formatted "MM-DD-YYYY" string
#     params[:sex] -> not required, 1 for male, 2 for female
#
      def call(params)
        raise PeanutLabs::UserIdMissingError if params[:id].nil? || params[:id].empty?

        result = "#{ENDPOINT}?userId=#{UserId.new(credentials: credentials).call(params[:id])}"

        if (sex = PeanutLabs::Parser::Sex.call(params[:sex]))
          result << "&sex=#{sex}"
        end

        if (dob = PeanutLabs::Parser::DateOfBirth.iframe(params[:dob]))
          result << "&dob=#{dob}"
        end

        result
      end

      private

      attr_accessor :credentials
    end
  end
end
