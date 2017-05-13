require 'date'

module PeanutLabs
  module Parser
    class DateOfBirth
      class << self
        # This method formats DateTime, Date, Time to time format required for Iframe (MM-DD-YYYY)
        # It also checks if string is already formatted correctly
        # Can return NIL

        def iframe(value)
          retrieve_date(value, /^\d{2}-\d{2}-\d{4}$/, '%m-%d-%Y')
        end

        # This method formats DateTime, Date, Time to time format required for Profile class (YYYY-MM-DD)
        # It also checks if string is already formatted correctly
        # Can return NIL

        def profile(value)
          retrieve_date(value, /^\d{4}-\d{2}-\d{2}$/, '%Y-%m-%d')
        end

        private

        def retrieve_date(value, correct_regexp, format_as)
          return value if value.nil?
          return value.strftime(format_as) if value.is_a?(Date) || value.is_a?(DateTime) || value.is_a?(Time)
          return value if value.match?(correct_regexp)

          nil
        end
      end
    end
  end
end
