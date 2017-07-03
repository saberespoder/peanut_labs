require 'spec_helper'

describe PeanutLabs::Builder::UserPayload do
  let(:app_key) { 'abcdef0123456789abcdef0123456789' }
  let(:data) do
    {
      user_id: 'user001-1001-2389d74882',
      cc: 'US',
      sex: 1,
      dob: '1990-04-10',
      postal: '94104',
      profile_data: {
        q122: ['qx122-0'],
        q159: ['qx159-1'],
        q102: ['qx102-105'],
        q158: ['qx158-3'],
        q101: ['qx101-2'],
        q157: ['3'],
        'ch-m' => ['4-2004'],
        'ch-f' => ['10-1998', '11-1999']
      }
    }
  end
  subject { PeanutLabs::Builder::UserPayload.call(data) }

  it 'iv attribute has expected length' do
    expect(CGI.unescape(subject[:iv]).length).to eq 24
  end

  it 'returns encrypted payload' do
    expect(subject[:payload]).to eq 'aVJyjog7mQrtUMUDZONYOAlSqBRa1%2BoMIhZhH6Qahs8hvWSflN7s7Z98fR8QyeqfdQ8blnp5x3B3IbuwwNQBORTfXRJ0lKWytvXa%2BUK%2FUCYOFPSvasgGIKVtolrHy7n6vJujtbpC3IKJxnWRbOtKV5Q5xw9Vz6hgzvhf%2FwNV3m9N0qkMxFon%2FNEu933mbQOEjgwswjWHjFGQ5%2BugTzCT5PX47nDnV8vXR014KCZcjGw8DtkGog5A%2B%2B4SdBbEOP0M9g165ZQ5nsFtyjy8960bRGef7UNey4hmoFiFvqlws%2BAhs7YAT%2Fb7c97K6amSCZm9TocPG4tJAqZYgoHTCApFgIuGbvfnlt%2B0%2FPSehNluyl8%3D'
  end
end
