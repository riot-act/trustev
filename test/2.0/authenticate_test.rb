require_relative 'test_helper'

describe Trustev::Authenticate do

  describe 'when an authentication token is requested' do
    it 'must set the authentication token' do
      Trustev::Authenticate.retrieve_token
      Trustev.token.wont_be_nil
      Trustev.token_expire.wont_be_nil
      Trustev.token_expire.instance_of?(Trustev::Timestamp).must_equal true
    end
  end
end
