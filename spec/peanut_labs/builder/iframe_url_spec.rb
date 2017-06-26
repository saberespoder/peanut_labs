# frozen_string_literal: true
require 'spec_helper'

describe PeanutLabs::Builder::IframeUrl do
  let(:labs_id)   { '0000' }
  let(:app_key)   { 'd755913ed731c335656a9578be648aa0' }
  let(:user_id)   { 'user1'}
  let(:end_point) { 'https://www.peanutlabs.com/userGreeting.php' }

  before do
    PeanutLabs::Credentials.id  = labs_id
    PeanutLabs::Credentials.key = app_key
  end

  subject { PeanutLabs::Builder::IframeUrl }

  it 'return url only with user_id inside' do
    expect(subject.call(id: user_id)).to eql("#{end_point}?userId=user1-0000-aa3ad22725")
  end

  it 'should work with all parameters provided' do
    Timecop.freeze(Time.local(2015, 6, 19, 11, 30, 0)) do
      expect(subject.call(
        id: user_id, dob: Date.today, sex: 1)
      ).to eql("#{end_point}?userId=user1-0000-aa3ad22725&sex=1&dob=06-19-2015")
    end
  end

  context 'appends dob if date of birth was provided' do
    it 'should return DOB' do
      Timecop.freeze(Time.local(2015, 6, 19, 11, 30, 0)) do
        [Date.today, DateTime.now, Time.now, '06-19-2015'].each do |date|
          expect(subject.call(id: user_id, dob: date)).to eql("#{end_point}?userId=user1-0000-aa3ad22725&dob=06-19-2015")
        end
      end
    end

    it 'wrong values for DOB' do
      Timecop.freeze(Time.local(2015, 6, 19, 11, 30, 0)) do
        [nil, '', '1206-19-2015', 'some-random-word'].each do |date|
          expect(subject.call(id: user_id, dob: date)).to eql("#{end_point}?userId=user1-0000-aa3ad22725")
        end
      end
    end
  end

  context 'appends sex parameter if sex is provided' do
    it 'empty' do
      [0, '0', 'wrong', 'shemale'].each do |val|
        expect(subject.call(id: user_id, sex: val)).to eql("#{end_point}?userId=user1-0000-aa3ad22725")
      end
    end

    it 'male' do
      [1, '1', 'm', 'MALE', 'male', 'M'].each do |val|
        expect(subject.call(id: user_id, sex: val)).to eql("#{end_point}?userId=user1-0000-aa3ad22725&sex=1")
      end
    end

    it 'female' do
      [2, '2', 'f', 'FEMALE', 'female', 'F'].each do |val|
        expect(subject.call(id: user_id, sex: val)).to eql("#{end_point}?userId=user1-0000-aa3ad22725&sex=2")
      end
    end
  end

  it 'id should be required and error raised if missing' do
    expect { subject.call(id: '') }.to raise_error(PeanutLabs::UserIdMissingError)
    expect { subject.call(id: nil) }.to raise_error(PeanutLabs::UserIdMissingError)
    expect { subject.call(wrong_id: 'test') }.to raise_error(PeanutLabs::UserIdMissingError)
  end

  it 'id should be alphanumeric and error raised if not' do
    expect { subject.call(id: '123~@~abc') }.to raise_error(PeanutLabs::UserIdAlphanumericError)
  end
end
