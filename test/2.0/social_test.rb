require_relative 'test_helper'

describe Trustev::Social do
  before do
    trustev_case = build_case
    @case_id = trustev_case.create[:Id]
    @social = build_social case_id: @case_id
  end

  describe 'when creating a social' do
    it 'must return a valid response' do
      create_case_attribute @social
    end
  end

  describe 'when updating a social' do
    it 'must return a valid response' do
      update_case_attribute @social, self.method(:build_social), @case_id, { social_id: Faker::Number.number(5) }
    end
  end

  describe 'when retrieving an social' do
    it 'must return a valid response' do
      retrieve_case_attribute @social, Trustev::Social, @case_id
    end
  end

  describe 'when retrieving all social' do
    it 'must return a valid response' do
      retrieve_all_case_attribute Trustev::Social, @case_id
    end
  end
end
