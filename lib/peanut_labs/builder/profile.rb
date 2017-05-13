require_relative '../credentials'
require_relative '../parser/date_of_birth'
require_relative 'user_id'

module PeanutLabs
  module Builder
    class Profile
      COUNTRY_CODES = %w(
        AF AX AL DZ AS AD AO AI AQ AG AR AM AW AU AT AZ BS BH BD BB BY BE BZ BJ BM BT BO BA BW BV BR VG KH CM CA CV KY
        CF TD CL CN HK MO CX CC CO KM CG CD CK CR CI HR CU CY CZ DK DJ DM DO EC EG SV GQ ER EE ET FK FO BN BG BF BI IO
        FJ FI FR GF PF TF GA GM GE DE GH GI GR GL GD GP GU GT GG GN GW GY HT HM VA HN HU IS IN ID IR IQ IE IM IL IT JM
        JP JE JO KZ KE KI KP KR KW KG LA LV LB LS LR LY LI LT LU MK MG MW MY MV ML MT MH MQ MR MU YT MX FM MD MC MN ME
        MS MA MZ MM NA NR NP NL AN NC NZ NI NE NG NU NF MP NO OM PK PW PS PA PG PY PE PH PN PL PT PR QA RE RO RU RW BL
        SH KN LC MF PM VC WS SM ST SA SN RS SC SL SG SK SI SB SO ZA GS SS ES LK SD SR SJ SZ SE CH SY TW TJ TZ TH TL TG
        TK TO TT TN TR TM TC TV UG UA AE GB US UM UY UZ VU VE VN VI WF EH YE ZM ZW
      ).freeze

      def initialize(params = nil)
        @credentials = params[:credentials] || PeanutLabs::Credentials.new(params)
      end

      # This class build a user profile and validates following parameters:
      #
      # - params[:user_id] - mandatory, will be later built to user_go_id
      # - params[:cc] - mandatory, will be validated for correctness
      # - params[:dob] - mandatory, all DateTime, Time, Date object will be formatted, already formatted string is accepted
      # - params[:sex] - mandatory, will attempt to interpret any common definitions of SEX
      #
      # more info http://peanut-labs.github.io/publisher-doc/index.html#iv-payload
      #
      # you can map more parameters, you can find mapping for additional fields here:
      # https://docs.google.com/spreadsheets/d/1v-qYMKBUVGNTrG4BSL_hIYsg9v_eLMBfehETtAqg240/edit#gid=1572744670

      def call(params)
        raise PeanutLabs::UserIdMissingError if params[:user_id].nil?
        raise PeanutLabs::DateOfBirthMissingError if params[:dob].nil?
        raise PeanutLabs::SexMissingError if params[:sex].nil?
        raise PeanutLabs::CountryMissingError if params[:country].nil?

        {
          user_id: UserId.new(credentials: credentials).call(params[:user_id]),
          cc: country(params[:country]),
          dob: date_of_birth(params[:dob]),
          sex: sex(params[:sex])
        }.to_json
      end

      private

      attr_reader :credentials

      def country(value)
        if COUNTRY_CODES.include? value
          value
        else
          raise PeanutLabs::CountryMissingError.new("Wrong value provided #{value}")
        end
      end

      def sex(value)
        if (sex = PeanutLabs::Parser::Sex.call(value))
          sex
        else
          raise PeanutLabs::SexMissingError.new("Wrong value provided #{value}")
        end
      end

      def date_of_birth(value)
        if (dob = PeanutLabs::Parser::DateOfBirth.profile(value))
          dob
        else
          raise PeanutLabs::DateOfBirthMissingError.new("Wrong value provided #{value}")
        end
      end
    end
  end
end
