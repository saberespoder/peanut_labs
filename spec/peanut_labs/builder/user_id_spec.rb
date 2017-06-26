# frozen_string_literal: true
require 'spec_helper'

describe PeanutLabs::Builder::UserId do
  # Following documentation lead: http://peanut-labs.github.io/publisher-doc/#iframe-getuserid
  let(:user_id) { 'user1' }
  let(:labs_id) { '0000' }
  let(:app_key) { 'd755913ed731c335656a9578be648aa0' }

  it 'should return end user id' do
    PeanutLabs::Credentials.id  = labs_id
    PeanutLabs::Credentials.key = app_key

    end_user_id = PeanutLabs::Builder::UserId.new(user_id).call

    expect(end_user_id).to eq('user1-0000-aa3ad22725')
  end

  it 'errors out if credentials are missing' do
    PeanutLabs::Credentials.id = nil
    PeanutLabs::Credentials.key = nil

    expect{
      PeanutLabs::Builder::UserId.new('random').call
    }.to raise_error PeanutLabs::CredentialsMissingError
  end

  it 'errors out if public ID is not alphanumeric' do
    expect{
      PeanutLabs::Builder::UserId.new('123~@~abc').call
    }.to raise_error PeanutLabs::UserIdAlphanumericError
  end
end
