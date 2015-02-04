require 'multi_json'
require 'trustev/error'

module Trustev

  @@api_base = 'https://app.trustev.com/api/v'

  def self.raise_error(response)
    error_response = MultiJson.load(response.body, symbolize_keys: true)
    raise Error.new('Bad API response', response.code, error_response[:Message])
  end

  def self.invalid_token?
    now = Time.now
    timestamp = @@token_expire? @@token_expire.timestamp : 0
    @@token.nil? || timestamp-600 <= now
  end

  def self.send_request(path, body, method, _expect_json=false, requires_token=true)
    Trustev.do_send_request(path, body, method, true, requires_token)
  end
end
