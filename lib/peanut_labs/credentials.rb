require_relative 'errors'

module PeanutLabs
  class Credentials
    class << self
      attr_writer :id, :key

      def id
        raise PeanutLabs::CredentialsMissingError.new("APP ID is missing") if @id.nil? || @id.empty?

        @id
      end

      def key
        raise PeanutLabs::CredentialsMissingError.new("APP KEY is missing") if @key.nil? || @key.empty?

        @key
      end
    end
  end
end