require 'spec_helper'

describe PeanutLabs::DirectLink do
  let(:app_id) { '1000' }
  let(:user_id) { 'user123123' }
  let(:user_go_id) { '41597ceacf' }

  subject { PeanutLabs::DirectLink.new(app_id: app_id, app_key: '123123123123123123') }


  it 'should add sub_id to link' do
    expect(
      subject.call(user_id, 'random_sub_id')
    ).to eql "https://dlink.peanutlabs.com/direct_link/?pub_id=#{app_id}&user_id=#{user_id}-#{app_id}-#{user_go_id}&sub_id=random_sub_id"
  end

  it 'should return a link' do
    expect(
      subject.call(user_id)
    ).to eql "https://dlink.peanutlabs.com/direct_link/?pub_id=#{app_id}&user_id=#{user_id}-#{app_id}-#{user_go_id}"
  end

  context 'if user_id is missing throws error' do
    it { expect { subject.call(nil) }.to raise_error(PeanutLabs::UserIdMissingError) }
    it { expect { subject.call("") }.to raise_error(PeanutLabs::UserIdMissingError) }
  end
end
