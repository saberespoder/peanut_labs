# frozen_string_literal: true
require 'spec_helper'

describe PeanutLabs::Builder::UserId do
  let(:user_id) { 'user1' }
  let(:labs_id) { '0000' }
  let(:app_key) { 'd755913ed731c335656a9578be648aa0' }

  it 'should return something' do
    PeanutLabs::Credentials.id = labs_id
    PeanutLabs::Credentials.key = app_key

    iframe_id = PeanutLabs::Builder::UserId.new(user_id).call.split('-')

    expect(iframe_id[0]).to eql user_id
    expect(iframe_id[1]).to eql labs_id
    expect(iframe_id[2]).to eql 'aa3ad22725'
  end

  it 'errors out if credentials are missing' do
    PeanutLabs::Credentials.id = nil
    PeanutLabs::Credentials.key = nil

    expect{
      PeanutLabs::Builder::UserId.new('random').call
    }.to raise_error PeanutLabs::CredentialsMissingError
  end
end
