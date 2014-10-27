require 'digest'

module Trustev
  class Authenticate
    def self.retrieve_token

      raise Error.new('No Username provided.') unless @username
      raise Error.new('No Password provided.') unless @password
      raise Error.new('No Shared Secret provided.') unless @shared_secret

      time = Time.now

      body = [
          {
              UserName: @username,
              Password: password(time),
              Sha256Hash: sha256hash(time),
              Timestamp: "\/Date(#{time.to_i.to_s})\/"
          }
      ]

      response = send_request 'AuthenticationService.svc/rest/Token', body, 'POST', true
      @token = response[:Token][:APIToken]
      @token_expire = response[:Token][:ExpireAt][/\((.*)\)/m, 1].to_i
    end

    private

    def password(time)
      generate_hash @password, time
    end

    def sha256hash(time)
      generate_hash @username, time
    end

    def generate_hash(modifier, time)
      sha256 = Digest::SHA256.new
      sha256 << "#{time.strftime '%Y%m%d%H%M%S'}.#{modifier}"
      password_part_1 = sha256.hexdigest
      sha256 = Digest::SHA256.new
      sha256 << "#{password_part_1}.#{@shared_secret}"
      sha256.hexdigest
    end
  end
end