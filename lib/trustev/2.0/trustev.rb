require 'multi_json'
require 'trustev/error'

module Trustev

  @@api_base = 'https://app.trustev.com/api/v'

  STATUS_TYPES = {
    completed: 0,
    rejecetd_fraud: 1,
    rejected_auth_failure: 2,
    rejected_suspicious: 3,
    cancelled: 4,
    chargeback_fraud: 5,
    chargeback_other: 6,
    refunded: 7,
    placed: 8,
    on_hold_review: 9
  }

  DECISIONS = {
    unknown: 0,
    pass: 1,
    flag: 2,
    fail: 3
  }

  PAYMENT_TYPES = {
    none: 0,
    credit_card: 1,
    debit_card: 2,
    direct_debit: 3,
    paypal: 4,
    bitcoin: 5
  }

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
