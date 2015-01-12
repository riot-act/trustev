require 'httparty'
require 'multi_json'
require 'require_all'

require 'trustev/version'
require 'trustev/error'
require 'trustev/digital_signature'

module Trustev
  @@username = nil
  @@password = nil
  @@shared_secret = nil
  @@private_key = nil
  @@public_key = nil
  @@api_version = nil
  @@token = nil
  @@token_expire = nil

  API_VERSIONS = %w(1.2 2.0)

  ADDRESS_TYPES = {
    standard: 0,
    billing: 1,
    delivery: 2
  }

  SOCIAL_NETWORK_TYPES = {
    facebook: 0,
    twitter: 1,
    linkedin: 2,
    trustev: 3,
    trustev_session: 4
  }

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

  def self.username=(username)
    @@username = username
  end

  def self.username
    @@username
  end

  def self.password=(password)
    @@password = password
  end

  def self.password
    @@password
  end

  def self.shared_secret=(shared_secret)
    @@shared_secret = shared_secret
  end

  def self.shared_secret
    @@shared_secret
  end

  def self.private_key=(private_key)
    @@private_key = private_key
  end

  def self.private_key
    @@private_key
  end

  def self.public_key=(public_key)
    @@public_key = public_key
  end

  def self.public_key
    @@public_key
  end

  def self.api_url(url='')
    @@api_base + @@api_version + '/' + url
  end

  def self.token=(token)
    @@token = token
  end

  def self.token
    @@token
  end

  def self.token_expire=(token_expire)
    @@token_expire = token_expire
  end

  def self.token_expire
    @@token_expire
  end

  def self.api_version
    @@api_version
  end

  def self.api_version=(api_version)
    @@api_version = api_version
    raise Error.new("API v#{api_version} not supported.") unless API_VERSIONS.include? api_version
    require_rel "trustev/#{api_version}"
    if api_version == '1.2'
      @@api_base = 'https://api.trustev.com/v'
    elsif api_version == '2.0'
      @@api_base = 'https://app.trustev.com/api/v'
    end
  end

  def self.send_request(path, body, method, expect_json=false, requires_token=true)

    expect_json = true if @@api_version == '2.0'

    if requires_token && invalid_token?
      Authenticate.retrieve_token
    end

    raise Error.new('Auth token missing or expired') if requires_token && invalid_token?

    headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    headers['X-Authorization'] = "#{@@username} #{@@token}" if requires_token

    body = { request:  body } if @@api_version == '1.2'

    options = { body: body.to_json, headers: headers}

    response = HTTParty.post(api_url(path), options) if method == 'POST'
    response = HTTParty.get(api_url(path), options) if method == 'GET'
    response = HTTParty.put(api_url(path), options) if method == 'PUT'
    response = HTTParty.delete(api_url(path), options) if method == 'DELETE'

    raise Error.new('Bad API response', response.code, response.message) if response.code != 200

    if expect_json
      begin
        response = MultiJson.load(response.body, symbolize_keys: true)
      rescue MultiJson::DecodeError
        raise Error.new('Invalid API response', response.code, response.message)
      end
    end

    response
  end

  private

  def self.invalid_token?
    if @@api_version == '1.2'
      now = Time.now.to_i
    elsif @@api_version == '2.0'
      now = Time.now
    end
    @@token.nil? || @@token_expire-600 <= now
  end
end
