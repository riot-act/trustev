require_relative 'test_helper'
require 'securerandom'

describe Trustev::Social do

  before do
    @social_network_id = Random.rand(0..9999999999)
    Trustev::Social.delete(0, @social_network_id)
  end

  describe 'when adding social network data' do
    it 'must return a good response code' do
      create_social.code.must_equal 200
    end
  end

  describe 'when updating social network data' do
    it 'must turn a good response code' do
      create_social
      Trustev::Social.update(
        {
          type: 0,
          id: @social_network_id,
          short_term_token: 'CAAGEIkkiehQrXSIK9vHOiPnZB139M',
          long_term_token: 'CAAGXgR7VWu',
          short_term_expiry: 1390238654000,
          long_term_expiry: 1395417029000,
          secret: '84bcd7da0e967139652f7ce59e4c859e'
        }
      ).code.must_equal 200
    end
  end

  describe 'when deleting social network data' do
    it 'must return a good response code' do
      create_social
      Trustev::Social.delete(0, @social_network_id).code.must_equal 200
    end
  end

  private

  def create_social
    Trustev::Social.create([
      {
        type: 0,
        id: @social_network_id,
        short_term_token: 'CAAGEIkkiehQrXSIK9vHOiPnZB139M',
        long_term_token: 'CAAGXgR7VWu',
        short_term_expiry: 1390238654000,
        long_term_expiry: 1395417029000,
        secret: '84bcd7da0e967139652f7ce59e4c859e'
      }
    ])
  end
end