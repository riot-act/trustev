require_relative 'test_helper'

describe Trustev::DigitalSignature do

  before do
    @expected_signature = '690de8cb3703b536852e4683843940c1555fc48685fdb705061a62d33f581f43'
  end

  describe 'when a digital signature is verified' do
    it 'must say it is valid' do
      signature = Trustev::DigitalSignature.new(
        @expected_signature,
        '20141106213006',
        '4cec59b2-37f9-461e-9abc-861267e1a4d7',
        ''
      )
      signature.invalid?.must_equal false
    end
  end

  describe 'when an invalid digital signature is verified' do
    it 'must say it is NOT valid' do
      signature = Trustev::DigitalSignature.new(
        @expected_signature,
        '20151106213006',
        '4cec59b2-37f9-461e-9abc-861267e1a4d7',
        ''
      )
      signature.invalid?.must_equal true
    end
  end
end