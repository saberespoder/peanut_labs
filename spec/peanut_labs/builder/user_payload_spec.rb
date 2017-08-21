require 'spec_helper'

describe PeanutLabs::Builder::UserPayload do
  let(:app_id)      { '9191' }
  let(:app_key)     { '30ff84086b72b4923c402a352477fcce' }
  let(:init_vector) { nil } # Serves testing purposes and will not be passed in the real life
  let(:data) do
    {
      'user_id' => 'c6d8fc67b58f455986849c700c0a8f1b-9191-ef72be15f5',
      'cc'      => 'US',
      'sex'     => 1,
      'dob'     => '1990-04-10',
      'postal'  => '94104',
      'profile_data' => {
        'q122' => ['qx122-0'],
        'q159' => ['qx159-1'],
        'q102' => ['qx102-105'],
        'q158' => ['qx158-3'],
        'q101' => ['qx101-2'],
        'q157' => ['3'],
        'ch-m' => ['4-2004'],
        'ch-f' => ['10-1998', '11-1999']
      }
    }
  end
  before do
    PeanutLabs::Credentials.id  = app_id
    PeanutLabs::Credentials.key = app_key
  end
  subject { PeanutLabs::Builder::UserPayload.call(data, init_vector) }

  it 'has expected attributes' do
    expect(subject.keys).to include(:iv, :payload)
  end

  context 'init vector' do
    it 'always unique' do
      first_call  = subject
      second_call = PeanutLabs::Builder::UserPayload.call(data)
      expect(first_call[:iv]).not_to eq(second_call[:iv])
    end
    it 'has expected length' do
      expect(subject[:iv].length).to eq 24
    end
  end

  context 'payload' do
    context 'with defined vector' do
      let(:init_vector) { 'LB4Fs5awRnFYoLm+MTcANg==' }
      it 'returns expected value' do
        expect(subject[:payload]).to eq 'TFCf/rT3iNqGXmAYRkwyXmVO14LXg7R2c0B4UFslXacbIzxtbltCN5Ww4b88eMiNWAoHWgCYddTRsxepEO3/5hpKc+11z8YAPeiT45CVUtfqCsdAwRp01n5w6z4V9zp307R+icwhT5dzc+Bj7lMxlkWAZI2MBxlAB4weBxFoQTggzWeyhc1z4sCpLgajyfB3jRsEtKsyQQKT5jk4qJ4b8jG90Oc+SCcYXAbk40s2o2Tsq1sNnmfYQk/f5DNPJ2JKib5hcVfq1woCBySWrJRf3GQjEba8rR3Ca/4ZSfXKZUClFrkzxfBa75hyzyxUeLI2x/X4R3+vvdqZuSMZMVa6ZDUyfwgj0YIao+un/a9G8gGWwRby4TJdNJKMnWbQ2mv3a9qf5FejyoPQVd4aYJwlbg=='
      end
    end

    context 'with random vector' do
      let(:iv)      { Base64.strict_decode64(subject[:iv]) }
      let(:payload) { Base64.strict_decode64(subject[:payload]) }

      it 'can be decrypted' do
        decipher          = OpenSSL::Cipher.new('AES-128-CBC').decrypt
        decipher.iv       = iv
        decipher.key      = [app_key].pack('H*')
        decrypted_payload = decipher.update(payload) + decipher.final

        expect(JSON.parse(decrypted_payload)).to eq data
      end
    end
  end
end
