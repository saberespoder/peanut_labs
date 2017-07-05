module PeanutLabs
  class CredentialsMissingError < StandardError; end
  class UserIdMissingError < StandardError; end
  class UserIdAlphanumericError < StandardError; end
  class DateOfBirthMissingError < StandardError; end
  class SexMissingError < StandardError; end
  class CountryMissingError < StandardError; end
  class PayloadObjectError < StandardError; end
  class PayloadMandatoryError < StandardError; end
end
