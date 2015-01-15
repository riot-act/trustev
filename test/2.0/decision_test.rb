require_relative 'test_helper'

describe Trustev::Decision do

  describe 'when an decision is requested' do
    it 'must return the decision' do
      skip 'Broken on trustev\'s end'
      case_id = build_case(nil, "#{SecureRandom.hex}pass").create[:Id]
      decision = Trustev::Decision.new case_id
      response = decision.retrieve
      puts response
    end
  end
end
