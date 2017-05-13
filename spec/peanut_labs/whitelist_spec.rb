require 'spec_helper'
require_relative '../../lib/peanut_labs/whitelist'

describe PeanutLabs::Whitelist do
  Request = Struct.new(:remote_ip)

  subject { PeanutLabs::Whitelist }

  it "doesn't block whitelisted ips" do
    expect(subject.matches?(Request.new('107.22.162.83'))).to be_falsy
  end

  it "blocks non-whitelisted ips" do
    expect(subject.matches?(Request.new('127.0.0.1'))).to be_truthy
  end
end
