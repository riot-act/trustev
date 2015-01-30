require_relative 'test_helper'

describe Trustev::Decision do

  describe 'when an decision is requested' do
    it 'must return the decision' do
      case_id = build_case(nil, "#{SecureRandom.hex}pass").create[:Id]
      decision = Trustev::Decision.new case_id
      response = decision.retrieve
      response[:Id].wont_be_nil
    end
  end
end
