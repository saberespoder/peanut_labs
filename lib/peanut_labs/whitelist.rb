module PeanutLabs
  class Whitelist
    # This should be used in rails routes.rb file, like this:
    #
    # post "callback/peanutlabs" => "callback#peanutlabs", constraints: PeanutLabs::Whitelist
    #

    RN_IPS = ['75.101.154.153',
              '54.243.235.176',
              '54.243.210.15',
              '54.243.204.6',
              '54.243.150.156',
              '54.243.150.126',
              '54.243.149.248',
              '54.243.149.247',
              '54.243.146.21',
              '54.243.143.97',
              '50.19.92.139',
              '50.17.194.132',
              '50.17.193.185',
              '50.17.191.62',
              '50.17.191.143',
              '50.17.190.69',
              '50.17.190.174',
              '50.17.189.251',
              '50.17.189.201',
              '50.17.189.138',
              '50.17.187.32',
              '50.17.187.218',
              '50.17.187.192',
              '50.17.187.145',
              '50.17.186.7',
              '50.17.186.39',
              '50.17.184.98',
              '50.17.184.153',
              '50.17.182.38',
              '50.17.182.19',
              '50.17.182.17',
              '50.17.181.130',
              '50.17.181.118',
              '50.17.181.11',
              '50.16.250.192',
              '50.16.249.58',
              '50.16.249.162',
              '50.16.245.185',
              '50.16.243.67',
              '50.16.241.60',
              '50.16.239.186',
              '50.16.236.39',
              '23.21.123.40',
              '184.73.254.159',
              '184.73.254.133',
              '184.73.250.161',
              '184.73.249.128',
              '184.73.244.77',
              '184.73.196.208',
              '184.73.166.67',
              '184.73.158.48',
              '184.73.153.111',
              '184.72.230.119',
              '184.72.222.51',
              '184.72.222.104',
              '184.72.221.219',
              '174.129.37.199',
              '174.129.242.30',
              '174.129.240.137',
              '174.129.238.17',
              '174.129.237.1',
              '174.129.22.190',
              '174.129.219.230',
              '174.129.209.23',
              '174.129.209.2',
              '107.22.164.69',
              '107.22.164.67',
              '107.22.164.59',
              '107.22.164.55',
              '107.22.164.53',
              '107.22.164.5',
              '107.22.162.83',
              '107.22.160.89',
              '107.22.160.31',
              '107.22.160.14',
              '107.20.248.88',
              '107.20.246.140',
              '107.20.235.89',
              '107.20.201.76',
              '107.20.152.198'].freeze

    def self.matches?(request)
      !RN_IPS.include?(request.remote_ip)
    end

  end
end
