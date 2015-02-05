require 'trustev/error'

module Trustev

  @@api_base = 'https://api.trustev.com/v'

  STATUS_TYPES = {
    init: 0,
    placed: 1,
    refunded: 2,
    rejected: 3,
    completed: 5,
    chargeback: 8
  }

  REASON_TYPES = {
    system: 0,
    fraud: 1,
    complaint: 2,
    remorse: 3,
    other: 4
  }

  SCORE_SOURCES = {
    address: 0,
    behaviour: 1,
    device: 2,
    email: 3,
    facebook: 4,
    IP: 5,
    transaction: 6,
    trustev: 7,
    velocity: 8
  }

  SCORE_PARAMETERS = {
    overall: 0,
    billing: 1,
    delivery: 2,
    input: 3,
    domain: 4,
    address: 5,
    IP: 6,
    proxy: 7,
    VPN: 8,
    value: 9,
    velocity: 10,
    legitimacy: 11,
    pattern: 12,
    hustle: 13
  }

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
