require_relative 'test_helper'

describe Trustev::Status do
  before do
    trustev_case = build_case
    @case_id = trustev_case.create[:Id]
    @status = build_status case_id: @case_id
  end

  describe 'when creating an status' do
    it 'must return a valid response' do
      create_case_attribute @status
    end
  end

  describe 'when retrieving a status' do
    it 'must return a valid response' do
      retrieve_case_attribute @status, Trustev::Status, @case_id
    end
  end

  describe 'when retrieving all status' do
    it 'must return a valid response' do
      retrieve_all_case_attribute Trustev::Status, @case_id
    end
  end
end
