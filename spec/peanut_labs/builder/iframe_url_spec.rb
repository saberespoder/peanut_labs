# frozen_string_literal: true
require 'spec_helper'

describe PeanutLabs::Builder::IframeUrl do
  USER_ID = 'user1'
  LABS_ID = '0000'
  APP_KEY = 'd755913ed731c335656a9578be648aa0'
  END_POINT = 'https://www.peanutlabs.com/userGreeting.php'

  subject { PeanutLabs::Builder::IframeUrl.new(app_id: LABS_ID, app_key: APP_KEY) }

  it 'return url only with USER_ID inside' do
    expect(subject.call(id: USER_ID)).to eql("#{END_POINT}?userId=#{USER_ID}-#{LABS_ID}-aa3ad22725")
  end

  it 'should work with all parameters provided' do
    Timecop.freeze(Time.local(2015, 6, 19, 11, 30, 0)) do
      expect(subject.call(
        id: USER_ID, dob: Date.today, sex: 1)
      ).to eql("#{END_POINT}?userId=#{USER_ID}-0000-aa3ad22725&sex=1&dob=06-19-2015")
    end
  end

  context 'appends dob if date of birth was provided' do
    it 'should return DOB' do
      Timecop.freeze(Time.local(2015, 6, 19, 11, 30, 0)) do
        [Date.today, DateTime.now, Time.now, '06-19-2015'].each do |date|
          expect(subject.call(id: USER_ID, dob: date)).to eql("#{END_POINT}?userId=#{USER_ID}-#{LABS_ID}-aa3ad22725&dob=06-19-2015")
        end
      end
    end

    it 'wrong values for DOB' do
      Timecop.freeze(Time.local(2015, 6, 19, 11, 30, 0)) do
        [nil, '', '1206-19-2015', 'some-random-word'].each do |date|
          expect(subject.call(id: USER_ID, dob: date)).to eql("#{END_POINT}?userId=#{USER_ID}-#{LABS_ID}-aa3ad22725")
        end
      end
    end
  end

  context 'appends sex parameter if sex is provided' do
    it 'empty' do
      [0, '0', 'wrong', 'shemale'].each do |val|
        expect(subject.call(id: USER_ID, sex: val)).to eql("#{END_POINT}?userId=#{USER_ID}-#{LABS_ID}-aa3ad22725")
      end
    end

    it 'male' do
      [1, '1', 'm', 'MALE', 'male', 'M'].each do |val|
        expect(subject.call(id: USER_ID, sex: val)).to eql("#{END_POINT}?userId=#{USER_ID}-#{LABS_ID}-aa3ad22725&sex=1")
      end
    end

    it 'female' do
      [2, '2', 'f', 'FEMALE', 'female', 'F'].each do |val|
        expect(subject.call(id: USER_ID, sex: val)).to eql("#{END_POINT}?userId=#{USER_ID}-#{LABS_ID}-aa3ad22725&sex=2")
      end
    end
  end

  it 'id should be required and error raised if missing' do
    expect { subject.call(id: '') }.to raise_error(PeanutLabs::UserIdMissingError)
    expect { subject.call(id: nil) }.to raise_error(PeanutLabs::UserIdMissingError)
    expect { subject.call(wrong_id: 'test') }.to raise_error(PeanutLabs::UserIdMissingError)
  end
end
