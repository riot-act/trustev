require 'httparty'

require 'trustev/version'
require 'trustev/authenticate'
require 'trustev/profile'
require 'trustev/social'
require 'trustev/transaction'

module Trustev
  @@username = nil
  @@password = nil
  @@shared_secret = nil
  @@api_base = 'https://api.trustev.com/v'
  @@api_version = nil

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

  def self.api_url(url='')
    @@api_base + api_version + url
  end

  def self.api_version=(version)
    @@api_version = version
  end

  def self.api_version
    @@api_version
  end

  def send_request(path, body)
    HTTParty.post(api_url(path),
                  {
                    body: body.to_json,
                    headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
                  })
  end
end
