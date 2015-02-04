require 'trustev/error'

module Trustev

  @@api_base = 'https://api.trustev.com/v'

  def self.raise_error(response)
    raise Error.new('Bad API response', response.code, response.body.message) if response.code != 200
  end

  def self.invalid_token?
    now = Time.now.to_i
    timestamp = @@token_expire
    @@token.nil? || timestamp-600 <= now
  end

  def self.send_request(path, body, method, expect_json=false, requires_token=true)
    Trustev.do_send_request(path, { request:  body }, method, expect_json, requires_token)
  end
end
