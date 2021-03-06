require 'openssl'

module Trustev
  class Authenticate

    SERVICE_URL = 'AuthenticationService.svc/rest/Token'

    def self.retrieve_token

      raise Error.new('No Username provided.') unless Trustev.username
      raise Error.new('No Password provided.') unless Trustev.password
      raise Error.new('No Shared Secret provided.') unless Trustev.shared_secret

      time = Time.now.utc

      body = {
        UserName: Trustev.username,
        Password: password(time),
        Sha256Hash: sha256hash(time),
        Timestamp: "\/Date(#{time.to_i*1000})\/"
      }

      response = Trustev.send_request SERVICE_URL, body, 'POST', true, false
      Trustev.token = response[:Token][:APIToken]
      Trustev.token_expire = response[:Token][:ExpireAt][/\((.*)\)/m, 1].to_i/1000
    end

    private

    def self.password(time)
      generate_hash Trustev.password, time
    end

    def self.sha256hash(time)
      generate_hash Trustev.username, time
    end

    def self.generate_hash(modifier, time)
      sha256 = OpenSSL::Digest::SHA256.new
      sha256 << "#{time.strftime '%Y%m%d%H%M%S'}.#{modifier}"
      hash_part_1 = sha256.hexdigest
      sha256 = OpenSSL::Digest::SHA256.new
      sha256 << "#{hash_part_1}.#{Trustev.shared_secret}"
      sha256.hexdigest
    end
  end
end
