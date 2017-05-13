# frozen_string_literal: true
require 'spec_helper'

describe PeanutLabs::Builder::UserId do
  let(:user_id) { 'user1' }
  let(:labs_id) { '0000' }
  let(:app_key) { 'd755913ed731c335656a9578be648aa0' }

  it 'should return something' do
    iframe_id = PeanutLabs::Builder::UserId.new(
      app_id: labs_id,
      app_key: app_key
    ).call(user_id).split('-')

    expect(iframe_id[0]).to eql user_id
    expect(iframe_id[1]).to eql labs_id
    expect(iframe_id[2]).to eql 'aa3ad22725'
  end
end
