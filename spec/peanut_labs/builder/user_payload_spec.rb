require 'spec_helper'

describe PeanutLabs::Builder::UserPayload do
  subject { PeanutLabs::Builder::UserPayload }
  let(:payload) { subject.call }

  it "returns proper iv attribute" do
    expect(CGI.unescape(payload[:iv]).length).to eq 24
  end
end
