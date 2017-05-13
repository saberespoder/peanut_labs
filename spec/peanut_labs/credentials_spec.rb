# frozen_string_literal: true
require 'spec_helper'

describe PeanutLabs::Credentials do
  let(:app_id) { '0000' }
  let(:app_key) { 'd755913ed731c335656a9578be648aa0' }

  before { ENV['PEANUTLABS_ID'] = nil }
  before { ENV['PEANUTLABS_KEY'] = nil }

  subject { PeanutLabs::Credentials }

  it 'can read from ENV variable' do
    ENV['PEANUTLABS_ID'] = app_id
    ENV['PEANUTLABS_KEY'] = app_key

    subject.new.tap do |inst|
      expect(inst.id).to eql(app_id)
      expect(inst.key).to eql(app_key)
    end

  end

  it 'can read from PARAMS' do
    subject.new(app_id: app_id, app_key: app_key).tap do |inst|
      expect(inst.id).to eql(app_id)
      expect(inst.key).to eql(app_key)
    end
  end

  context "should not work if app id/key is missing" do
    it { expect { subject.new }.to raise_error(PeanutLabs::CredentialsMissingError) }
    it { expect { subject.new(nil) }.to raise_error(PeanutLabs::CredentialsMissingError) }
    it { expect { subject.new(app_id: app_id) }.to raise_error(PeanutLabs::CredentialsMissingError) }
    it { expect { subject.new(app_id: '', app_key: '') }.to raise_error(PeanutLabs::CredentialsMissingError) }
  end
end
