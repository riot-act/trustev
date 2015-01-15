require_relative 'test_helper'

describe Trustev::Error do

  describe 'when an error is created' do
    it 'must convert to a string properly' do
      error = Trustev::Error.new('Test Message', 404, 'Invalid API Response')
      error.to_s.must_equal '(404) Test Message - Invalid API Response'
    end
  end

  describe 'an error without a status code' do
    it 'should just have messages when converted to a string' do
      error = Trustev::Error.new('Test Message', nil, 'Invalid API Response')
      error.to_s.must_equal 'Test Message - Invalid API Response'
    end
  end
end
