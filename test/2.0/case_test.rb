require_relative 'test_helper'

describe Trustev::Case do
  describe 'when creating a case' do
    it 'must return a valid response' do
      trustev_case = build_case
      response = trustev_case.create
      response[:Id].wont_be_nil
    end
  end

  describe 'when updating a case' do
    it 'must return a valid response' do
      skip 'Intermittently broken at Trustev'
      trustev_case = build_case
      response = trustev_case.create
      case_id = response[:Id]
      case_number = response[:CaseNumber]
      trustev_case = Trustev::Case.new(case_id, { case_number: case_number, customer: build_customer.build })
      response = trustev_case.update
      response[:Id].must_equal case_id
    end
  end

  describe 'when retrieving a case' do
    it 'must return a valid response' do
      skip 'Intermittently broken at Trustev'
      case_id = build_case.create[:Id]
      Trustev::Case.new(case_id).retrieve[:Id].must_equal case_id
    end
  end
end
