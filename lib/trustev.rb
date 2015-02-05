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
  end

  def self.do_send_request(path, body, method, expect_json=false, requires_token=true)
    Authenticate.retrieve_token if requires_token && invalid_token?

    raise Error.new('Auth token missing or expired') if requires_token && invalid_token?

    headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    headers['X-Authorization'] = "#{@@username} #{@@token}" if requires_token

    options = { body: body.to_json, headers: headers}

    response = HTTParty.post(api_url(path), options) if method == 'POST'
    response = HTTParty.get(api_url(path), options) if method == 'GET'
    response = HTTParty.put(api_url(path), options) if method == 'PUT'
    response = HTTParty.delete(api_url(path), options) if method == 'DELETE'
    if response.code != 200
      raise_error response
    end

    if expect_json
      begin
        response = MultiJson.load(response.body, symbolize_keys: true)
      rescue MultiJson::DecodeError
        raise Error.new('Invalid API response', response.code, response.message)
      end
    end

    response
  end
end
