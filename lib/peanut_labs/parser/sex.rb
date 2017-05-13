module PeanutLabs
  module Parser
    class Sex
      MALE = %w[1 m male].freeze
      FEMALE = %w[2 f female].freeze

      def self.call(value)
        return value.to_s if value.is_a?(Integer) && value < 3 && value.positive?
        return nil if value.is_a?(Integer) || value.nil?
        return '1' if MALE.include? value.downcase
        return '2' if FEMALE.include? value.downcase

        nil
      end
    end
  end
end
