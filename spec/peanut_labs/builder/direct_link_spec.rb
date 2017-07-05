require 'spec_helper'

describe PeanutLabs::Builder::DirectLink do
  let(:pub_id)  { '0000' }
  let(:app_key) { 'd755913ed731c335656a9578be648aa0' }
  let(:user_id) { 'user1' }

  before do
    PeanutLabs::Credentials.id  = pub_id
    PeanutLabs::Credentials.key = app_key
  end

  subject { PeanutLabs::Builder::DirectLink }

  it 'should return a link' do
    expect(
      subject.call(user_id)
    ).to eql 'https://dlink.peanutlabs.com/direct_link/?pub_id=0000&user_id=user1-0000-aa3ad22725'
  end

  it 'should add sub_id to link' do
    expect(
      subject.call(user_id, sub_id: 'random_sub_id')
    ).to eql 'https://dlink.peanutlabs.com/direct_link/?pub_id=0000&user_id=user1-0000-aa3ad22725&sub_id=random_sub_id'
  end

  it 'should add zl to link' do
    expect(
      subject.call(user_id, zl: 'es')
    ).to eql 'https://dlink.peanutlabs.com/direct_link/?pub_id=0000&user_id=user1-0000-aa3ad22725&zl=es'
  end

  context 'with payload' do
    it 'returns expected attributes' do
      payload = subject.call(user_id, payload: { cc: 'US', sex: 1, dob: '1990-04-10' }).split('?').last
      keys    = URI.decode_www_form(payload).map { |k, v| k }

      expect(keys).to include('pub_id', 'user_id', 'payload', 'iv')
    end
  end

  context 'throws error' do
    it 'if user_id is missing' do
      expect { subject.call(nil) }.to raise_error(PeanutLabs::UserIdMissingError)
      expect { subject.call("") }.to raise_error(PeanutLabs::UserIdMissingError)
    end

    it 'if user_id is not alphanumeric' do
      expect { subject.call('123~@~abc') }.to raise_error(PeanutLabs::UserIdAlphanumericError)
    end

    it 'if payload is not a hash' do
      expect { subject.call(user_id, payload: :symbol) }.to raise_error(PeanutLabs::PayloadObjectError)
    end

    it 'if mandatory attributes missed' do
      expect { subject.call(user_id, payload: { sex: 1 }) }.to raise_error(PeanutLabs::PayloadMandatoryError)
    end

    it 'if Credential is missing' do
      PeanutLabs::Credentials.id  = nil
      PeanutLabs::Credentials.key = nil

      expect { subject.call(user_id) }.to raise_error PeanutLabs::CredentialsMissingError
    end
  end
end
