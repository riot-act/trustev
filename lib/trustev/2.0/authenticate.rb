require 'openssl'
require 'time'

module Trustev
  class Authenticate

    SERVICE_URL = 'Token'

    def self.retrieve_token

      raise Error.new('No Username provided.') unless Trustev.username
      raise Error.new('No Password provided.') unless Trustev.password
      raise Error.new('No Shared Secret provided.') unless Trustev.shared_secret

      time = Trustev::Timestamp.new

      body = {
        UserName: Trustev.username,
        Timestamp: time.to_s,
        PasswordHash: sha256hash(Trustev.password, time),
        UserNameHash: sha256hash(Trustev.username, time),
      }

      response = Trustev.send_request SERVICE_URL, body, 'POST', true, false
      Trustev.token = response[:APIToken]
      Trustev.token_expire = Trustev::Timestamp.new(Time.parse response[:ExpireAt])
    end

    private

    def self.sha256hash(to_hash, time)
      sha256 = OpenSSL::Digest::SHA256.new
      sha256 << "#{time.to_s}.#{to_hash}"
      hash_part_1 = sha256.hexdigest
      sha256 = OpenSSL::Digest::SHA256.new
      sha256 << "#{hash_part_1}.#{Trustev.shared_secret}"
      sha256.hexdigest
    end
  end
end
