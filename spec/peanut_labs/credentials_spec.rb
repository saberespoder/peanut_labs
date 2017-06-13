# frozen_string_literal: true
require 'spec_helper'

describe PeanutLabs::Credentials do
  let(:app_id) { '0000' }
  let(:app_key) { 'd755913ed731c335656a9578be648aa0' }

  subject { PeanutLabs::Credentials }

  it 'can read from ENV variable' do
    PeanutLabs::Credentials.id = app_id
    PeanutLabs::Credentials.key = app_key

    expect(PeanutLabs::Credentials.id).to eql(app_id)
    expect(PeanutLabs::Credentials.key).to eql(app_key)
  end

  context "should not work if app id/key is missing" do
    before { PeanutLabs::Credentials.id = nil }
    before { PeanutLabs::Credentials.key = nil }

    it { expect { subject.id }.to raise_error(PeanutLabs::CredentialsMissingError) }
    it { expect { subject.key }.to raise_error(PeanutLabs::CredentialsMissingError) }
  end
end
