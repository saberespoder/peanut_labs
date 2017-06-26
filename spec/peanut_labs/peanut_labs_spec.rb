# frozen_string_literal: true
require 'spec_helper'

describe PeanutLabs do
  let(:labs_id) { '0000' }
  let(:app_key) { 'd755913ed731c335656a9578be648aa0' }
  let(:user_id) { 'user1'}

  before do
    PeanutLabs::Credentials.id  = labs_id
    PeanutLabs::Credentials.key = app_key
  end

  it "should return equal PIDs in direct link and iframe URLs" do
    direct_link_url = PeanutLabs::Builder::DirectLink.call(user_id)
    iframe_url      = PeanutLabs::Builder::IframeUrl.call(id: user_id)

    expect(direct_link_url.split("=").last).to eq(iframe_url.split("=").last)
  end
end
