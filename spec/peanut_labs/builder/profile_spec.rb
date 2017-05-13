# frozen_string_literal: true
require 'spec_helper'
require 'json'

describe PeanutLabs::Builder::Profile do
  USER_ID = 'user1'.freeze
  let!(:app_id) { '0000' }
  let!(:app_key) { 'd755913ed731c335656a9578be648aa0' }

  DEFAULT_PARAMS = { user_id: USER_ID, dob: '2015-06-19', sex: '1', country: 'EE' }

  subject { PeanutLabs::Builder::Profile.new(app_id: app_id, app_key: app_key) }

  it 'should return user_id' do
    expect(JSON.parse(subject.call(DEFAULT_PARAMS))['user_id']).to eql "#{USER_ID}-#{app_id}-aa3ad22725"
  end

  context 'should present a country' do
    it 'correct value' do
      expect(JSON.parse(subject.call(DEFAULT_PARAMS))['cc']).to eql "EE"
      expect(JSON.parse(subject.call(DEFAULT_PARAMS.merge(country: 'US')))['cc']).to eql "US"
    end

    it 'incorrect value' do
      expect { subject.call(DEFAULT_PARAMS.merge(country: 'ZZZ')) }.to raise_error(PeanutLabs::CountryMissingError)
      expect { subject.call(DEFAULT_PARAMS.merge(country: 'ZZ')) }.to raise_error(PeanutLabs::CountryMissingError)
    end

    it 'missing value' do
      expect { subject.call(DEFAULT_PARAMS.merge(country: nil)) }.to raise_error(PeanutLabs::CountryMissingError)
    end
  end

  context 'should return sex' do
    it 'empty' do
      [0, '0', 'wrong', 'shemale'].each do |val|
        expect { subject.call(DEFAULT_PARAMS.merge(sex: val)) }.to raise_error(PeanutLabs::SexMissingError)
      end
    end

    it 'male' do
      [1, '1', 'm', 'MALE', 'male', 'M'].each do |val|
        expect(JSON.parse(subject.call(DEFAULT_PARAMS.merge(sex: val)))['sex']).to eql '1'
      end
    end

    it 'female' do
      [2, '2', 'f', 'FEMALE', 'female', 'F'].each do |val|
        expect(JSON.parse(subject.call(DEFAULT_PARAMS.merge(sex: val)))['sex']).to eql '2'
      end
    end

  end

  it 'should provide date of birth' do
    Timecop.freeze(Time.local(2015, 6, 19, 11, 30, 0)) do
      [DateTime.now, Time.now, '2015-06-19'].each do |date|
        expect(JSON.parse(subject.call(DEFAULT_PARAMS.merge(dob: date)))['dob']).to eql "2015-06-19"
      end
    end
  end

  it 'should error out for malformed DateOfBirth' do
    Timecop.freeze(Time.local(2015, 6, 19, 11, 30, 0)) do
      [nil, '', '1206-19-2015', 'some-random-word'].each do |date|
        expect { subject.call(DEFAULT_PARAMS.merge(dob: date)) }.to raise_error(PeanutLabs::DateOfBirthMissingError)
      end
    end
  end

  it 'should throw error if sex is missing' do
    expect { subject.call(DEFAULT_PARAMS.merge(sex: nil)) }.to raise_error(PeanutLabs::SexMissingError)
  end

  it 'should throw error if user_id is missing' do
    expect { subject.call(DEFAULT_PARAMS.merge(user_id: nil)) }.to raise_error(PeanutLabs::UserIdMissingError)
  end

  it 'should throw error if dob is missing' do
    expect { subject.call(DEFAULT_PARAMS.merge(dob: nil)) }.to raise_error(PeanutLabs::DateOfBirthMissingError)
  end
end
