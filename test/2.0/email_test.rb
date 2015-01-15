require_relative 'test_helper'

describe Trustev::Email do
  before do
    trustev_case = build_case
    @case_id = trustev_case.create[:Id]
    @email = build_email case_id: @case_id
  end

  describe 'when creating an email' do
    it 'must return a valid response' do
      create_case_attribute @email
    end
  end

  describe 'when updating an email' do
    it 'must return a valid response' do
      update_case_attribute @email, self.method(:build_email), @case_id, { email: Faker::Internet.email }
    end
  end

  describe 'when retrieving an email' do
    it 'must return a valid response' do
      retrieve_case_attribute @email, Trustev::Email, @case_id
    end
  end

  describe 'when retrieving all emails' do
    it 'must return a valid response' do
      retrieve_all_case_attribute Trustev::Email, @case_id
    end
  end
end
