require 'httparty'
require 'multi_json'

require 'trustev/version'
require 'trustev/authenticate'
require 'trustev/profile'
require 'trustev/social'
require 'trustev/transaction'
require 'trustev/error'
require 'trustev/digital_signature'

module Trustev
  @@username = nil
  @@password = nil
  @@shared_secret = nil
  @@private_key = nil
  @@api_base = 'https://api.trustev.com/v'
  @@api_version = '1.2'
  @@token = nil
  @@token_expire = nil

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

  def self.send_request(path, body, method, expect_json=false, requires_token=true)

    if requires_token && invalid_token?
      Authenticate.retrieve_token
    end

    raise Error.new('Auth token missing or expired') if requires_token && invalid_token?

    headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    headers['X-Authorization'] = "#{@username} #{@token}" if requires_token

    body = { request:  body }

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
    @@token.nil? || @@token_expire-600 >= Time.now.to_i
  end
end
